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
#import "TaskController.h"

@interface WorkdayController ()
@property (strong, nonatomic) ToDoList *tasks;
@end

@implementation WorkdayController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  self.tasks = [ToDoList new];
  [self.tasks add:[Task taskWithName:@"email"]];
  [self.tasks add:[Task taskWithName:@"meeting"]];
	// Do any additional setup after loading the view, typically from a nib.
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
  TaskViewCell *cell = (TaskViewCell *)[tableView dequeueReusableCellWithIdentifier:@"task"];
  TaskController *controller = nil;
  Task *task = (Task *)[self.tasks taskNumber:indexPath.row];
  
  if (cell == nil)
  {
    controller = [TaskController new];
    [[NSBundle mainBundle] loadNibNamed:@"TaskViewCell" owner:controller options:nil];
    cell = controller.view;
  }
  else
  {
    controller = cell.controller;
  }
  controller.task = task;
  
  return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.tasks.count;
}

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
