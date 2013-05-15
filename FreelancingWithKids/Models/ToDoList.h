//
//  TaskCollection.h
//  FreelancingWithKids
//
//  Created by Eric Smith on 5/15/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Task;

@interface ToDoList : NSObject

-(Task *) taskNumber:(NSInteger) task;
-(void) add:(Task *)task;

@property(readonly) int count;
@end
