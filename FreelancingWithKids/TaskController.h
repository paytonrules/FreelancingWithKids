//
//  TaskController.h
//  FreelancingWithKids
//
//  Created by Eric Smith on 5/17/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Task;
@class TaskViewCell;

@interface TaskController : NSObject {
  IBOutlet TaskViewCell *_view;
}

@property (nonatomic, readonly) TaskViewCell *view;
@property (nonatomic, strong) Task* task;

@end
