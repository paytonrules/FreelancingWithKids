#import <OCDSpec2/OCDSpec2.h>
#import "WorkdayController.h"
#import "WorkdayStateMachine.h"
#import "WorkdayPresenter.h"

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
    
  });
  
}
