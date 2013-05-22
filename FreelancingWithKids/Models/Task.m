#import "Task.h"
#import "TaskView.h"

@interface Task()
@property(assign) int timeSpent;
@property(assign) int duration;
@property(assign) float durationInUpdates;
@property(strong) NSTimer *timer;
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
  
  return task;
}

-(void) start:(id<TaskView>) view
{
  self.view = view;
  self.timer = [NSTimer scheduledTimerWithTimeInterval:self.updateInterval target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

-(BOOL) complete
{
  return self.timeSpent >= self.durationInUpdates;
}

-(void) updateProgress
{
  self.timeSpent++;
  float progress = (float) self.timeSpent / (float) self.durationInUpdates;
  [self.view updateProgress:[[NSDecimalNumber alloc] initWithFloat:progress]];
  
  if (self.complete)
    self.timer = nil;
}

@end
