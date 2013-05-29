#import <Foundation/Foundation.h>
#import "Freelancer.h"

@interface WorkdayStateMachine : NSObject

+(id) machineWithFreeLancer:(id<Freelancer>) daddy;

-(void) start;

@end
