#import <Foundation/Foundation.h>
#import "Presenter.h"
#import "WorkdayStatus.h"

@interface FakePresenter : NSObject<Presenter>

-(void) completeAllTasks;
-(BOOL) gameOverWith:(WorkdayStatus) status;
@end