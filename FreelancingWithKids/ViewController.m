//
//  ViewController.m
//  FreelancingWithKids
//
//  Created by Eric Smith on 5/10/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import "ViewController.h"
#import "Task.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *tasks;
@end

@implementation ViewController

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
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"task"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  
  Task *task = (Task *)[self.tasks objectAtIndex:0];
  
  NSLog(@"cell %@", cell);
  NSLog(@"cell.textLabel %@", cell.detailTextLabel);
  cell.textLabel.text = task.name;
  return cell;
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
