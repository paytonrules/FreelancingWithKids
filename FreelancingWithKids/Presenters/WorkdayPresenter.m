#import "WorkdayPresenter.h"
#import "ToDoList.h"
#import "Task.h"

@interface WorkdayPresenter()
@property(nonatomic, strong) id<WorkdayView> view;
@property (assign) int increments;
@end

@implementation WorkdayPresenter

@synthesize todoList;

- (id)initWithView:(id <WorkdayView>)view {
  self = [super init];
  if (self) {
    self.view = view;

    self.increments = 0;
  }
  return self;
}

+(id) presenterWithView:(id <WorkdayView>)view {
  return [[WorkdayPresenter alloc] initWithView:view];
}

-(NSString *) taskNameAt:(NSInteger) row
{
  return [self.todoList taskNumber:row].name;
}

-(void) clockTicked
{
  self.increments++;
  [self updateClockOnTheWall];
}

-(void) updateStress:(int) stressAmount
{
  float percentage = (stressAmount + 50.0f) / 100.0f;

  [self.view updateProgress:percentage];
}

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
  return self.todoList.count;
}

-(void) gameOver:(enum _WorkdayStatus) status
{
  if ( status == Successful) {
    [self.view showYouWin];
  } else {
    [self.view showYouLose];
  }
}

@end
