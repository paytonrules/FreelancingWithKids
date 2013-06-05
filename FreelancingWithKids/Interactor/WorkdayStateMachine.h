#import <Foundation/Foundation.h>
#import "Freelancer.h"
#import "StateMachine.h"
#import "ClockWatcher.h"

@protocol WallClock;

FOUNDATION_EXPORT NSString *const DAY_OVER_NOTIFICATION;
enum _WorkdayStatus {
  None,
  Successful,
  Failed
};

typedef enum _WorkdayStatus WorkdayStatus;
FOUNDATION_EXPORT NSString *const DAY_RESULT;
extern int const EIGHT_HOUR_DAY;

@interface WorkdayStateMachine : NSObject<StateMachine, ClockWatcher>

+(id) machineWithFreeLancer:(id<Freelancer>) daddy;
+(id) machineWithFreeLancer:(id <Freelancer>)freelancer clock:(id <WallClock>)clock;
@end
