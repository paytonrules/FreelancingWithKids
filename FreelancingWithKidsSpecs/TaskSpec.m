#import <OCDSpec2/OCDSpec2.h>
#import "OCMock/OCMock.h"
#import "Task.h"
#import "TaskView.h"

OCDSpec2Context(TaskSpec) {
  
  Describe(@"Work Tasks", ^{
    
    It(@"has a name", ^{
      Task *task = [Task taskWithName: @"name"];
      
      [ExpectObj(task.name) toBeEqualTo:@"name"];
    });
    
    It(@"it can be started with a task delegate", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(TaskView)];
      
      Task *task = [Task taskWithName:@"name"];
      
      [task start:delegate];
    
    });
    
  });
  
}
