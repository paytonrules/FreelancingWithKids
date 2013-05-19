//
//  ViewController.m
//  FreelancingWithKids
//
//  Created by Eric Smith on 5/10/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import "WorkdayController.h"
#import "ToDoList.h"
#import "Task.h"
#import "TaskViewCell.h"

@interface WorkdayController ()
@property (strong, nonatomic) ToDoList *tasks;
@end

@implementation WorkdayController

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 90.0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  [self.taskList registerNib:[UINib nibWithNibName:@"TaskViewCell" bundle:nil] forCellReuseIdentifier:@"task"];
  
  self.tasks = [ToDoList new];
  [self.tasks add:[Task taskWithName:@"email"]];
  [self.tasks add:[Task taskWithName:@"meeting"]];
	// Do any additional setup after loading the view, typically from a nib.
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
  TaskViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"task"];
  Task *task = (Task *)[self.tasks taskNumber:indexPath.row];

  cell.task = task;
  
  return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.tasks.count;
}

// How do I disable this?
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // selecting this would be ...uh different?
  // delegate to the controller you can get from the cell?
  // Do nuttin'
  Task *task = (Task *)[self.tasks taskNumber:indexPath.row];
  TaskViewCell *cell = (TaskViewCell *)[self tableView:tableView cellForRowAtIndexPath: indexPath];
  
  [task start:cell];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
