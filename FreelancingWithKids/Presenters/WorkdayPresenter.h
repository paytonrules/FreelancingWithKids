//
//  WorkdayPresenter.h
//  FreelancingWithKids
//
//  Created by Eric Smith on 5/28/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkdayView.h"
#import "ClockWatcher.h"
#import "TaskView.h"

@class Daddy;
@protocol StateMachine;

@interface WorkdayPresenter : NSObject<ClockWatcher>

- (id)initWithMachine:(id <StateMachine>)machine view:(id <WorkdayView>)view;
+ (id)presenterWithMachine:(id <StateMachine>)machine view:(id <WorkdayView>)view;

-(void) startDay;
-(void) startWorkingOn: (NSString *) name withDelegate:(id<TaskView>) view;
-(NSString *) taskNameAt:(NSInteger) row;

@property (strong, nonatomic) Daddy *daddy;
@property (readonly) int taskCount;

@end
