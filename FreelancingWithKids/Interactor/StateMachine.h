#import <Foundation/Foundation.h>

@protocol TaskView;
@protocol StateMachine <NSObject>

-(void) start;
-(void) startTask:(NSString *)task withDelegate:(id<TaskView>) view;
-(void) playWithKid;
-(void) endTurn;

@property (assign, readonly) int stress;
@end