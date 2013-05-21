#import <Foundation/Foundation.h>

#import "ClockWatcher.h"

@protocol WorkdayClock <NSObject>

-(void) start:(id<ClockWatcher>) watcher;

@end
