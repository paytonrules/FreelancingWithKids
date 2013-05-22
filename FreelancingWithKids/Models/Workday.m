
#import "Workday.h"
#import "ToDoList.h"

@interface Workday ()

@property (nonatomic, strong) id<WallClock> itsClock;
@property (nonatomic, strong) ToDoList *tasks;
@end

static NSTimeInterval EIGHT_HOUR_DAY = 28800; // 8 hours

@implementation Workday

+(id) workdayWithTodoList: (ToDoList *)todoList andClock: (id<WallClock>) fakeClock
{
  Workday *day = [[Workday alloc] initWithList:todoList andClock:fakeClock];
  
  return day;
}

- (id)initWithList: (ToDoList *)todoList andClock: (id<WallClock>) fakeClock
{
    self = [super init];
    if (self) {
      self.itsClock = fakeClock;
      self.tasks = todoList;
      self.currentTimePassed = 0;
    }
    return self;
}

-(void) start
{
  [self.itsClock start:self];
}

-(void) clockTicked:(NSTimeInterval) timeInterval
{
  self.currentTimePassed += timeInterval;

  if ([self.tasks complete]) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gameOver"
                                                        object:self
                                                      userInfo:@{@"result": [NSNumber numberWithInt:Successful]}];
  }
  else if (self.currentTimePassed >= EIGHT_HOUR_DAY) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gameOver"
                                                        object:self
                                                      userInfo:@{@"result": [NSNumber numberWithInt:Failed]}];
  }
}

@end
