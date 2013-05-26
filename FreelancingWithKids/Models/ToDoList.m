
#import "ToDoList.h"
#import "Task.h"

@interface ToDoList()

@property(nonatomic, strong) NSMutableDictionary *tasks;
@property(nonatomic, strong) NSMutableArray *taskOrder;

@end

@implementation ToDoList

- (id)init
{
    self = [super init];
    if (self) {
      self.tasks = [NSMutableDictionary new];
      self.taskOrder = [NSMutableArray new];
    }
    return self;
}

-(void) add:(Task *)task
{
  self.tasks[task.name] = task;
  [self.taskOrder addObject:task.name];
}

-(int) count
{
  return self.tasks.count;
}

-(Task *) taskByName:(id)name
{
  return self.tasks[name];
}

-(Task *) taskNumber:(NSInteger) task
{
  return self.tasks[self.taskOrder[task]];
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
