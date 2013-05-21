#import "FakeWorkdayClock.h"

@interface FakeWorkdayClock()

@property(strong, nonatomic) NSObject<ClockWatcher> *watcher;

@end

@implementation FakeWorkdayClock

-(void) start:(id<ClockWatcher>)watcher
{
  self.watcher = watcher;
  self.started = true;
}

-(void) notifyWatcher
{
}

@end
