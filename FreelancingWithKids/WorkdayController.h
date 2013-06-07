
#import <UIKit/UIKit.h>
#import "WorkdayView.h"
#import "TaskView.h"

@protocol Presenter;
@protocol StateMachine;

@interface WorkdayController : UIViewController<UITableViewDelegate, UITableViewDataSource, WorkdayView>

@property(strong, nonatomic) IBOutlet UITableView *taskList;
@property(strong, nonatomic) IBOutlet UILabel *clockOnTheWall;
@property(strong, nonatomic) IBOutlet UIProgressView *stressBar;
@property(readonly) id<Presenter> presenter;
@property (strong, nonatomic) id<StateMachine> machine;

-(void) startWorkingOn: (NSString *) name withDelegate:(id<TaskView>) view;
@end
