#import <Foundation/Foundation.h>
#import "WorkdayView.h"
#import "TaskView.h"
#import "WorkdayStateMachine.h"
#import "Presenter.h"
#import "WorkdayStatus.h"

@class ToDoList;

@interface WorkdayPresenter : NSObject<Presenter>

- (id)initWithView:(id <WorkdayView>)view;
+ (id)presenterWithView:(id <WorkdayView>)view;

-(NSString *) taskNameAt:(NSInteger) row;
-(void) updateStress:(int) stressAmount;
@end
