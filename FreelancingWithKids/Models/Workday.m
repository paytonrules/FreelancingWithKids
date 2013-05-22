
#import "Workday.h"
#import "ToDoList.h"

@interface Workday ()

@property (nonatomic, strong) id<WorkdayClock> itsClock;
@property (nonatomic, strong) ToDoList *tasks;
@end

@implementation Workday

+(id) workdayWithTodoList: (ToDoList *)todoList andClock: (id<WorkdayClock>) fakeClock
{
  Workday *day = [Workday new];
  
  day.itsClock = fakeClock;
  day.tasks = todoList;
  return day;
}

-(void) start
{
  [self.itsClock start:self];
}

-(void) clockTicked
{
  if ([self.tasks complete]) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gameOver" object:self userInfo:@{@"successful": @YES}];
  }
}

@end
