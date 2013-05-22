#import <OCDSpec2/OCDSpec2.h>
#import "Workday.h"
#import "ToDoList.h"
#import "Task.h"
#import "FakeWorkdayClock.h"

@interface GameObserver : NSObject

-(void) notified: (NSNotification *) notification;
-(BOOL) notifiedWith: (NSString *) status;

@property(strong, nonatomic) NSString *status;

@end

@implementation GameObserver

-(void) notified: (NSNotification *) notification
{
  NSLog(@"NOTIFIED: @");
  if (notification.userInfo[@"successful"]) {
    self.status = @"success";
  }
}

-(BOOL) notifiedWith: (NSString *) status
{
  return (self.status != nil) && [self.status compare:status] == NSOrderedSame;
}

@end

OCDSpec2Context(WorkdaySpec) {

  
  Describe(@"the workday", ^{
    __block FakeWorkdayClock *fakeClock;
    __block ToDoList *todoList;
    __block Workday *day;
    
    BeforeEach(^{
      fakeClock = [FakeWorkdayClock new];
      todoList = [ToDoList new];
      day = [Workday workdayWithTodoList: todoList andClock: fakeClock];
    });
    
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
      [fakeClock notifyWatcher];
      
      [ExpectBool([observer notifiedWith:@"success"]) toBeTrue];
    });
    
    It(@"doesn't notify anything if the tasks aren't done and the day isn't over", ^{
      [todoList add:[Task taskWithName:@"name" andDuration:10]];
      
      GameObserver *observer = [GameObserver new];
      [ExpectBool([observer notifiedWith:@"success"]) toBeFalse];

      [[NSNotificationCenter defaultCenter] addObserver:observer
                                               selector:@selector(notified)
                                                   name:@"gameOver"
                                                 object:nil];
      
      [day start];
      [fakeClock notifyWatcher];
      
      [ExpectBool([observer notifiedWith:@"success"]) toBeFalse];
      
    });
    
    
    
    // It doesn't do anything if the tasks aren't done and they day isn't over
    // It notifies of the day failed when the day
    
  });
  
}
