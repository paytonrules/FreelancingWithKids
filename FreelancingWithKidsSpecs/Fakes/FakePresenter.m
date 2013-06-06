#import "FakePresenter.h"
#import "ToDoList.h"
#import "Task.h"

@interface FakePresenter()
@property(assign) BOOL status;
@end

@implementation FakePresenter
@synthesize todoList;

-(void)completeAllTasks
{
  for(int i = 0; i < self.todoList.count; i++) {
    [[self.todoList taskNumber:i] forceCompletion];
  }
}

-(BOOL) gameOverWith:(WorkdayStatus) status
{
  return status == self.status;
}

-(void) clockTicked
{

}

-(void) gameOver:(WorkdayStatus) status
{
  self.status = status;
}

-(int) taskCount
{
  return self.todoList.count;
}

-(NSString *) taskNameAt:(NSInteger)row
{
  return [[self.todoList taskNumber:row] name];
}


@end