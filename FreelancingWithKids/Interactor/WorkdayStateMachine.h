#import <Foundation/Foundation.h>
#import "Freelancer.h"
#import "StateMachine.h"
#import "ClockWatcher.h"

@protocol WallClock;
@protocol Presenter;

extern int const EIGHT_HOUR_DAY;

@interface WorkdayStateMachine : NSObject<StateMachine>

+(id) machineWithFreeLancer:(id<Freelancer>) freelancer presenter:(id<Presenter>) presenter;

@end
