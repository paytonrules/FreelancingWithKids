#import <TransitionKit/TransitionKit.h>
#import "WorkdayStateMachine.h"
#import "ToDoList.h"
#import "Task.h"
#import "Daddy.h"
#import "WallClock.h"

@interface WorkdayStateMachine()

@property(nonatomic, strong) id<Freelancer> employee;
@property(nonatomic, strong) TKStateMachine *stateMachine;

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

    self.stateMachine = [TKStateMachine new];
    TKState *wakingUp = [TKState stateWithName:@"wakingup"];
    [wakingUp setDidExitStateBlock:^(TKState *state, TKStateMachine *stateMachine) {
      [self setupInitialTasks];
      [self startEmployeeDay];
    }];

    TKState *working = [TKState stateWithName:@"working"];


    TKEvent *viewMessage = [TKEvent eventWithName:@"start" transitioningFromStates:@[ wakingUp ] toState:working];

    [self.stateMachine addStatesFromArray:@[wakingUp, working]];
    [self.stateMachine addEventsFromArray:@[viewMessage]];
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

-(void) setupInitialTasks
{
  ToDoList *tasks = [ToDoList new];
  [tasks add:[Task taskWithName:@"email" andDuration:3]];
  [tasks add:[Task taskWithName:@"meeting" andDuration:10]];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"initialized"
                                                      object:self
                                                    userInfo:@{@"tasks": tasks}];
}

-(void) startEmployeeDay
{
  [self.employee start];
}

-(void) start
{
  NSError *error = nil;
  [self.stateMachine fireEvent:@"start" error:&error];
}

- (void)clockTicked:(NSTimeInterval)interval {
  [[NSNotificationCenter defaultCenter] postNotificationName:@"clockTicked"
                                                      object: self
                                                    userInfo: nil];
}

@end
