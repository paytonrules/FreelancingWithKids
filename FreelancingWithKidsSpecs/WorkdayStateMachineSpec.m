#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "WorkdayStateMachine.h"
#import "ToDoList.h"
#import "FakeWorkdayClock.h"
#import "Task.h"
#import "WorkdayPresenter.h"
#import "FakePresenter.h"

void RunToEndOfDay(WorkdayStateMachine *machine)
{
  for (int i = 0; i < EIGHT_HOUR_DAY; i++)
    [machine endTurn];
}


OCDSpec2Context(WorkdayStateMachineSpec) {

  Describe(@"the workday state machine / interactor", ^{

    It(@"sets its presenter with the task list when the day is started", ^{
      FakePresenter *presenter = [FakePresenter new];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil presenter:presenter];

      [machine start];

      [ExpectInt(presenter.taskCount) toBe:2];
    });

    It(@"watches the clock ticked on every end turn", ^{
      id presenter = [OCMockObject niceMockForProtocol:@protocol(Presenter)];

      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil
                                                                      presenter:presenter];
      [machine start];

      [[presenter expect] clockTicked];

      [machine endTurn];

      [presenter verify];
    });

    It(@"Will inform the employee of clock ticks when the turn ends", ^{
      id daddy = [OCMockObject niceMockForProtocol:@protocol(Freelancer)];

      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:daddy presenter:nil];
      [machine start];

      [[daddy expect] clockTicked];

      [machine endTurn];

      [daddy verify];
    });

    It(@"Updates the presenter with daddy stress after the daddy is updated", ^{
      id daddy = [OCMockObject niceMockForProtocol:@protocol(Freelancer)];
      [[[daddy stub] andReturnValue:OCMOCK_VALUE((int){-20})] stress];
      FakePresenter *presenter = [FakePresenter new];

      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:daddy presenter:presenter];

      [machine start];
      [machine endTurn];

      [ExpectInt(presenter.stress) toBe:-20];
    });

    It(@"Announces the day is successful if all the tasks are complete when the turn ends", ^{
      FakePresenter *presenter = [FakePresenter new];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil presenter:presenter];

      [machine start];
      [presenter completeAllTasks];
      [machine endTurn];

      [ExpectBool([presenter gameOverWith:Successful]) toBeTrue];
    });

    It(@"Announces the day is over and you failed if time is up on a tick, but tasks aren't complete", ^{
      FakePresenter *presenter = [FakePresenter new];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil presenter:presenter];

      [machine start];

      RunToEndOfDay(machine);

      [ExpectBool([presenter gameOverWith:Failed]) toBeTrue];
    });

    It(@"doesn't notify anything if the tasks aren't done and the day isn't over", ^{
      FakePresenter *presenter = [FakePresenter new];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil presenter:presenter];

      [machine start];
      [machine endTurn];

      [ExpectBool([presenter gameOverWith:None]) toBeTrue];
    });

    It(@"prefers winning to losing - if the day is over but the tasks are done, you succeeded", ^{
      FakePresenter *presenter = [FakePresenter new];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil presenter:presenter];

      [machine start];
      [presenter completeAllTasks];
      RunToEndOfDay(machine);

      [ExpectBool([presenter gameOverWith:Successful]) toBeTrue];
    });

    It(@"starts the right task on daddy", ^{
      id daddy = [OCMockObject mockForProtocol:@protocol(Freelancer)];
      id view = [OCMockObject mockForProtocol:@protocol(TaskView)];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:daddy presenter:nil];

      [[daddy expect] startTask:[OCMArg checkWithBlock:^BOOL(Task *task) {
        return [task.name isEqualToString:@"meeting"];
      }] withDelegate:view];

      [machine start];
      [machine startTask:@"meeting" withDelegate:view];

      [daddy verify];
    });

    It(@"plays with the kids", ^{
      id daddy = [OCMockObject mockForProtocol:@protocol(Freelancer)];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:daddy presenter:nil];

      [[daddy expect] playWithKid];

      [machine playWithKid];

      [daddy verify];
    });
  });
}
