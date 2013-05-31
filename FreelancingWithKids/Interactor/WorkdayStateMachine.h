#import <Foundation/Foundation.h>
#import "Freelancer.h"
#import "StateMachine.h"
#import "ClockWatcher.h"

@protocol WallClock;

@interface WorkdayStateMachine : NSObject<StateMachine, ClockWatcher>

+(id) machineWithFreeLancer:(id<Freelancer>) daddy;
+(id) machineWithFreeLancer:(id <Freelancer>)freelancer clock:(id <WallClock>)clock;
@end
