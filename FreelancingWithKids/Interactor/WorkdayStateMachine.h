#import <Foundation/Foundation.h>
#import "Freelancer.h"
#import "StateMachine.h"

@interface WorkdayStateMachine : NSObject<StateMachine>

+(id) machineWithFreeLancer:(id<Freelancer>) daddy;

@end
