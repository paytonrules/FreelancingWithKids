#import <OCDSpec2/OCDSpec2.h>
#import "PerformWorkTask.h"
#import "Task.h"

OCDSpec2Context(PerformWorkInteractorSpec) {
  
  Describe(@"performTaskInteraction", ^{
    
    It(@"begins a work task by name", ^{
      Task *task = [Task taskWithName:@"email"];
      PerformWorkTask *interaction = [PerformWorkTask new];
      
      [interaction addTask: task];
      
      
    });
    
  });
  
}
