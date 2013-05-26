//
//  TaskViewCell.h
//  FreelancingWithKids
//
//  Created by Eric Smith on 5/16/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskView.h"

@class Task;
@class Workday;

@interface TaskViewCell : UITableViewCell<TaskView>

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) Workday *day;

@end
