#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "WorkdayStateMachine.h"
#import "ToDoList.h"
#import "FakeWorkdayClock.h"

OCDSpec2Context(WorkdayStateMachineSpec) {
  
  Describe(@"the workday state machine / interactor", ^{
    
    It(@"notifies any observer with the task list when the day is started", ^{
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

    It(@"watches clock ticks and fires notifications for others", ^{
      FakeWorkdayClock *clock = [FakeWorkdayClock new];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil clock:clock];

      id observer = [OCMockObject observerMock];
      [[NSNotificationCenter defaultCenter] addMockObserver:observer
                                                       name:@"clockTicked"
                                                     object:machine];
      [[observer expect] notificationWithName:@"clockTicked" object:machine userInfo:nil];

      [clock notifyWatcher:100];

      [observer verify];
    });

    It(@"Will stop starting daddy's workday, and instead will increase his stress on clock ticks", ^{

    });

    It(@"starts daddy's workday", ^{
      PendingStr(@"Deprecated");
      id freelancer = [OCMockObject mockForProtocol:@protocol(Freelancer)];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:freelancer];

      [(id<Freelancer>)[freelancer expect] start];
      
      [machine start];
      
      [freelancer verify];
    });
    
  });
}
