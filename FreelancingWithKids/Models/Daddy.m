
#import "Daddy.h"
#import "ToDoList.h"
#import "Task.h"

@interface Daddy ()

@property (nonatomic, strong) id<WallClock> itsClock;
@property (nonatomic, strong) ToDoList *tasks;
@property (assign) int numTicks;
@property (assign) int stress;
@property (nonatomic, strong) Task *currentTask;

-(void) clearCurrentTask;
@end

int const EIGHT_HOUR_DAY = 32;
NSString *const DAY_OVER_NOTIFICATION = @"gameOver";
NSString *const DAY_RESULT = @"result";

@implementation Daddy

+(id) workdayWithTodoList: (ToDoList *)todoList andClock: (id<WallClock>) clock
{
  Daddy *day = [[Daddy alloc] initWithList:todoList andClock:clock];
  
  return day;
}

- (id)init
{
  id<WallClock> clock;
  ToDoList *tasks = [ToDoList new];
  [tasks add:[Task taskWithName:@"email" andDuration:3]];
  [tasks add:[Task taskWithName:@"meeting" andDuration:10]];
  
  return [self initWithList:tasks andClock:clock];
}

- (id)initWithList: (ToDoList *)todoList andClock: (id<WallClock>) clock
{
    self = [super init];
    if (self) {
      self.itsClock = clock;
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
  if (self.currentTask == nil)
    self.stress += 10;
  else
    self.stress -= 10;

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

-(void) startWorkingOn:(NSString *) taskName withDelegate: (id<TaskView>) view
{
  [self clearCurrentTask];
  
  self.currentTask = [self.tasks taskByName:taskName];
  [self.currentTask start:view];
}

-(void) playWithKid
{
  [self clearCurrentTask];
}

-(void) clearCurrentTask
{
  if (self.currentTask != nil)
    [self.currentTask stop];
  
  self.currentTask = nil;
}

@end
