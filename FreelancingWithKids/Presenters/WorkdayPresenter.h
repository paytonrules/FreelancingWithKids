#import <Foundation/Foundation.h>
#import "WorkdayView.h"
#import "TaskView.h"
#import "Presenter.h"
#import "WorkdayStatus.h"

@class ToDoList;

@interface WorkdayPresenter : NSObject<Presenter>

- (id)initWithView:(id <WorkdayView>)view;
+ (id)presenterWithView:(id <WorkdayView>)view;
@end
