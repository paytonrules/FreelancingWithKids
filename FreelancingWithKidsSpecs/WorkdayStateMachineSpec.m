#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "WorkdayStateMachine.h"
#import "ToDoList.h"
#import "FakeWorkdayClock.h"
#import "Task.h"
#import "WorkdayPresenter.h"
#import "FakePresenter.h"
#import "WorkdayStatus.h"

@interface TaskObserver : NSObject
@property(strong, nonatomic) ToDoList *tasks;
@end

@implementation TaskObserver

-(void) completeAllTasks
{
  for(int i = 0; i < self.tasks.count; i++) {
    [[self.tasks taskNumber:i] forceCompletion];
  }
}

-(void) initializeTasks:(NSNotification *) notification
{
  self.tasks = (ToDoList *)notification.userInfo[@"tasks"];
}

-(int) taskCount
{
  return self.tasks.count;
}
@end

void RunToEndOfDay(WorkdayStateMachine *machine)
{
  for (int i = 0; i < EIGHT_HOUR_DAY; i++)
    [machine clockTicked:1];
}

void CompleteAllTasks(ToDoList *tasks)
{
  for(int i = 0; i < tasks.count; i++) {
    [[tasks taskNumber:i] forceCompletion];
  }
}

OCDSpec2Context(WorkdayStateMachineSpec) {

  Describe(@"the workday state machine / interactor", ^{

    It(@"sets its presenter with the task list when the day is started", ^{
      FakePresenter *presenter = [FakePresenter new];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil presenter:presenter];

      [machine start];

      [ExpectInt(presenter.taskCount) toBe:2];
    });

    It(@"watches clock ticks and tells its presenter", ^{
      FakeWorkdayClock *clock = [FakeWorkdayClock new];
      id presenter = [OCMockObject niceMockForProtocol:@protocol(Presenter)];

      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil
                                                                      presenter:presenter
                                                                          clock:clock];
      [machine start];

      [[presenter expect] clockTicked];

      [clock notifyWatcher:100];

      [presenter verify];
    });

    It(@"Will inform the employee of clock ticks", ^{
      id daddy = [OCMockObject mockForProtocol:@protocol(Freelancer)];
      FakeWorkdayClock *clock = [FakeWorkdayClock new];

      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:daddy presenter:nil clock:clock];
      [machine start];

      [[daddy expect] clockTicked];

      [clock notifyWatcher:100];

      [daddy verify];
    });

    It(@"Announces the day is successful if all the tasks are complete on a tick", ^{
      FakePresenter *presenter = [FakePresenter new];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil presenter:presenter clock:nil];

      [machine start];
      [presenter completeAllTasks];
      [machine clockTicked:1];

      [ExpectBool([presenter gameOverWith:Successful]) toBeTrue];
    });

    It(@"Announces the day is over and you failed if time is up on a tick, but tasks aren't complete", ^{
      FakePresenter *presenter = [FakePresenter new];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil presenter:presenter clock:nil];

      [machine start];

      RunToEndOfDay(machine);

      [ExpectBool([presenter gameOverWith:Failed]) toBeTrue];
    });

    It(@"Stops the clock when the day is over", ^{
      FakeWorkdayClock *clock = [FakeWorkdayClock new];
      FakePresenter *presenter = [FakePresenter new];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil presenter: presenter clock:clock];

      [machine start];
      RunToEndOfDay(machine);

      [ExpectBool(clock.started) toBeFalse];
    });

    It(@"Stops the clock on a successful day too", ^{
      FakeWorkdayClock *clock = [FakeWorkdayClock new];
      FakePresenter *presenter = [FakePresenter new];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil presenter:presenter clock:clock];

      [machine start];
      [presenter completeAllTasks];
      [machine clockTicked:1];

      [ExpectBool(clock.started) toBeFalse];
    });

    It(@"doesn't notify anything if the tasks aren't done and the day isn't over", ^{
      FakePresenter *presenter = [FakePresenter new];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil presenter:presenter clock:nil];

      [machine start];
      [machine clockTicked:2];

      [ExpectBool([presenter gameOverWith:None]) toBeTrue];
    });

    It(@"prefers winning to losing - if the day is over but the tasks are done, you succeeded", ^{
      FakePresenter *presenter = [FakePresenter new];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil presenter:presenter clock:nil];

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
  });
}
