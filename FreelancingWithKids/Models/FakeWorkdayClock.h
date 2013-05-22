
#import <Foundation/Foundation.h>
#import "WorkdayClock.h"

@interface FakeWorkdayClock : NSObject<WorkdayClock>

-(void) notifyWatcher:(NSTimeInterval) timeInterval;
@end
