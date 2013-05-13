//
//  PeformWorkTask.h
//  FreelancingWithKids
//
//  Created by Eric Smith on 5/11/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PerformWorkTaskDelegate.h"

@class Task;

@interface PerformWorkTask : NSObject

+(id) performWorkTaskWithDelegate:(id<PerformWorkTaskDelegate>) delegate;
-(void) addTask: (Task *) task;
-(void) startTask: (NSString *)name;

@end
