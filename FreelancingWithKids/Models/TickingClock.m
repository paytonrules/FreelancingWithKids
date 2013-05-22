#import "TickingClock.h"

@interface TickingClock()

@property(nonatomic, strong) NSTimer *timer;
@property(assign) NSTimeInterval interval;
@property(nonatomic, strong) id<ClockWatcher> watcher;

@end

@implementation TickingClock

- (id)initWithTimeInterval:(NSTimeInterval) interval
{
    self = [super init];
    if (self) {
      self.interval = interval;
    }
    return self;
}

+(id) clockWithUpdateInterval:(NSTimeInterval) interval
{
  return [[TickingClock alloc] initWithTimeInterval:interval];
}

-(void) start:(id<ClockWatcher>)watcher
{
  self.watcher = watcher;
  self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval
                                                target:self
                                              selector:@selector(updateWatcher)
                                              userInfo:nil
                                               repeats:YES];
}

-(void) stop
{
  [self.timer invalidate];
}

-(void) updateWatcher
{
  [self.watcher clockTicked:self.interval];
}

@end
