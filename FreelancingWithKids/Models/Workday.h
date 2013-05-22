#import <Foundation/Foundation.h>
#import "WallClock.h"


enum _WorkdayStatus {
  None,
  Successful,
  Failed
};

typedef enum _WorkdayStatus WorkdayStatus;

@class ToDoList;

@interface Workday : NSObject<ClockWatcher>

+(id) workdayWithTodoList: (ToDoList *)todoList andClock: (id<WallClock>) fakeClock;
@property (assign) NSTimeInterval currentTimePassed;
-(void) start;

@end
