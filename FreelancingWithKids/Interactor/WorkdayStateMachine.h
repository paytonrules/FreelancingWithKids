#import <Foundation/Foundation.h>
#import "Freelancer.h"
#import "StateMachine.h"
#import "ClockWatcher.h"

@protocol WallClock;
@protocol Presenter;

extern int const EIGHT_HOUR_DAY;

@interface WorkdayStateMachine : NSObject<StateMachine, ClockWatcher>

+(id) machineWithFreeLancer:(id<Freelancer>) freelancer presenter:(id<Presenter>) presenter;
+(id) machineWithFreeLancer:(id<Freelancer>) freelancer presenter:(id<Presenter>) presenter clock:(id <WallClock>)clock;

@property(readonly) id<WallClock> clock;

@end
