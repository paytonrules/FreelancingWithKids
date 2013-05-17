//
//  TaskViewCell.h
//  FreelancingWithKids
//
//  Created by Eric Smith on 5/16/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskView.h"

@class TaskController;

@interface TaskViewCell : UITableViewCell<TaskView>
{
  IBOutlet TaskController *_controller;
}

@property(nonatomic, readonly) TaskController *controller;

@end
