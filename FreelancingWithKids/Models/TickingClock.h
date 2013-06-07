
#import <Foundation/Foundation.h>
#import "WallClock.h"

@interface TickingClock : NSObject<WallClock>

+(id) clockWithUpdateInterval:(NSTimeInterval) interval;
@property(readonly) NSTimeInterval interval;
@property(readonly) NSTimer *timer;

@end
