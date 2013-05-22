#import <Foundation/Foundation.h>

#import "ClockWatcher.h"

@protocol WallClock <NSObject>

-(void) start:(id<ClockWatcher>) watcher;

@end
