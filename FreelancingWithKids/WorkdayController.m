#import "WorkdayController.h"
#import "ToDoList.h"
#import "Task.h"
#import "TaskViewCell.h"
#import "TickingClock.h"
#import "Workday.h"

@interface WorkdayController ()
@property (strong, nonatomic) ToDoList *tasks;
@property (strong, nonatomic) Workday *day;
@property (strong, nonatomic) id<WallClock> tickingClock;

@property (assign) int increments;
@end

static NSString *reuseIdentifier = @"task";

@implementation WorkdayController
   
- (void)viewDidLoad
{
    [super viewDidLoad];
  
  self.increments = 0;
  
  // Main ?
  // Beginning of state machine
  [self.taskList registerNib:[UINib nibWithNibName:@"TaskViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
  self.tickingClock = [TickingClock clockWithUpdateInterval:18.5];
  [self.tickingClock registerWatcher:self];
  
  self.tasks = [ToDoList new];
  [self.tasks add:[Task taskWithName:@"email" andDuration:3]];
  [self.tasks add:[Task taskWithName:@"meeting" andDuration:10]];

  self.day = [Workday workdayWithTodoList:self.tasks andClock:self.tickingClock];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameOver:) name:DAY_OVER_NOTIFICATION object:nil];
  [self updateClockOnTheWall];
  [self.day start];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
  TaskViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  Task *task = (Task *)[self.tasks taskNumber:indexPath.row];

  cell.name = task.name;
  cell.day = self.day;
  
  return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.tasks.count;
}

-(void) clockTicked:(NSTimeInterval)interval
{
  self.increments++;
  [self updateClockOnTheWall];
}

// Test?
-(void) updateClockOnTheWall
{
  int hours = 9 + (self.increments / 4);
  if (hours > 12)
    hours -= 12;
  int minutes = 15 * (self.increments % 4);
  
  self.clockOnTheWall.text = [NSString stringWithFormat:@"%d:%02d", hours, minutes];
}

-(void) gameOver:(NSNotification *) notification
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Day Over" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
  if ([notification.userInfo[DAY_RESULT] intValue] == Successful) {
    alert.message = @"YOU WIN";
  } else {
    alert.message = @"YOU LOSE";
  }
  
  [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
