//
//  ViewController.m
//  FreelancingWithKids
//
//  Created by Eric Smith on 5/10/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import "WorkdayController.h"
#import "Task.h"

@interface WorkdayController ()
@property (strong, nonatomic) NSMutableArray *tasks;
@end

@implementation WorkdayController

-(id) initWithTasks:(NSMutableArray *)tasks
{
  if (self = [super init])
  {
    self.tasks = tasks;
  }
  return self;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"task"];
  
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"task"];
  }
  
  Task *task = (Task *)[self.tasks objectAtIndex:0];
  [cell.textLabel setText: task.name];
  
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
