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
  NSLog(@"I AM AT THE RIGHT NOTIFICATION");
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
    
    // Test that you're wired to the timer
    // Test the notifications
    It(@"starts watching the clock at the start", ^{
      [day start];
      
      [ExpectBool(fakeClock.started) toBeTrue];
    });
    
    It(@"notifies that the day is successful when there are no tasks", ^{
      GameObserver *observer = [GameObserver new];
      [[NSNotificationCenter defaultCenter] addObserver:observer
                                               selector:@selector(notified:)
                                                  name:@"gameOver"
                                                  object:nil];
      
      [day start];
      [fakeClock notifyWatcher:0];
      
      [ExpectInt(observer.status) toBe:Successful];
    });
    
    It(@"notifies of the day failed when the day is over but the tasks aren't done", ^{
      [todoList add:[Task taskWithName:@"name" andDuration:10]];
      
      [day start];
      [fakeClock notifyWatcher:28800];
      
      [ExpectInt(observer.status) toBe:Failed];
    });
    
    It(@"doesn't notify anything if the tasks aren't done and the day isn't over", ^{
      [todoList add:[Task taskWithName:@"name" andDuration:10]];
      
      GameObserver *observer = [GameObserver new];

      [[NSNotificationCenter defaultCenter] addObserver:observer
                                               selector:@selector(notified:)
                                                   name:@"gameOver"
                                                 object:nil];
      
      [day start];
      [fakeClock notifyWatcher:0];
      
      [ExpectInt(observer.status) toBe:None];
      
    });
    

    
    It(@"notifies of the day success when the day is over and the tasks are done", ^{
    });
  });
}
