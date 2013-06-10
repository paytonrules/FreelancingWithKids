#import "FakeStateMachine.h"

@implementation FakeStateMachine
@synthesize stress = _stress;

-(void) start
{

}

-(void) startTask:(NSString *)task withDelegate:(id <TaskView>)view {

}

- (void)endTurn
{

}

- (void)playWithKid
{

}

-(void) setStress:(int) stress
{
  _stress = stress;
}

@end