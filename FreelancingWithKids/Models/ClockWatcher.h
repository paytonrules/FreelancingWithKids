#import <Foundation/Foundation.h>

@protocol ClockWatcher <NSObject>

-(void) clockTicked:(NSTimeInterval) interval;

@end
