#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "WorkdayStateMachine.h"
#import "ToDoList.h"

OCDSpec2Context(WorkdayStateMachineSpec) {
  
  Describe(@"the workday state machine / interactor", ^{
    
    It(@"initializes things when the day is started", ^{
      WorkdayStateMachine *machine = [WorkdayStateMachine new];
      id observer = [OCMockObject observerMock];
      [[NSNotificationCenter defaultCenter] addMockObserver:observer
                                                       name:@"initialized"
                                                     object:machine];
      
      [[observer expect] notificationWithName:@"initialized" object:machine userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
        return ((ToDoList *)(userInfo[@"tasks"])).count == 2;
      }]];
      
      [machine start];
      
      [observer verify];
    });
    
  });
}
