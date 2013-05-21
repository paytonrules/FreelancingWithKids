#import <Foundation/Foundation.h>
#import "WorkdayClock.h"

@class ToDoList;

@interface Workday : NSObject<ClockWatcher>

+(id) workdayWithTodoList: (ToDoList *)todoList andClock: (id<WorkdayClock>) fakeClock;
-(void) start;

@end
