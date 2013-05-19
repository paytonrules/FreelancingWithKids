#import "Task.h"
#import "TaskView.h"

@interface Task()
@property(strong) NSTimer *timer;
@property(strong, nonatomic) id<TaskView> view;
@end

@implementation Task

+(id) taskWithName: (NSString *) name
{
  return [Task taskWithName:name andDuration:0];
}

+(id) taskWithName: (NSString *) name andDuration:(NSInteger) seconds
{
  Task *task = [Task new];
  task.name = name;
  
  return task;
}


-(void) start:(id<TaskView>) view
{
  self.view = view;
  self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

-(void) updateProgress
{
  [self.view updateProgress];
}

@end
