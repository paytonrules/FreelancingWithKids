#import <OCDSpec2/OCDSpec2.h>
#import "Workday.h"
#import "ToDoList.h"
#import "FakeWorkdayClock.h"

OCDSpec2Context(WorkdaySpec) {
  
  Describe(@"the workday", ^{
    
    It(@"starts watching the clock at the start", ^{
      FakeWorkdayClock *fakeClock = [FakeWorkdayClock new];
      ToDoList *todoList = [ToDoList new];
      Workday *day = [Workday workdayWithTodoList: todoList andClock: fakeClock];
      
      [day start];
      
      [ExpectBool(fakeClock.started) toBeTrue];
      
      // taht should start the clock
    });
    
  });
  
}
