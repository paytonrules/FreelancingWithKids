#import "WorkdayController.h"
#import "ToDoList.h"
#import "Task.h"
#import "TaskViewCell.h"

@interface WorkdayController ()
@property (strong, nonatomic) ToDoList *tasks;
@end

static NSString *reuseIdentifier = @"task";

@implementation WorkdayController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  [self.taskList registerNib:[UINib nibWithNibName:@"TaskViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
  
  self.tasks = [ToDoList new];
  [self.tasks add:[Task taskWithName:@"email" andDuration:3]];
  [self.tasks add:[Task taskWithName:@"meeting" andDuration:10]];
	// Do any additional setup after loading the view, typically from a nib.
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
