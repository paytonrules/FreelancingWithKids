#import <OCDSpec2/OCDSpec2.h>
#import "Task.h"

OCDSpec2Context(TaskSpec) {
  
  Describe(@"Work Tasks", ^{
    
    It(@"has a name", ^{
      Task *task = [Task taskWithName: @"name"];
      
      [ExpectObj(task.name) toBeEqualTo:@"name"];
    });
    
  });
  
}
