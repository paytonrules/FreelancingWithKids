#import "WorkdayPresenter.h"
#import "TickingClock.h"
#import "ToDoList.h"
#import "Daddy.h"
#import "Task.h"
#import "WorkdayStateMachine.h"
#import "StateMachine.h"

@interface WorkdayPresenter()

@property(nonatomic, strong) id<WorkdayView> view;
@property (strong, nonatomic) ToDoList *tasks;
@property(strong, nonatomic) id<StateMachine> machine;
@property (strong, nonatomic) id<WallClock> tickingClock;

// I don't like this guy
@property (assign) int increments;

-(void) updateClockOnTheWall;

@end

@implementation WorkdayPresenter

- (id)initWithMachine:(id <StateMachine>)machine view:(id <WorkdayView>)view {
  self = [super init];
  if (self) {
    self.view = view;
    self.machine = machine;
    self.increments = 0;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeTasks:)
                                                 name:@"initialized"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clockTicked:)
                                                 name:@"clockTick"
                                               object:nil];
  }
  return self;
}

+(id) presenterWithMachine:(id <StateMachine>)machine view:(id <WorkdayView>)view {
  return [[WorkdayPresenter alloc] initWithMachine: machine view:view];
}

-(void) startDay
{
  // I'm not sure the presenter should have a clock
  // It doesn't but....
/*
  self.tickingClock = [TickingClock clockWithUpdateInterval:18.5];
  [self.tickingClock registerWatcher:self];

  // self.day should become a "new day" command
  self.daddy = [Daddy workdayWithTodoList:self.tasks andClock:self.tickingClock];*/

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(gameOver:)
                                               name:DAY_OVER_NOTIFICATION
                                             object:nil];
  // Know when a clock ticks

/*
  [self.daddy addObserver:self
               forKeyPath:@"stress"
                  options:NSKeyValueObservingOptionNew
                  context:nil];        */


  [self.machine start];

  // Needed?
//  [self updateClockOnTheWall];
}

-(void) storeTasks:(NSNotification *) notification
{
  self.tasks = notification.userInfo[@"tasks"];
}

-(NSString *) taskNameAt:(NSInteger) row
{
  return [self.tasks taskNumber:row].name;
}

-(void) startWorkingOn: (NSString *) name withDelegate:(id<TaskView>) view
{
  [self.daddy startWorkingOn:name withDelegate:view];
}

-(void) clockTicked:(NSTimeInterval)interval
{
  self.increments++;
  [self updateClockOnTheWall];
}

// Test
-(void) updateClockOnTheWall
{
  int hours = 9 + (self.increments / 4);
  if (hours > 12)
    hours -= 12;
  int minutes = 15 * (self.increments % 4);

  [self.view updateClockWith:[NSString stringWithFormat:@"%d:%02d", hours, minutes]];
}

-(int) taskCount
{
  return self.tasks.count;
}

-(void) gameOver:(NSNotification *) notification
{
  if ([notification.userInfo[DAY_RESULT] intValue] == Successful) {
    [self.view showYouWin];
  } else {
    [self.view showYouLose];
  }
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqual:@"stress"]) {
    float percentage = ([[change objectForKey:NSKeyValueChangeNewKey] floatValue] + 50.0f) / 100.0f;
    
    [self.view updateProgress:percentage];
  }
}

@end
