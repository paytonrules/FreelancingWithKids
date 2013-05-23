#import <OCDSpec2/OCDSpec2.h>
#import "OCMock/OCMock.h"
#import "Task.h"
#import "TaskView.h"
#import "FakeWorkdayClock.h"
#import "TickingClock.h"

OCDSpec2Context(TaskSpec) {
  
  Describe(@"Work Tasks", ^{
    __block FakeWorkdayClock *clock;
    
    BeforeEach(^{
      clock = [FakeWorkdayClock new];
    });
    
    It(@"has a name", ^{
      Task *task = [Task taskWithName: @"name" andDuration:10];
      
      [ExpectObj(task.name) toBeEqualTo:@"name"];
    });
    
    It(@"updates the task with progress when the clock ticks", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(TaskView)];

      Task *task = [Task taskWithName: @"name" duration:3 andClock:clock];

      [[delegate expect] updateProgress:[OCMArg any]];

      [task start:delegate];
      [clock notifyWatcher:0];
      
      [delegate verify];
    });
    
    It(@"sends the current progress when the timer is fired", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(TaskView)];
      
      Task *task = [Task taskWithName: @"name" duration:4 andClock:clock];
      
      [[delegate expect] updateProgress:[[NSDecimalNumber alloc] initWithFloat:0.5]];
      
      [task start:delegate];
      [clock notifyWatcher:2];
      
      [delegate verify];
    });
    
    It(@"stops updating progress when the task is complete", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(TaskView)];
      
      [[delegate expect] updateProgress:[[NSDecimalNumber alloc] initWithFloat:1.0]];
      
      Task *task = [Task taskWithName: @"name" duration:1 andClock:clock];

      [task start:delegate];
      [clock notifyWatcher:1];
      [clock notifyWatcher:1.2];
      
      [delegate verify];
    });
    
    It(@"is complete when it's completed all its updates", ^{
      Task *task = [Task taskWithName: @"name" andDuration: 1];
      
      [ExpectBool([task complete]) toBeFalse];
      
      [task clockTicked:0.5];
      [task clockTicked:0.5];
      
      [ExpectBool([task complete]) toBeTrue];
    });
    
    It(@"creates a real workday clock when one isn't provided", ^{
      Task *task = [Task taskWithName:@"name" duration:2 andUpdatesPerSecond:3];
      
      [ExpectObj([task.clock class]) toBe: [TickingClock class]];
    });
    
    It(@"uses the updates per second to configure the wall clock", ^{
      Task *task = [Task taskWithName:@"name" duration:2 andUpdatesPerSecond:2];
      
      [ExpectFloat(((TickingClock *) task.clock).interval) toBe: 0.5 withPrecision:0.001];
    });
    
    It(@"defaults to 10 updates per second", ^{
      Task *task = [Task taskWithName: @"name" andDuration:1];
      
      [ExpectFloat(((TickingClock *) task.clock).interval) toBe: 0.1 withPrecision:0.001];
    });
  });
}
