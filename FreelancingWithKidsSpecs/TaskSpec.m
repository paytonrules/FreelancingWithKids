#import <OCDSpec2/OCDSpec2.h>
#import "OCMock/OCMock.h"
#import "Task.h"
#import "TaskView.h"

OCDSpec2Context(TaskSpec) {
  
  Describe(@"Work Tasks", ^{
    
    It(@"has a name", ^{
      Task *task = [Task taskWithName: @"name" andDuration:10];
      
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
      
      [[delegate expect] updateProgress:[OCMArg any]];
      
      [task start:delegate];
      [task.timer fire];
      
      [delegate verify];
    });
    
    It(@"updates a configurable number of times times per second", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(TaskView)];
      
      [[delegate expect] updateProgress:[[NSDecimalNumber alloc] initWithFloat:0.5]];
      [[delegate expect] updateProgress:[[NSDecimalNumber alloc] initWithFloat:1.0]];
      
      Task *task = [Task taskWithName: @"name" duration:1 andUpdatesPerSecond:2];
      
      [task start:delegate];
      [task.timer fire];
      [task.timer fire];
      
      [delegate verify];
    });
    
    It(@"stops firing updating progress when the task is complete", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(TaskView)];
      
      [[delegate expect] updateProgress:[[NSDecimalNumber alloc] initWithFloat:1.0]];
      
      Task *task = [Task taskWithName: @"name" duration:1 andUpdatesPerSecond:1];

      [task start:delegate];
      [task.timer fire];
      [task.timer fire];
      
      [delegate verify];
    });
    
    It(@"defaults to 10 updates per second", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(TaskView)];
      
      [[delegate expect] updateProgress:[[NSDecimalNumber alloc] initWithFloat:0.1]];
      
      Task *task = [Task taskWithName: @"name" andDuration:1];
      
      [task start:delegate];
      [task.timer fire];
    });
    
    It(@"is a legit timer on the run loop - with a real scheduled interval", ^{
      Task *task = [Task taskWithName: @"name" duration: 1 andUpdatesPerSecond:2];
      id delegate = [OCMockObject niceMockForProtocol:@protocol(TaskView)];
      
      [task start:delegate];
      
      [ExpectFloat(task.timer.timeInterval) toBe:0.5 withPrecision:0.001];
    });
  });
}
