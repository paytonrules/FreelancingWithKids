#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "TickingClock.h"
#import "ClockWatcher.h"

OCDSpec2Context(TickingClockSpec) {
  
  Describe(@"A real clock using the timer", ^{
    
    It(@"creates a new NSTimer on start", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(ClockWatcher)];
      TickingClock *clock = [TickingClock clockWithUpdateInterval:600];
      
      [clock start:delegate];
      
      [ExpectObj(clock.timer) toExist];
      [ExpectFloat(clock.timer.timeInterval) toBe:600 withPrecision:0.1];
    });
    
    It(@"calls its delegate when the timer fires", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(ClockWatcher)];
      TickingClock *clock = [TickingClock clockWithUpdateInterval:600];
      
      [[delegate expect] clockTicked:600];
      
      [clock start:delegate];
      [clock.timer fire];
      
      [delegate verify];
    });
    
    It(@"allows you to register other listeners before starting", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(ClockWatcher)];
      TickingClock *clock = [TickingClock clockWithUpdateInterval:600];
      
      [[delegate expect] clockTicked:600];
      
      [clock registerWatcher:delegate];
      [clock start];
      [clock.timer fire];
      
      [delegate verify];
    });
    
    It(@"allows you to mix and match watchers and call them both", ^{
      id delegateRegistered = [OCMockObject mockForProtocol:@protocol(ClockWatcher)];
      id delegateStarted = [OCMockObject mockForProtocol:@protocol(ClockWatcher)];
      TickingClock *clock = [TickingClock clockWithUpdateInterval:600];
      
      [[delegateRegistered expect] clockTicked:600];
      [[delegateStarted expect] clockTicked:600];
      
      [clock registerWatcher:delegateRegistered];
      [clock start:delegateStarted];
      [clock.timer fire];

      [delegateRegistered verify];
      [delegateStarted verify];
    });
    
    It(@"Doesnt register the same watcher twice", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(ClockWatcher)];
      TickingClock *clock = [TickingClock clockWithUpdateInterval:600];
      
      [[delegate expect] clockTicked:600];
      
      [clock registerWatcher:delegate];
      [clock start:delegate];
      [clock.timer fire];
      
      [delegate verify];
    });
    
    It(@"can be ended", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(ClockWatcher)];
      TickingClock *clock = [TickingClock clockWithUpdateInterval:600];
      
      [clock start:delegate];
      
      [clock stop];
      
      [ExpectBool(clock.timer.isValid) toBeFalse];
    });
  });
}
