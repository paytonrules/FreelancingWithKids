#import <Foundation/Foundation.h>

@protocol WorkdayView <NSObject>
-(void) updateClockWith:(NSString *) time;
-(void) showYouWin;
-(void) showYouLose;
-(void) updateProgress:(float) progress;
@end
