#import "Task.h"
#import "TaskView.h"
#import "TickingClock.h"

@interface Task()
@property(assign) int timeSpent;
@property(assign) int duration;
@property(assign) float durationInUpdates;
@property(strong) id<WallClock> clock;
@property(strong, nonatomic) id<TaskView> view;
@property(assign) float updateInterval;
@end

@implementation Task

+(id) taskWithName: (NSString *) name andDuration:(NSInteger) seconds
{
  return [Task taskWithName:name duration:seconds andUpdatesPerSecond:10];
}

+(id) taskWithName: (NSString *) name duration:(NSInteger) duration andUpdatesPerSecond:(float) updatesPerSecond
{
  Task *task = [Task new];
  task.name = name;
  task.timeSpent = 0;
  task.duration = duration;
  task.updateInterval = 1 / updatesPerSecond;
  task.durationInUpdates = task.duration / task.updateInterval;
  
  // Create your wall clock here
  task.clock = [TickingClock clockWithUpdateInterval:task.updateInterval];
  
  return task;
}

+(id) taskWithName: (NSString *) name duration:(NSInteger) duration updatesPerSecond:(float) updatesPerSecond andClock:(id<WallClock>)clock
{
  Task *task = [Task new];
  task.name = name;
  task.timeSpent = 0;
  task.duration = duration;
  task.updateInterval = 1 / updatesPerSecond;
  task.durationInUpdates = task.duration / task.updateInterval;
  task.clock = clock;
  
  return task;
}

-(void) start:(id<TaskView>) view
{
  self.view = view;
  [self.clock start:self];
}

-(BOOL) complete
{
  return self.timeSpent >= self.durationInUpdates;
}

-(void) clockTicked:(NSTimeInterval)interval
{
  [self updateProgress];
}

-(void) updateProgress
{
  self.timeSpent++;
  float progress = (float) self.timeSpent / (float) self.durationInUpdates;
  [self.view updateProgress:[[NSDecimalNumber alloc] initWithFloat:progress]];
  
  if (self.complete)
      [self.clock stop];
}

@end
