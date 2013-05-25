#import <OCDSpec2/OCDSpec2.h>
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
    self.status = (WorkdayStatus) [notification.userInfo[DAY_RESULT] intValue];
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
                                                   name:DAY_OVER_NOTIFICATION
                                                 object:nil];
    });
    
    AfterEach(^{
      [[NSNotificationCenter defaultCenter] removeObserver:observer name:DAY_OVER_NOTIFICATION object:nil];
    });
    
    It(@"starts the clock when the day is started", ^{
      [day start];
      
      [ExpectBool(fakeClock.started) toBeTrue];
    });
    
    It(@"notifies that the day is successful when there are no tasks", ^{
      [day start];
      [day clockTicked:0];
      
      [ExpectInt(observer.status) toBe:Successful];
    });
    
    It(@"notifies that the day failed when the day is over (32 ticks of the clock) but the tasks aren't done", ^{
      [todoList add:[Task taskWithName:@"name" andDuration:10]];
      
      [day start];
      [day clockTicked:0];
      
      [ExpectInt(observer.status) toBe:None];
      
      for (int i = 0; i < EIGHT_HOUR_DAY; i++) {
        [day clockTicked:0];
      }
      
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
      [task clockTicked:1];
      
      [day start];
      [day clockTicked:0];
      
      [ExpectInt(observer.status) toBe:Successful];
    });
    
    It(@"prefers winning to losing - if the day is over but the tasks are done, you succeeded", ^{
      Task *task = [Task taskWithName:@"name" duration:1 andUpdatesPerSecond:1];
      [todoList add:task];
      [task clockTicked:1.0];
      
      [day start];
      for (int i = 0; i < EIGHT_HOUR_DAY; i++) {
        [day clockTicked:0];
      }
      
      [ExpectInt(observer.status) toBe:Successful];
    });
    
    It(@"stops the clock when the day is over", ^{
      Task *task = [Task taskWithName:@"name" duration:1 andUpdatesPerSecond:1];
      [todoList add:task];

      [day start];
      for (int i = 0; i < EIGHT_HOUR_DAY; i++) {
        [day clockTicked:0];
      }
      
      [ExpectBool(fakeClock.started) toBeFalse];
    });
    
    It(@"stops the clock when the day is over because tasks are done", ^{
      [day start];
      [day clockTicked:0];
      
      [ExpectBool(fakeClock.started) toBeFalse];
    });
  });
}
