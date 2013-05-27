//
//  ViewController.h
//  FreelancingWithKids
//
//  Created by Eric Smith on 5/10/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockWatcher.h"

@interface WorkdayController : UIViewController<UITableViewDelegate, UITableViewDataSource, ClockWatcher>

@property(strong, nonatomic) IBOutlet UITableView *taskList;
@property(strong, nonatomic) IBOutlet UILabel *clockOnTheWall;
@property(strong, nonatomic) IBOutlet UIProgressView *stressBar;
@end
