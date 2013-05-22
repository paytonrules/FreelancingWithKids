
#import <Foundation/Foundation.h>
#import "WallClock.h"

@interface FakeWorkdayClock : NSObject<WallClock>

-(void) notifyWatcher:(NSTimeInterval) timeInterval;
@end
