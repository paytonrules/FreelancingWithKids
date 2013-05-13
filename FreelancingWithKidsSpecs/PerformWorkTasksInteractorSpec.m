#import <OCDSpec2/OCDSpec2.h>
#import "PerformWorkTask.h"
#import "PerformWorkTaskDelegate.h"
#import "Task.h"
#import "OCMock/OCMock.h"

OCDSpec2Context(PerformWorkInteractorSpec) {
  
  Describe(@"performTaskInteraction", ^{
    
    It(@"begins a work task by name", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(PerformWorkTaskDelegate)];
      Task *task = [Task taskWithName:@"email"];
      
      [[delegate expect] taskStarted:task];
      
      PerformWorkTask *interaction = [PerformWorkTask performWorkTaskWithDelegate: delegate];
      
      [interaction addTask: task];

      [interaction startTask: @"email"];
      
      [delegate verify];
    });
    
    // task started
    // task progress
    // task complete
    // task done
    
  });
  
}
