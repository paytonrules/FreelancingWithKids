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

@class Workday;

@interface WorkdayPresenter : NSObject<ClockWatcher>

-(id) initWithView:(id<WorkdayView>) view;
+(id) presenterWithView:(id<WorkdayView>) view;

-(NSString *) taskNameAt:(NSInteger) row;
-(void) startDay;
-(void) startWorkingOn: (NSString *) name withDelegate:(id<TaskView>) view;

@property (strong, nonatomic) Workday *day;
@property (readonly) int taskCount;

@end
