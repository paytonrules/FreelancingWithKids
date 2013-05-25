
#import "Workday.h"
#import "ToDoList.h"

@interface Workday ()

@property (nonatomic, strong) id<WallClock> itsClock;
@property (nonatomic, strong) ToDoList *tasks;
@property (assign) int numTicks;

@end

int const EIGHT_HOUR_DAY = 32;
NSString *const DAY_OVER_NOTIFICATION = @"gameOver";
NSString *const DAY_RESULT = @"result";

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
      self.numTicks = 0;
    }
    return self;
}

-(void) start
{
  [self.itsClock start:self];
}

-(void) clockTicked:(NSTimeInterval) timeInterval
{
  self.numTicks += 1;

  if ([self.tasks complete]) {
    [[NSNotificationCenter defaultCenter] postNotificationName:DAY_OVER_NOTIFICATION
                                                        object:self
                                                      userInfo:@{DAY_RESULT: [NSNumber numberWithInt:Successful]}];
    [self.itsClock stop];
  }
  else if (self.numTicks >= EIGHT_HOUR_DAY) {
    [[NSNotificationCenter defaultCenter] postNotificationName:DAY_OVER_NOTIFICATION
                                                        object:self
                                                      userInfo:@{DAY_RESULT: [NSNumber numberWithInt:Failed]}];
    [self.itsClock stop];
  }
  
  
}

@end
