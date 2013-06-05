#import <Foundation/Foundation.h>
#import "WallClock.h"
#import "TaskView.h"
#import "Freelancer.h"

@class Task;

@interface Daddy : NSObject<Freelancer>

-(void) playWithKid;
-(void) startWorkingOn:(Task *) task withDelegate: (id<TaskView>) view;
@property(readonly) int stress;
@end
