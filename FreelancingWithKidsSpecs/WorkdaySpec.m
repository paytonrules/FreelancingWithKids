#import <OCDSpec2/OCDSpec2.h>
#import "Workday.h"
#import "ToDoList.h"
#import "FakeWorkdayClock.h"

@interface GameObserver : NSObject

-(void) notified: (NSNotification *) notification;
-(BOOL) notifiedWith: (NSString *) status;

@property(strong, nonatomic) NSString *status;

@end

@implementation GameObserver

-(void) notified: (NSNotification *) notification
{
  if (notification.userInfo[@"successful"]) {
    self.status = @"success";
  }
}

-(BOOL) notifiedWith: (NSString *) status
{
  return [self.status compare:status] == 0;
}

@end

OCDSpec2Context(WorkdaySpec) {
  
  Describe(@"the workday", ^{
    
    It(@"starts watching the clock at the start", ^{
      FakeWorkdayClock *fakeClock = [FakeWorkdayClock new];
      ToDoList *todoList = [ToDoList new];
      Workday *day = [Workday workdayWithTodoList: todoList andClock: fakeClock];
      
      [day start];
      
      [ExpectBool(fakeClock.started) toBeTrue];
    });
    
    It(@"notifies that the day is successful when there are no tasks", ^{
      FakeWorkdayClock *fakeClock = [FakeWorkdayClock new];
      ToDoList *todoList = [ToDoList new];
      Workday *day = [Workday workdayWithTodoList: todoList andClock: fakeClock];
      
      GameObserver *observer = [GameObserver new];
      [[NSNotificationCenter defaultCenter] addObserver:observer
                                              selector:@selector(notified)
                                                  name:@"gameOver"
                                                  object:nil];
      
      [day start];
      [fakeClock notifyWatcher];
      
      [ExpectBool([observer notifiedWith:@"success"]) toBeTrue];
      
    });
    
    // It doesn't do anything if the tasks aren't done and they day isn't over
    // It notifies of the day failed when the day
    
  });
  
}
