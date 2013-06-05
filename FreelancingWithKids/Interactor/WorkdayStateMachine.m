#import <TransitionKit/TransitionKit.h>
#import "WorkdayStateMachine.h"
#import "ToDoList.h"
#import "Task.h"

int const EIGHT_HOUR_DAY = 32;
NSString *const DAY_RESULT = @"result";
NSString *const DAY_OVER_NOTIFICATION = @"gameOver";


@interface WorkdayStateMachine()

@property(nonatomic, strong) id<Freelancer> employee;
@property(nonatomic, strong) TKStateMachine *stateMachine;
@property(nonatomic, strong) id<WallClock> clock;
@property(nonatomic, strong) ToDoList *tasks;
@property(assign) int numTicks;

@end

@implementation WorkdayStateMachine
-(id) init
{
  return [self initWithFreeLancer:nil];
}

-(id) initWithFreeLancer:(id<Freelancer>) employee
{
  return [self initWithFreeLancer:employee clock:nil];
}

-(id) initWithFreeLancer:(id<Freelancer>) employee clock:(id<WallClock>) clock
{
  self = [super init];
  if (self) {
    self.employee = employee;
    self.clock = clock;

    self.stateMachine = [TKStateMachine new];

    TKState *wakingUp = [TKState stateWithName:@"wakingup"];
    [wakingUp setDidExitStateBlock:^(TKState *state, TKStateMachine *stateMachine) {
      [self setupInitialTasks];
      [self startClock];
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

+(id) machineWithFreeLancer:(id<Freelancer>)employee
{
  return [[WorkdayStateMachine new] initWithFreeLancer:employee];
}

+(id) machineWithFreeLancer:(id <Freelancer>)freelancer clock:(id <WallClock>)clock {
  return [[WorkdayStateMachine new] initWithFreeLancer:freelancer clock:clock];
}

-(void) startClock {
  [self.clock start:self];
}

-(void) setupInitialTasks
{
  self.tasks = [ToDoList new];
  [self.tasks add:[Task taskWithName:@"email" andDuration:3]];
  [self.tasks add:[Task taskWithName:@"meeting" andDuration:10]];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"initialized"
                                                      object:self
                                                    userInfo:@{@"tasks": self.tasks}];
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
  [[NSNotificationCenter defaultCenter] postNotificationName:@"clockTicked"
                                                      object: self];

  [self.employee clockTicked];
}

-(void) notifyOfSuccessfulDay
{
  [[NSNotificationCenter defaultCenter] postNotificationName:DAY_OVER_NOTIFICATION
                                                      object:self
                                                    userInfo:@{DAY_RESULT: [NSNumber numberWithInt:Successful]}];
}

-(void) notifyOfFailedDay
{
  [[NSNotificationCenter defaultCenter] postNotificationName:DAY_OVER_NOTIFICATION
                                                      object:self
                                                    userInfo:@{DAY_RESULT: [NSNumber numberWithInt:Failed]}];
}

-(void) start
{
  NSError *error = nil;
  [self.stateMachine fireEvent:@"start" error:&error];
}

- (void)clockTicked:(NSTimeInterval)interval {
  NSError *error = nil;
  [self.stateMachine fireEvent:@"tick" error:&error];
}

@end
