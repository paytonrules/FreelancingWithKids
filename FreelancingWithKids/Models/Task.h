//
//  Task.h
//  FreelancingWithKids
//
//  Created by Eric Smith on 5/11/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskView.h"
#import "WallClock.h"
#import "ClockWatcher.h"

@class TickingClock;

@interface Task : NSObject<ClockWatcher>
+(id) taskWithName: (NSString *) name andDuration:(NSInteger) seconds;
+(id) taskWithName: (NSString *) name duration:(NSInteger) duration andUpdatesPerSecond:(float) updatesPerSecond;
+(id) taskWithName: (NSString *) name duration:(NSInteger) duration updatesPerSecond:(float) updatesPerSecond andClock:(id<WallClock>)clock;

@property(strong, nonatomic) NSString *name;
@property(readonly, nonatomic) id<WallClock> clock;
@property(readonly) BOOL complete;
-(void) start:(id<TaskView>) view;
-(void) updateProgress;

@end
