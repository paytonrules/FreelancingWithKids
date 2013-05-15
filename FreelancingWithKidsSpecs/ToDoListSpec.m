#import <OCDSpec2/OCDSpec2.h>
#import "Task.h"
#import "ToDoList.h"

OCDSpec2Context(ToDoListSpec) {
  
  Describe(@"My ToDoList", ^{
    
    It(@"allows adding and retrieving a task", ^{
      ToDoList *list = [ToDoList new];
      
      [list add:[Task taskWithName: @"email"]];
      
      Task *task = [list taskNumber:0];
      
      [ExpectObj(task.name) toBe:@"email"];
    });
    
    It(@"allows adding more than one task", ^{
      ToDoList *list = [ToDoList new];
      
      [list add:[Task taskWithName:@"email"]];
      [list add:[Task taskWithName: @"meeting"]];
      
      Task *task = [list taskNumber:0];
      
      [ExpectObj(task.name) toBe:@"email"];
    });
    
    It(@"tells me how many tasks there are", ^{
      ToDoList *list = [ToDoList new];
      
      [list add:[Task taskWithName:@"email"]];
      [list add:[Task taskWithName: @"meeting"]];
      
      [ExpectInt(list.count) toBe:2];
    });
    
  });
  
}
