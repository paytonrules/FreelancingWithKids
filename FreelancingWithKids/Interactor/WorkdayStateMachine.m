#import <TransitionKit/TransitionKit.h>
#import "WorkdayStateMachine.h"
#import "ToDoList.h"
#import "Task.h"
#import "Daddy.h"

@interface WorkdayStateMachine()

@property(nonatomic, strong) id<Freelancer> employee;

@end

@implementation WorkdayStateMachine

+(id) machineWithFreeLancer:(id<Freelancer>)employee
{
  WorkdayStateMachine *machine = [WorkdayStateMachine new];
  machine.employee = employee;
  return machine;
}

-(void) start
{
  ToDoList *tasks = [ToDoList new];
  [tasks add:[Task taskWithName:@"email" andDuration:3]];
  [tasks add:[Task taskWithName:@"meeting" andDuration:10]];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"initialized"
                                                      object:self
                                                    userInfo:@{@"tasks": tasks}];
  [self.employee start];
}

@end
