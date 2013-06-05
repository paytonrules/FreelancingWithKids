#import "Daddy.h"
#import "Task.h"

@interface Daddy ()

@property (assign) int numTicks;
@property (assign) int stress;
@property (nonatomic, strong) Task *currentTask;

-(void) clearCurrentTask;
@end

@implementation Daddy

-(void) clockTicked
{
  self.numTicks += 1;
  if (self.currentTask == nil)
    self.stress += 10;
  else
    self.stress -= 10;
}

-(void) startWorkingOn:(Task *) task withDelegate: (id<TaskView>) view
{
  [self clearCurrentTask];
  self.currentTask = task;

  [self.currentTask start:view];
}

-(void) playWithKid
{
  [self clearCurrentTask];
}

-(void) clearCurrentTask
{
  if (self.currentTask != nil)
    [self.currentTask stop];
  
  self.currentTask = nil;
}

@end
