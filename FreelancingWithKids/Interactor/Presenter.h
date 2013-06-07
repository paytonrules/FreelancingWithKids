#import <Foundation/Foundation.h>
#import "WorkdayStatus.h"

@class ToDoList;

@protocol Presenter <NSObject>

-(void) clockTicked;
-(void) gameOver:(WorkdayStatus) status;
-(NSString *) taskNameAt:(NSInteger) row;
-(void) updateStress:(int) stressAmount;

@property(strong, nonatomic) ToDoList *todoList;
@property (readonly) int taskCount;
@property(readonly) NSString *currentTime;

@end