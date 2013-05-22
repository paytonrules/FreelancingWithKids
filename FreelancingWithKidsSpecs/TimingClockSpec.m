#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "TimingClock.h"
#import "ClockWatcher.h"

OCDSpec2Context(TimingClockSpec) {
  
  Describe(@"A real clock using the timer", ^{
    
    It(@"creates a new NSTimer on start", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(ClockWatcher)];
      TimingClock *clock = [TimingClock clockWithUpdateInterval:600];
      
      [clock start:delegate];
      
      [ExpectObj(clock.timer) toExist];
      [ExpectFloat(clock.timer.timeInterval) toBe:600 withPrecision:0.1];
    });
    
    It(@"calls its delegate when the timer fires", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(ClockWatcher)];
      TimingClock *clock = [TimingClock clockWithUpdateInterval:600];
      
      [[delegate expect] clockTicked:600];
      
      [clock start:delegate];
      [clock.timer fire];
      
      [delegate verify];
    });
    
    It(@"is scheduled", ^{
      
    });
    
    It(@"can be ended", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(ClockWatcher)];
      TimingClock *clock = [TimingClock clockWithUpdateInterval:600];
      
      [clock start:delegate];
      
      [clock stop];
      
      [ExpectBool(clock.timer.isValid) toBeFalse];
      
    });
    
  });
  
}
