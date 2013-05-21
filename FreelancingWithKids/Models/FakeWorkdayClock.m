#import "FakeWorkdayClock.h"

@implementation FakeWorkdayClock

-(void) start:(id<ClockWatcher>)watcher
{
  self.started = true;
}

@end
