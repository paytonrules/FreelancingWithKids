#import "WorkdayPresenter.h"
#import "WorkdayView.h"
#import "TickingClock.h"
#import "ToDoList.h"
#import "Daddy.h"
#import "Task.h"

@interface WorkdayPresenter()

@property(nonatomic, retain) id<WorkdayView> view;
@property (strong, nonatomic) ToDoList *tasks;
@property (strong, nonatomic) id<WallClock> tickingClock;

// I don't like this guy
@property (assign) int increments;

-(void) updateClockOnTheWall;

@end

@implementation WorkdayPresenter

+(id) presenterWithView:(id<WorkdayView>) view
{
  return [[WorkdayPresenter alloc] initWithView:view];
}

- (id)initWithView:(id<WorkdayView>) view
{
    self = [super init];
    if (self) {
      self.view = view;
      self.increments = 0;
    }
    return self;
}

-(void) startDay
{
  // I'm not sure the presenter should have a clock
  self.tickingClock = [TickingClock clockWithUpdateInterval:18.5];
  [self.tickingClock registerWatcher:self];
  
  // This won't belong here once generating tasks becomes part of the game
  self.tasks = [ToDoList new];
  [self.tasks add:[Task taskWithName:@"email" andDuration:3]];
  [self.tasks add:[Task taskWithName:@"meeting" andDuration:10]];
  
  // self.day should become a "new day" command
  self.day = [Daddy workdayWithTodoList:self.tasks andClock:self.tickingClock];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameOver:) name:DAY_OVER_NOTIFICATION object:nil];
  [self.day addObserver:self forKeyPath:@"stress" options:NSKeyValueObservingOptionNew context:nil];
  
  [self updateClockOnTheWall];
  [self.day start];
}

-(NSString *) taskNameAt:(NSInteger) row
{
  return [self.tasks taskNumber:row].name;
}

-(void) startWorkingOn: (NSString *) name withDelegate:(id<TaskView>) view
{
  [self.day startWorkingOn:name withDelegate:view];
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
