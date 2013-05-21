
#import "Workday.h"

@interface Workday ()

@property (nonatomic, strong) id<WorkdayClock> itsClock;
@end

@implementation Workday

+(id) workdayWithTodoList: (ToDoList *)todoList andClock: (id<WorkdayClock>) fakeClock
{
  Workday *day = [Workday new];
  
  day.itsClock = fakeClock;
  return day;
}


-(void) start
{
  [self.itsClock start:self];
}

-(void) clockTicked
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"gameOver" object:self userInfo:@{@"successful": @YES}];
}

@end
