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
  [self.taskList registerNib:[UINib nibWithNibName:@"TaskViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
  self.tickingClock = [TickingClock clockWithUpdateInterval:18.75];
  [self.tickingClock registerWatcher:self];
  
  self.tasks = [ToDoList new];
  [self.tasks add:[Task taskWithName:@"email" andDuration:3]];
  [self.tasks add:[Task taskWithName:@"meeting" andDuration:10]];

  self.day = [Workday workdayWithTodoList:self.tasks andClock:self.tickingClock];
  [self.day start];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
  TaskViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  Task *task = (Task *)[self.tasks taskNumber:indexPath.row];

  cell.task = task;
  
  return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.tasks.count;
}

-(void) clockTicked:(NSTimeInterval)interval
{
  self.increments++;
  int hours = 8 + (self.increments / 4);
  int minutes = 15 * (self.increments % 4);
  
  self.clockOnTheWall.text = [NSString stringWithFormat:@"%d:%02d", hours, minutes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
