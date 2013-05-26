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

-(void) add:(Task *)task;
-(Task *) taskByName:(NSString *) name;
-(Task *) taskNumber:(NSInteger) task;
-(bool) complete;

@property(readonly) int count;
@end
