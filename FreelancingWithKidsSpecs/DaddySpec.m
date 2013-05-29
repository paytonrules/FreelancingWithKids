#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "Daddy.h"
#import "ToDoList.h"
#import "Task.h"
#import "FakeWorkdayClock.h"

@interface GameObserver : NSObject

-(void) notified: (NSNotification *) notification;
@property(assign) WorkdayStatus status;

@end

@implementation GameObserver

-(void) notified: (NSNotification *) notification
{
  if (self.status == None)
    self.status = (WorkdayStatus) [notification.userInfo[DAY_RESULT] intValue];
}

@end

OCDSpec2Context(DaddySpec) {
  
  Describe(@"the workday with a fake clock and provided task list", ^{
    __block FakeWorkdayClock *fakeClock;
    __block ToDoList *todoList;
    __block Daddy *dad;
    __block GameObserver *observer;
    
    BeforeEach(^{
      fakeClock = [FakeWorkdayClock new];
      todoList = [ToDoList new];
      dad = [Daddy workdayWithTodoList: todoList andClock: fakeClock];
      observer = [GameObserver new];
      
      [[NSNotificationCenter defaultCenter] addObserver:observer
                                               selector:@selector(notified:)
                                                   name:DAY_OVER_NOTIFICATION
                                                 object:nil];
    });
    
    AfterEach(^{
      [[NSNotificationCenter defaultCenter] removeObserver:observer name:DAY_OVER_NOTIFICATION object:nil];
    });
    
    It(@"starts the clock when the day is started", ^{
      [dad start];
      
      [ExpectBool(fakeClock.started) toBeTrue];
    });
    
    It(@"notifies that the day is successful when there are no tasks", ^{
      [dad start];
      [dad clockTicked:0];
      
      [ExpectInt(observer.status) toBe:Successful];
    });
    
    It(@"notifies that the day failed when the day is over (32 ticks of the clock) but the tasks aren't done", ^{
      [todoList add:[Task taskWithName:@"name" andDuration:10]];
      
      [dad start];
      [dad clockTicked:0];
      
      [ExpectInt(observer.status) toBe:None];
      
      for (int i = 0; i < EIGHT_HOUR_DAY; i++) {
        [dad clockTicked:0];
      }
      
      [ExpectInt(observer.status) toBe:Failed];
    });
    
    It(@"doesn't notify anything if the tasks aren't done and the day isn't over", ^{
      [todoList add:[Task taskWithName:@"name" andDuration:10]];
            
      [dad start];
      [dad clockTicked:0];
      
      [ExpectInt(observer.status) toBe:None];
    });
    
    It(@"notifies of the day success when the tasks are done", ^{
      Task *task = [Task taskWithName:@"name" duration:1 andUpdatesPerSecond:1];
      [todoList add:task];
      [task clockTicked:1];
      
      [dad start];
      [dad clockTicked:0];
      
      [ExpectInt(observer.status) toBe:Successful];
    });
    
    It(@"prefers winning to losing - if the day is over but the tasks are done, you succeeded", ^{
      Task *task = [Task taskWithName:@"name" duration:1 andUpdatesPerSecond:1];
      [todoList add:task];
      [task clockTicked:1.0];
      
      [dad start];
      for (int i = 0; i < EIGHT_HOUR_DAY; i++) {
        [dad clockTicked:0];
      }
      
      [ExpectInt(observer.status) toBe:Successful];
    });
    
    It(@"stops the clock when the day is over", ^{
      Task *task = [Task taskWithName:@"name" duration:1 andUpdatesPerSecond:1];
      [todoList add:task];

      [dad start];
      for (int i = 0; i < EIGHT_HOUR_DAY; i++) {
        [dad clockTicked:0];
      }
      
      [ExpectBool(fakeClock.started) toBeFalse];
    });
    
    It(@"stops the clock when the day is over because tasks are done", ^{
      [dad start];
      [dad clockTicked:0];
      
      [ExpectBool(fakeClock.started) toBeFalse];
    });
    
    It(@"begins stress at 0", ^{
      [ExpectInt(dad.stress) toBe:0];
    });
    
    It(@"starts working on a task", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(TaskView)];
      Task *task = [Task taskWithName:@"Name" andDuration:10];
      
      [todoList add:task];
      
      [dad startWorkingOn:@"Name" withDelegate: delegate];
      
      [ExpectBool(task.started) toBeTrue];
    });
    
    It(@"stops an old task to start a new one", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(TaskView)];
      Task *taskOne = [Task taskWithName:@"NameOne" andDuration:10];
      Task *taskTwo = [Task taskWithName:@"NameTwo" andDuration:10];
      
      [todoList add:taskOne];
      [todoList add:taskTwo];
            
      [dad startWorkingOn:@"NameOne" withDelegate: delegate];
      [dad startWorkingOn:@"NameTwo" withDelegate: delegate];
      
      [ExpectBool(taskOne.started) toBeFalse];
      [ExpectBool(taskTwo.started) toBeTrue];
    });
    
    It(@"moves stress negatively when you are working (kids stress)", ^{
      Task *task = [Task taskWithName:@"me" andDuration:10];
      [todoList add:task];
      
      [dad start];
      [dad startWorkingOn:@"me" withDelegate:nil];
      
      [dad clockTicked:0];
      
      [ExpectInt(dad.stress) toBe:-10];
    });
    
    It(@"moves positively when you are playing (work stress)", ^{
      [dad start];
      [dad playWithKid];
      [dad clockTicked:0];
      
      [ExpectInt(dad.stress) toBe:10];
    });
  });
}
