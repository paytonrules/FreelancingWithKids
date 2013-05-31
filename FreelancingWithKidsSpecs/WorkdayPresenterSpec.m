#import <OCDSpec2/OCDSpec2.h>
#import "OCMock/OCMock.h"
#import "WorkdayView.h"
#import "WorkdayPresenter.h"
#import "Daddy.h"
#import "StateMachine.h"
#import "ToDoList.h"
#import "Task.h"

OCDSpec2Context(WorkdayPresenterSpec) {

  // stateMachine requires workday/daddy
  // presenter requires state machine
  // controller creates state machine/workday/daddy and wires.

  Describe(@"Workday Presenter", ^{

    It(@"delegates starting a workday to its machine", ^{
      id machine = [OCMockObject mockForProtocol:@protocol(StateMachine)];
      WorkdayPresenter *presenter = [WorkdayPresenter presenterWithMachine:machine view:nil];
      [(id<StateMachine>)[machine expect] start];

      [presenter startDay];

      [machine verify];
    });

    It(@"monitors the intialized task list", ^{
      WorkdayPresenter *presenter = [WorkdayPresenter presenterWithMachine:nil view:nil];

      ToDoList *tasks = [ToDoList new];
      [tasks add:[Task taskWithName:@"hello" andDuration:0]];

      [[NSNotificationCenter defaultCenter] postNotificationName:@"initialized"
                                                          object:self
                                                        userInfo:@{@"tasks": tasks}];

      [ExpectObj([presenter taskNameAt:0]) toBe:@"hello"];
    });

    It(@"monitors the stress of the daddy", ^{

    });

    // There are gaps in the testing here.  Originally I did not have this code tested, as it was part of the controller.
    // In an effort to prevent overengineering, I'm adding tests on an as-needed basis.
  });

}
