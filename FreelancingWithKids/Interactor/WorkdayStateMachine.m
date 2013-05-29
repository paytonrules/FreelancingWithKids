
#import "WorkdayStateMachine.h"
#import "ToDoList.h"
#import "Task.h"

@implementation WorkdayStateMachine

-(void) start
{
  ToDoList *tasks = [ToDoList new];
  [tasks add:[Task taskWithName:@"email" andDuration:3]];
  [tasks add:[Task taskWithName:@"meeting" andDuration:10]];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"initialized"
                                                      object:self
                                                    userInfo:@{@"tasks": tasks}];
}

@end
