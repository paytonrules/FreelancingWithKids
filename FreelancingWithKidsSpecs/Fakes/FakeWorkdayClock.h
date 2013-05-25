
#import <Foundation/Foundation.h>
#import "WallClock.h"

@interface FakeWorkdayClock : NSObject<WallClock>

-(void) notifyWatcher:(NSTimeInterval) timeInterval;
@property (assign) bool started;
@end
