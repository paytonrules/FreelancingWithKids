//
//  TimingClock.h
//  FreelancingWithKids
//
//  Created by Eric Smith on 5/22/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WallClock.h"

@interface TickingClock : NSObject<WallClock>

+(id) clockWithUpdateInterval:(NSTimeInterval) interval;
@property(readonly) NSTimer *timer;

-(void) stop;

@end
