#import "FakeWorkdayClock.h"

@interface FakeWorkdayClock()

@property(strong, nonatomic) NSObject<ClockWatcher> *watcher;

@end

@implementation FakeWorkdayClock

-(void) start:(id<ClockWatcher>)watcher
{
  self.watcher = watcher;
  [self start];
}

-(void) start
{
  self.started = true;
}

-(void) registerWatcher:(id<ClockWatcher>) watcher
{
  self.watcher = watcher;
}

-(void) notifyWatcher:(NSTimeInterval) timeInterval
{
  if (self.watcher != nil)
    [self.watcher clockTicked: timeInterval];
}

-(void) stop
{
  self.started = false;
  self.watcher = nil;
}

@end
