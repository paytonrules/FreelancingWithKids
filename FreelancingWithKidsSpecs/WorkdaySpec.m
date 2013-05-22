#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "Workday.h"
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
    self.status = (WorkdayStatus) [notification.userInfo[@"result"] intValue];
}

@end

OCDSpec2Context(WorkdaySpec) {

  
  Describe(@"the workday", ^{
    __block FakeWorkdayClock *fakeClock;
    __block ToDoList *todoList;
    __block Workday *day;
    __block GameObserver *observer;
    
    BeforeEach(^{
      fakeClock = [FakeWorkdayClock new];
      todoList = [ToDoList new];
      day = [Workday workdayWithTodoList: todoList andClock: fakeClock];
      observer = [GameObserver new];
      
      [[NSNotificationCenter defaultCenter] addObserver:observer
                                               selector:@selector(notified:)
                                                   name:@"gameOver"
                                                 object:nil];
    });
    
    AfterEach(^{
      [[NSNotificationCenter defaultCenter] removeObserver:observer name:@"gameOver" object:nil];
    });
    
    It(@"starts the clock when the day is started", ^{
      [day start];
      
      [fakeClock notifyWatcher:10];
      
      [ExpectInt(day.currentTimePassed) toBe:10];
    });
    
    It(@"notifies that the day is successful when there are no tasks", ^{
      [day start];
      [day clockTicked:0];
      
      [ExpectInt(observer.status) toBe:Successful];
    });
    
    It(@"notifies of the day failed when the day is over but the tasks aren't done", ^{
      [todoList add:[Task taskWithName:@"name" andDuration:10]];
      
      [day start];
      [day clockTicked:28800];
      
      [ExpectInt(observer.status) toBe:Failed];
    });
    
    It(@"ends the day at 8 hours", ^{
      [todoList add:[Task taskWithName:@"name" andDuration:10]];
      
      [day start];
      [day clockTicked:28799];
      
      [ExpectInt(observer.status) toBe:None];
      
      [day clockTicked:1];
      
      [ExpectInt(observer.status) toBe:Failed];
    });
    
    It(@"doesn't notify anything if the tasks aren't done and the day isn't over", ^{
      [todoList add:[Task taskWithName:@"name" andDuration:10]];
            
      [day start];
      [day clockTicked:0];
      
      [ExpectInt(observer.status) toBe:None];
    });
    
    It(@"notifies of the day success when the tasks are done", ^{
      Task *task = [Task taskWithName:@"name" duration:1 andUpdatesPerSecond:1];
      [todoList add:task];
      [task updateProgress];
      
      [day start];
      [day clockTicked:1];
      
      [ExpectInt(observer.status) toBe:Successful];
    });
    
    It(@"prefers winning to losing - if the day is over but the tasks are done, you succeeded", ^{
      Task *task = [Task taskWithName:@"name" duration:1 andUpdatesPerSecond:1];
      [todoList add:task];
      [task updateProgress];
      
      [day start];
      [day clockTicked:28800];
      
      [ExpectInt(observer.status) toBe:Successful];
    });
  });
}
