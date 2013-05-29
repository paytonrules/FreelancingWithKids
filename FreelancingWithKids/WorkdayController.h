
#import <UIKit/UIKit.h>
#import "WorkdayView.h"
#import "TaskView.h"

@interface WorkdayController : UIViewController<UITableViewDelegate, UITableViewDataSource, WorkdayView>

@property(strong, nonatomic) IBOutlet UITableView *taskList;
@property(strong, nonatomic) IBOutlet UILabel *clockOnTheWall;
@property(strong, nonatomic) IBOutlet UIProgressView *stressBar;

-(void) startWorkingOn: (NSString *) name withDelegate:(id<TaskView>) view;
@end
