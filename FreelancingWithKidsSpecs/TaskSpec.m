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
    
    It(@"updates the task with progress when the timer fires", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(TaskView)];

      Task *task = [Task taskWithName: @"name" andDuration:3];

      [[delegate expect] updateProgress];

      [task start:delegate];
      [task.timer fire];
      
      [delegate verify];
    });
    
  });
  
}
