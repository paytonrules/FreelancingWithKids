//
//  PerformWorkTaskDelegate.h
//  FreelancingWithKids
//
//  Created by Eric Smith on 5/13/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Task;

@protocol PerformWorkTaskDelegate <NSObject>

-(void) taskStarted:(Task *) task;

@end
