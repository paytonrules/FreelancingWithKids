//
//  Task.m
//  FreelancingWithKids
//
//  Created by Eric Smith on 5/11/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import "Task.h"

@implementation Task

+(id) taskWithName: (NSString *) name
{
  Task *task = [Task new];
  task.name = name;
  
  return task;
}

@end
