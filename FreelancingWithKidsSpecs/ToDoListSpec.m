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
    
  });
  
}
