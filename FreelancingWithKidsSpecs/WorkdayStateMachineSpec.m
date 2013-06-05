#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "WorkdayStateMachine.h"
#import "ToDoList.h"
#import "FakeWorkdayClock.h"
#import "Task.h"

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
  for (int i = 0; i <= EIGHT_HOUR_DAY; i++)
    [machine clockTicked:1];
}

OCDSpec2Context(WorkdayStateMachineSpec) {
  __block TaskObserver *taskObserver;
  __block id gameOverObserver;
  __block id clockObserver;
  
  Describe(@"the workday state machine / interactor", ^{

    BeforeEach(^{
      gameOverObserver = [OCMockObject observerMock];
      clockObserver = [OCMockObject observerMock];
      taskObserver = [TaskObserver new];
    });

    AfterEach(^{
      [[NSNotificationCenter defaultCenter] removeObserver:taskObserver];
      [[NSNotificationCenter defaultCenter] removeObserver:gameOverObserver];
      [[NSNotificationCenter defaultCenter] removeObserver:clockObserver];
    });

    It(@"notifies any observer with the task list when the day is started", ^{
      WorkdayStateMachine *machine = [WorkdayStateMachine new];
      [[NSNotificationCenter defaultCenter] addObserver:taskObserver
                                               selector:@selector(initializeTasks:)
                                                   name:@"initialized"
                                                 object:machine];
      
      [machine start];

      [ExpectInt([taskObserver taskCount]) toBe:2];
    });

    It(@"watches clock ticks and fires notifications for others", ^{
      FakeWorkdayClock *clock = [FakeWorkdayClock new];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil clock:clock];
      [machine start];

      [[NSNotificationCenter defaultCenter] addMockObserver:clockObserver
                                                       name:@"clockTicked"
                                                     object:machine];
      [[clockObserver expect] notificationWithName:@"clockTicked" object:machine userInfo:nil];

      [clock notifyWatcher:100];

      [clockObserver verify];
    });

    It(@"Will inform the employee of clock ticks", ^{
      id daddy = [OCMockObject mockForProtocol:@protocol(Freelancer)];
      FakeWorkdayClock *clock = [FakeWorkdayClock new];

      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:daddy clock:clock];
      [machine start];

      [[daddy expect] clockTicked];

      [clock notifyWatcher:100];

      [daddy verify];
    });

    It(@"Announces the day is over if all the tasks are complete on a tick", ^{
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil clock:nil];

      [[NSNotificationCenter defaultCenter] addObserver:taskObserver
                                               selector:@selector(initializeTasks:)
                                                   name:@"initialized"
                                                 object:nil];

      [[NSNotificationCenter defaultCenter] addMockObserver:gameOverObserver name:DAY_OVER_NOTIFICATION object:nil];

      [[gameOverObserver expect] notificationWithName:DAY_OVER_NOTIFICATION
                                               object:machine
                                             userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                                               return userInfo[DAY_RESULT] == [NSNumber numberWithInt:Successful];
                                             }]];

      [machine start];
      [taskObserver completeAllTasks];
      [machine clockTicked:1];

      [gameOverObserver verify];
    });

    It(@"Announces the day is over and you failed if time is up on a tick, but tasks aren't complete", ^{
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil clock:nil];

      [[NSNotificationCenter defaultCenter] addObserver:taskObserver
                                               selector:@selector(initializeTasks:)
                                                   name:@"initialized"
                                                 object:nil];

      [[NSNotificationCenter defaultCenter] addMockObserver:gameOverObserver name:DAY_OVER_NOTIFICATION object:nil];

      [[gameOverObserver expect] notificationWithName:DAY_OVER_NOTIFICATION
                                       object:machine
                                     userInfo:[OCMArg checkWithBlock:^BOOL(NSDictionary *userInfo) {
                                       return userInfo[DAY_RESULT] == [NSNumber numberWithInt:Failed];
                                     }]];

      [machine start];

      RunToEndOfDay(machine);

      [gameOverObserver verify];
    });

    It(@"Stops the clock when the day is over", ^{
      FakeWorkdayClock *clock = [FakeWorkdayClock new];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil clock:clock];

      [[NSNotificationCenter defaultCenter] addObserver:taskObserver
                                               selector:@selector(initializeTasks:)
                                                   name:@"initialized"
                                                 object:nil];
      [machine start];
      RunToEndOfDay(machine);


      [ExpectBool(clock.started) toBeFalse];
    });

    It(@"Stops the clock on a successful day too", ^{
      FakeWorkdayClock *clock = [FakeWorkdayClock new];
      WorkdayStateMachine *machine = [WorkdayStateMachine machineWithFreeLancer:nil clock:clock];

      [[NSNotificationCenter defaultCenter] addObserver:taskObserver
                                               selector:@selector(initializeTasks:)
                                                   name:@"initialized"
                                                 object:nil];

      [machine start];
      [taskObserver completeAllTasks];
      [machine clockTicked:1];

      [ExpectBool(clock.started) toBeFalse];
    });

  });
}
