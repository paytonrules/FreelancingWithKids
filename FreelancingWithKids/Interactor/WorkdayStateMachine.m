#import <TransitionKit/TransitionKit.h>
#import "WorkdayStateMachine.h"
#import "ToDoList.h"
#import "Task.h"
#import "WorkdayStatus.h"
#import "Presenter.h"
#import "TickingClock.h"

int const EIGHT_HOUR_DAY = 32;

@interface WorkdayStateMachine()

@property(nonatomic, strong) id<Freelancer> employee;
@property(nonatomic, strong) TKStateMachine *stateMachine;
@property(nonatomic, strong) ToDoList *tasks;
@property(nonatomic, strong) id<Presenter> presenter;
@property(assign) int numTicks;

@end

@implementation WorkdayStateMachine

@synthesize stress;

-(id) init
{
  return [self initWithFreeLancer:nil presenter:nil];
}

-(id) initWithFreeLancer:(id<Freelancer>) employee presenter:(id<Presenter>) presenter
{
  return [self initWithFreeLancer:employee presenter:presenter clock:[TickingClock clockWithUpdateInterval:10.0]];
}

-(id) initWithFreeLancer:(id<Freelancer>) employee presenter:(id<Presenter>) presenter clock:(id<WallClock>) clock
{
  self = [super init];
  if (self) {
    self.employee = employee;
    self.presenter = presenter;

    self.stateMachine = [TKStateMachine new];

    TKState *wakingUp = [TKState stateWithName:@"wakingup"];
    [wakingUp setDidExitStateBlock:^(TKState *state, TKStateMachine *stateMachine) {
      [self setupInitialTasks];
    }];

    TKState *working = [TKState stateWithName:@"working"];
    TKEvent *viewMessage = [TKEvent eventWithName:@"start"
                          transitioningFromStates:@[ wakingUp ]
                                          toState:working];

    TKState *checkingClock = [TKState stateWithName:@"checkingClock"];
    [checkingClock setDidEnterStateBlock:^(TKState *state, TKStateMachine *stateMachine) {
      [self tickClock];
      [self checkDayStatus];
    }];

    TKEvent *tickMessage = [TKEvent eventWithName:@"tick"
                          transitioningFromStates:@[ working ]
                                          toState:checkingClock];

    TKEvent *stillWorking = [TKEvent eventWithName:@"stillWorking"
                           transitioningFromStates:@[ checkingClock ]
                                           toState:working];

    TKState *successfulDay = [TKState stateWithName:@"successfulDay"];
    TKEvent *successfulDayMessage = [TKEvent eventWithName:@"successfulDay"
                                   transitioningFromStates:@[ checkingClock ]
                                                   toState:successfulDay];
    [successfulDay setDidEnterStateBlock:^(TKState *state, TKStateMachine *stateMachine) {
      [self notifyOfSuccessfulDay];
    }];

    TKState *failedDay = [TKState stateWithName:@"failedDay"];
    TKEvent *failedDayMessage = [TKEvent eventWithName:@"failedDay"
                               transitioningFromStates:@[ checkingClock ]
                                               toState:failedDay];
    [failedDay setDidEnterStateBlock:^(TKState *state, TKStateMachine *stateMachine) {
      [self notifyOfFailedDay];
    }];

    [self.stateMachine addStatesFromArray:@[wakingUp, working, checkingClock, successfulDay, failedDay]];
    [self.stateMachine addEventsFromArray:@[viewMessage, tickMessage, successfulDayMessage, stillWorking, failedDayMessage]];
    self.stateMachine.initialState = wakingUp;

    [self.stateMachine start];

  }
  return self;
}

+(id) machineWithFreeLancer:(id<Freelancer>) freelancer presenter:(id<Presenter>) presenter
{
  return [[WorkdayStateMachine alloc] initWithFreeLancer:freelancer presenter:presenter];
}

+(id) machineWithFreeLancer:(id<Freelancer>) freelancer presenter:(id<Presenter>) presenter clock:(id <WallClock>)clock
{
  return [[WorkdayStateMachine alloc] initWithFreeLancer:freelancer presenter:presenter clock:clock];
}

-(void) setupInitialTasks
{
  self.tasks = [ToDoList new];
  [self.tasks add:[Task taskWithName:@"email" andDuration:3]];
  [self.tasks add:[Task taskWithName:@"meeting" andDuration:10]];

  self.presenter.todoList = self.tasks;
}

-(void) checkDayStatus
{
  NSError *error = nil;
  if ([self.tasks complete]) {
    [self.stateMachine fireEvent:@"successfulDay" error:&error];

  } else if(self.numTicks >= EIGHT_HOUR_DAY) {
    [self.stateMachine fireEvent:@"failedDay" error:&error];
  } else {
    [self.stateMachine fireEvent:@"stillWorking" error:&error];
  }
}

-(void) tickClock
{
  self.numTicks++;
  [self.employee clockTicked];
  [self.presenter clockTicked];
  [self.presenter updateStress:self.employee.stress];
}

-(void) notifyOfSuccessfulDay
{
  [self.presenter gameOver:Successful];
}

-(void) notifyOfFailedDay
{
  [self.presenter gameOver:Failed];
}

- (void)startTask:(NSString *)taskName withDelegate:(id <TaskView>)view
{
  Task *task = [self.tasks taskByName:taskName];
  [self.employee startTask:task withDelegate:view];
}

-(void) playWithKid
{
  [self.employee playWithKid];
}

-(void) start
{
  NSError *error = nil;
  [self.stateMachine fireEvent:@"start" error:&error];
}

-(void) endTurn {
  NSError *error = nil;
  [self.stateMachine fireEvent:@"tick" error:&error];
}

@end
