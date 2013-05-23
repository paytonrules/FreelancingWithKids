#import "FakeWorkdayClock.h"

@interface FakeWorkdayClock()

@property(strong, nonatomic) NSObject<ClockWatcher> *watcher;

@end

@implementation FakeWorkdayClock

-(void) start:(id<ClockWatcher>)watcher
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
  self.watcher = nil;
}

@end
