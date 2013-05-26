#import <OCDSpec2/OCDSpec2.h>
#import "Task.h"
#import "ToDoList.h"

OCDSpec2Context(ToDoListSpec) {
  
  Describe(@"My ToDoList", ^{
    
    It(@"allows adding and retrieving a task", ^{
      ToDoList *list = [ToDoList new];
      
      [list add:[Task taskWithName: @"email" andDuration:1]];
      
      Task *task = [list taskByName:@"email"];
      
      [ExpectObj(task.name) toBe:@"email"];
    });
    
    It(@"allows adding more than one task", ^{
      ToDoList *list = [ToDoList new];
      
      [list add:[Task taskWithName:@"email" andDuration:1]];
      [list add:[Task taskWithName: @"meeting" andDuration:1]];
      
      Task *task = [list taskByName:@"email"];
      
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
      Task *task = [Task taskWithName:@"email" andDuration:1];
      
      [list add:task];
      
      [task clockTicked:1.0];
      
      [ExpectBool([list complete]) toBeTrue];
    });
    
    It(@"allows me to find a task by name", ^{
      ToDoList *list = [ToDoList new];
      Task *task = [Task taskWithName:@"email" andDuration:1];
      Task *taskTwo = [Task taskWithName:@"jimmy" andDuration:1];
      
      [list add:task];
      [list add:taskTwo];
      
      Task *foundTask = [list taskByName:@"jimmy"];
      
      [ExpectObj(taskTwo) toBe:foundTask];
    });
    
    It(@"keeps the order of the tasks as they are added", ^{
      ToDoList *list = [ToDoList new];
      Task *task = [Task taskWithName:@"email" andDuration:1];
      Task *taskTwo = [Task taskWithName:@"jimmy" andDuration:1];
      Task *taskThree = [Task taskWithName:@"chicken" andDuration:1];
      
      [list add:task];
      [list add:taskTwo];
      [list add:taskThree];
      
      Task *foundTask = [list taskNumber:0];
      [ExpectObj(foundTask) toBe:task];
      
      foundTask = [list taskNumber:1];
      [ExpectObj(foundTask) toBe:taskTwo];
      
      foundTask = [list taskNumber:2];
      [ExpectObj(foundTask) toBe:taskThree];
    });
  });
}
