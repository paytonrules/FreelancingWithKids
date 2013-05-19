//
//  Task.h
//  FreelancingWithKids
//
//  Created by Eric Smith on 5/11/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskView.h"

@interface Task : NSObject
+(id) taskWithName: (NSString *) name;
+(id) taskWithName: (NSString *) name andDuration:(NSInteger) seconds;

@property(strong, nonatomic) NSString *name;
@property(readonly, nonatomic) NSTimer *timer;
-(void) start:(id<TaskView>) view;

@end
