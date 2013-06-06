#import <OCDSpec2/OCDSpec2.h>
#import <OCMock/OCMock.h>
#import "Daddy.h"
#import "Task.h"

OCDSpec2Context(DaddySpec) {
  
  Describe(@"the workday with a fake clock and provided task list", ^{
    __block Daddy *dad;

    BeforeEach(^{
      dad = [Daddy new];
    });

    It(@"begins stress at 0", ^{
      [ExpectInt(dad.stress) toBe:0];
    });
    
    It(@"starts working on a task", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(TaskView)];
      Task *task = [Task taskWithName:@"Name" andDuration:10];

      [dad startTask:task withDelegate: delegate];
      
      [ExpectBool(task.started) toBeTrue];
    });
    
    It(@"stops an old task to start a new one", ^{
      id delegate = [OCMockObject mockForProtocol:@protocol(TaskView)];
      Task *taskOne = [Task taskWithName:@"NameOne" andDuration:10];
      Task *taskTwo = [Task taskWithName:@"NameTwo" andDuration:10];
            
      [dad startTask:taskOne withDelegate: delegate];
      [dad startTask:taskTwo withDelegate: delegate];
      
      [ExpectBool(taskOne.started) toBeFalse];
      [ExpectBool(taskTwo.started) toBeTrue];
    });
    
    It(@"moves stress negatively when you are working (kids stress)", ^{
      Task *task = [Task taskWithName:@"me" andDuration:10];

      [dad startTask:task withDelegate:nil];
      
      [dad clockTicked];
      
      [ExpectInt(dad.stress) toBe:-10];
    });
    
    It(@"moves positively when you are playing (work stress)", ^{
      [dad playWithKid];
      [dad clockTicked];
      
      [ExpectInt(dad.stress) toBe:10];
    });
  });
}
