#import <OCDSpec2/OCDSpec2.h>
#import "Task.h"
#import "ToDoList.h"

OCDSpec2Context(ToDoListSpec) {
  
  Describe(@"My ToDoList", ^{
    
    It(@"allows adding and retrieving a task", ^{
      ToDoList *list = [ToDoList new];
      
      [list add:[Task taskWithName: @"email" andDuration:1]];
      
      Task *task = [list taskNumber:0];
      
      [ExpectObj(task.name) toBe:@"email"];
    });
    
    It(@"allows adding more than one task", ^{
      ToDoList *list = [ToDoList new];
      
      [list add:[Task taskWithName:@"email" andDuration:1]];
      [list add:[Task taskWithName: @"meeting" andDuration:1]];
      
      Task *task = [list taskNumber:0];
      
      [ExpectObj(task.name) toBe:@"email"];
    });
    
    It(@"tells me how many tasks there are", ^{
      ToDoList *list = [ToDoList new];
      
      [list add:[Task taskWithName:@"email" andDuration:1]];
      [list add:[Task taskWithName: @"meeting" andDuration:1]];
      
      [ExpectInt(list.count) toBe:2];
    });
    
    It(@"is not complete if none of its tasks are complete", ^{
      ToDoList *list = [ToDoList new];

      [list add:[Task taskWithName:@"email" andDuration:1]];
      [list add:[Task taskWithName: @"meeting" andDuration:1]];
      
      [ExpectBool([list complete]) toBeFalse];
    });
    
    It(@"is complete if there are no tasks", ^{
      ToDoList *list = [ToDoList new];
      
      [ExpectBool([list complete]) toBeTrue];
    });
    
    It(@"is complete if all its tasks are complete", ^{
      ToDoList *list = [ToDoList new];
      Task *task = [Task taskWithName:@"email" duration:1 andUpdatesPerSecond:1];
      
      [list add:task];
      
      [task.timer fire];
      
      [ExpectBool([list complete]) toBeTrue];
    });
  });
}
