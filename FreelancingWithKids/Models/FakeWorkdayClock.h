
#import <Foundation/Foundation.h>
#import "WorkdayClock.h"

@interface FakeWorkdayClock : NSObject<WorkdayClock>

@property (assign) BOOL started;
-(void) notifyWatcher:(NSTimeInterval) timeInterval;
@end
