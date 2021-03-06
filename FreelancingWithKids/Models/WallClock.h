#import <Foundation/Foundation.h>

#import "ClockWatcher.h"

@protocol WallClock <NSObject>

-(void) start:(id<ClockWatcher>) watcher;
-(void) start;
-(void) registerWatcher:(id<ClockWatcher>) watcher;
-(void) stop;

@property(readonly) BOOL ticking;

@end
