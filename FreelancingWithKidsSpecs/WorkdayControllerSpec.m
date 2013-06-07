#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "WorkdayController.h"
#import "WorkdayStateMachine.h"
#import "WorkdayPresenter.h"
#import "Task.h"

OCDSpec2Context(WorkdayControllerSpec) {
  
  Describe(@"Using the presenter and state machine", ^{
    
    It(@"creates the presenter on viewDidLoad", ^{
      WorkdayController *cont = [[WorkdayController alloc] init];

      [cont viewDidLoad];

      [ExpectObj(cont.presenter) toBeKindOfClass:[WorkdayPresenter class]];
    });

    It(@"creates the state machine on viewDidLoad", ^{
      WorkdayController *cont = [[WorkdayController alloc] init];

      [cont viewDidLoad];

      [ExpectObj(cont.machine) toBeKindOfClass:[WorkdayStateMachine class]];
    });

    It(@"starts the day on view did load", ^{
      // I'm avoiding creating an abstract factory for the state machine,
      // but if I have to write more tests like this one (where I know too much about the internals)
      // then I should just do it
      WorkdayController *cont = [[WorkdayController alloc] init];

      [cont viewDidLoad];

      WorkdayPresenter *presenter = (WorkdayPresenter *)cont.presenter;

      [ExpectInt(presenter.taskCount) toBe:2];
    });

    It(@"sends startWorkingOn to the stateMachine", ^{
      id view = [OCMockObject mockForProtocol:@protocol(TaskView)];
      id stateMachine = [OCMockObject mockForProtocol:@protocol(StateMachine)];
      WorkdayController *cont = [[WorkdayController alloc] init];
      cont.machine = stateMachine;

      [(id<StateMachine>) [stateMachine expect] startTask:@"task name" withDelegate:view];

      [cont startWorkingOn:@"task name" withDelegate:view];

      [stateMachine verify];
    });

    It(@"initializes the clock from the presenter", ^{
      // This depends on the workday presenter.  If that changes, then you'll wanna fix this test to use the factories
      WorkdayController *cont = [[WorkdayController alloc] init];

      cont.clockOnTheWall = [[UILabel alloc] init];
      [cont viewDidLoad];

      [ExpectObj(cont.clockOnTheWall.text) toBeEqualTo:@"9:00"];
    });
  });
}
