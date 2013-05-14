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
@property (strong, nonatomic) NSMutableArray *tasks;

@end

@implementation PerformWorkTask

+(id) performWorkTaskWithDelegate:(id<PerformWorkTaskDelegate>) delegate
{
  PerformWorkTask *interactor = [PerformWorkTask new];
  interactor.delegate = delegate;
  interactor.tasks = [NSMutableArray new];
  
  return interactor;
}

-(void) addTask: (Task *) task
{
  [self.tasks addObject:task];
}

-(void) startTask:(NSString *)name
{
  Task *task = [self.tasks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", name]][0];
  [self.delegate taskStarted:task];
}

@end
