#import <Foundation/Foundation.h>
#import "WorkdayStatus.h"

@class ToDoList;

@protocol Presenter <NSObject>

@property(strong, nonatomic) ToDoList *todoList;
-(void) clockTicked;
-(void) gameOver:(WorkdayStatus) status;
@property (readonly) int taskCount;

@end