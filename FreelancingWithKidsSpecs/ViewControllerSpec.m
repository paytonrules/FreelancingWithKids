#import <OCDSpec2/OCDSpec2.h>
#import "Task.h"
#import "ViewController.h"

OCDSpec2Context(ViewControllerSpec) {
  
  Describe(@"tableDataSource", ^{
    
    It(@"returns a the first task", ^{
      NSMutableArray *tasks = [NSMutableArray array];
      Task *task = [Task taskWithName: @"email"];
      [tasks addObject:task];
      
      ViewController *controller = [[ViewController alloc] initWithTasks:tasks];
      
      UITableView *tableView = [UITableView new];
      NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
      
      UITableViewCell *cell = [controller tableView:tableView cellForRowAtIndexPath: indexPath];
      [ExpectObj(cell.detailTextLabel.text) toBeEqualTo: @"email"];
    });
                                
                                
    
  });
  
}
