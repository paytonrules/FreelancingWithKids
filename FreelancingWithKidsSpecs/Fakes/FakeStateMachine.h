#import <Foundation/Foundation.h>
#import "StateMachine.h"


@interface FakeStateMachine : NSObject<StateMachine>
-(void) setStress:(int) stress;
@end