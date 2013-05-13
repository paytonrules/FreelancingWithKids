//
//  PeformWorkTask.m
//  FreelancingWithKids
//
//  Created by Eric Smith on 5/11/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import "PerformWorkTask.h"
#import "Task.h"

@interface PerformWorkTask()

@property (strong, nonatomic) id<PerformWorkTaskDelegate> delegate;
@property (strong, nonatomic) Task *task;

@end

@implementation PerformWorkTask

+(id) performWorkTaskWithDelegate:(id<PerformWorkTaskDelegate>) delegate
{
  PerformWorkTask *task = [PerformWorkTask new];
  task.delegate = delegate;
  
  return task;
}

-(void) addTask: (Task *) task
{
  self.task = task;
}

-(void) startTask:(NSString *)name
{
  [self.delegate taskStarted:self.task];
}

@end
