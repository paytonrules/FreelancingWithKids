
#import "ToDoList.h"
#import "Task.h"

@interface ToDoList()

@property(nonatomic, strong) NSMutableArray *tasks;

@end

@implementation ToDoList

- (id)init
{
    self = [super init];
    if (self) {
      self.tasks = [NSMutableArray new];
    }
    return self;
}

-(Task *) taskNumber:(NSInteger) taskNumber
{
  return [self.tasks objectAtIndex:taskNumber];
}

-(void) add:(Task *)task
{
  [self.tasks addObject:task];
}

-(int) count
{
  return self.tasks.count;
}

-(bool) complete
{
  if (self.count > 0) {
    for (Task *task in self.tasks) {
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
