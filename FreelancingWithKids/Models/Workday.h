#import <Foundation/Foundation.h>
#import "WorkdayClock.h"


enum _WorkdayStatus {
  None,
  Successful,
  Failed
};

typedef enum _WorkdayStatus WorkdayStatus;

@class ToDoList;

@interface Workday : NSObject<ClockWatcher>

+(id) workdayWithTodoList: (ToDoList *)todoList andClock: (id<WorkdayClock>) fakeClock;
-(void) start;

@end
