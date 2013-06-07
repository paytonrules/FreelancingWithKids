#import <Foundation/Foundation.h>

@class Task;
@protocol TaskView;

@protocol Freelancer <NSObject>

-(void) clockTicked;
-(void) startTask:(Task *)task withDelegate:(id<TaskView>) view;
@property(readonly) int stress;

@end
