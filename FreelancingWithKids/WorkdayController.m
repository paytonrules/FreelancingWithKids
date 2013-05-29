#import "WorkdayController.h"
#import "TaskViewCell.h"
#import "WorkdayPresenter.h"

@interface WorkdayController ()

@property (strong, nonatomic) WorkdayPresenter *presenter;
@end

static NSString *reuseIdentifier = @"task";

@implementation WorkdayController
   
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.presenter = [WorkdayPresenter presenterWithView:self];
  [self.presenter startDay];
  
  [self.taskList registerNib:[UINib nibWithNibName:@"TaskViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
  TaskViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  NSString *taskName = [self.presenter taskNameAt:indexPath.row];

  cell.name = taskName;
  cell.controller = self; // Self will delegate to the presenter
  
  return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.presenter.taskCount;
}

-(void) updateClockWith:(NSString *)time
{
  self.clockOnTheWall.text = time;
}

-(void) startWorkingOn: (NSString *) name withDelegate:(id<TaskView>) view
{
  [self.presenter startWorkingOn:name withDelegate:view];
}

-(void) showYouWin
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Day Over" message:@"YOU WIN" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

-(void) showYouLose
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Day Over" message:@"YOU LOSE" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];  
}

-(void) updateProgress:(float) progress
{
  [self.stressBar setProgress:progress animated:YES];
}

-(void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
