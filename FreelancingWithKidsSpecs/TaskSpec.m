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

      [[delegate expect] updateProgress:[OCMArg any]];

      [task start:delegate];
      [task.timer fire];
      
      [delegate verify];
    });
    
    It(@"sends the current progress when the timer is fired", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(TaskView)];
      
      Task *task = [Task taskWithName: @"name" andDuration:4];
      
      [[delegate expect] updateProgress:[[NSDecimalNumber alloc] initWithFloat:0.25f]];
      
      [task start:delegate];
      [task.timer fire];
      
      [delegate verify];
    });
    
    It(@"stops firing updating progress when the task is complete", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(TaskView)];
      
      [[delegate expect] updateProgress:[[NSDecimalNumber alloc] initWithFloat:1.0f]];
      
      Task *task = [Task taskWithName: @"name" andDuration:1];

      [task start:delegate];
      [task.timer fire];
      [task.timer fire];
      
      [delegate verify];
    });

    It(@"is a legit timer", ^{
      
    });
  });
  
}
