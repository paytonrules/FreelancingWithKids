#import <Foundation/Foundation.h>
#import "WallClock.h"


enum _WorkdayStatus {
  None,
  Successful,
  Failed
};

typedef enum _WorkdayStatus WorkdayStatus;
FOUNDATION_EXPORT NSString *const DAY_OVER_NOTIFICATION;
FOUNDATION_EXPORT NSString *const DAY_RESULT;

extern int const EIGHT_HOUR_DAY;

@class ToDoList;

@interface Workday : NSObject<ClockWatcher>

+(id) workdayWithTodoList: (ToDoList *)todoList andClock: (id<WallClock>) fakeClock;
-(void) start;

@end
