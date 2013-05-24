#import "TickingClock.h"

@interface TickingClock()

@property(nonatomic, strong) NSTimer *timer;
@property(assign) NSTimeInterval interval;
@property(nonatomic, strong) NSMutableSet *watchers;

@end

@implementation TickingClock

- (id)initWithTimeInterval:(NSTimeInterval) interval
{
    self = [super init];
    if (self) {
      self.interval = interval;
      self.watchers = [NSMutableSet new];
    }
    return self;
}

+(id) clockWithUpdateInterval:(NSTimeInterval) interval
{
  return [[TickingClock alloc] initWithTimeInterval:interval];
}

-(void) start:(id<ClockWatcher>)watcher
{
  [self registerWatcher: watcher];
  [self start];
}

-(void) start
{
  self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval
                                                target:self
                                              selector:@selector(updateWatcher)
                                              userInfo:nil
                                               repeats:YES];
  
}

-(void) registerWatcher:(id<ClockWatcher>)watcher
{
  [self.watchers addObject:watcher];
}

-(void) stop
{
  [self.timer invalidate];
}

-(void) updateWatcher
{
  for(id<ClockWatcher> watcher in self.watchers)
  {
    [watcher clockTicked:self.interval];
  }
}

@end
