#import "Task.h"
#import "TaskView.h"
#import "TickingClock.h"

@interface Task()
@property(assign) NSTimeInterval timeSpent;
@property(assign) int duration;
@property(strong) id<WallClock> clock;
@property(strong, nonatomic) id<TaskView> view;
@end

@implementation Task

+(id) taskWithName: (NSString *) name andDuration:(NSInteger) seconds
{
  return [Task taskWithName:name duration:seconds andUpdatesPerSecond:10];
}

+(id) taskWithName: (NSString *) name duration:(NSInteger) duration andUpdatesPerSecond:(float) updatesPerSecond
{
  NSTimeInterval updateInterval = 1 / updatesPerSecond;
  
  id<WallClock> clock = [TickingClock clockWithUpdateInterval:updateInterval];
  
  return [Task taskWithName:name duration: duration andClock: clock];
}

+(id) taskWithName: (NSString *) name duration:(NSInteger) duration andClock:(id<WallClock>)clock
{
  Task *task = [Task new];
  task.name = name;
  task.timeSpent = 0;
  task.duration = duration;
  task.clock = clock;
  
  return task;
}

-(void) start:(id<TaskView>) view
{
  self.view = view;
  [self.clock start:self];
}

-(BOOL) started
{
  return [self.clock ticking];
}

-(BOOL) complete
{
  return self.timeSpent >= self.duration;
}

-(void) clockTicked:(NSTimeInterval)interval
{
  self.timeSpent += interval;
  float progress = (float) self.timeSpent / (float) self.duration;
  [self.view updateProgress:[[NSDecimalNumber alloc] initWithFloat:progress]];
  
  if (self.complete)
    [self stop];
}

-(void) stop
{
  [self.clock stop];
}

-(void)forceCompletion
{
  self.timeSpent = self.duration + 1.0;
}
@end
