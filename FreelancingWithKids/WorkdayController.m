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
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"task"];
  
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"task"];
  }
  
  Task *task = (Task *)[self.tasks taskNumber:indexPath.row];
  [cell.textLabel setText: task.name];
  
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.tasks.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
