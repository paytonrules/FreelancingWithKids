
#import "ToDoList.h"
#import "Task.h"

@interface ToDoList()

@property(nonatomic, strong) NSMutableDictionary *tasks;

@end

@implementation ToDoList

- (id)init
{
    self = [super init];
    if (self) {
      self.tasks = [NSMutableDictionary new];
    }
    return self;
}

-(void) add:(Task *)task
{
  self.tasks[task.name] = task;
}

-(int) count
{
  return self.tasks.count;
}

-(Task *) taskByName:(id)name
{
  return self.tasks[name];
}

-(bool) complete
{
  if (self.count > 0) {
    for (NSString* name in self.tasks) {
      Task *task = [self.tasks objectForKey:name];
      if (task.complete == NO) {
        return NO;
      }
    }
    
    return YES;
  } else {
    return YES;
  }
}

@end
