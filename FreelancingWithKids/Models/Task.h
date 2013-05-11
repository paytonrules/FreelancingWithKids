//
//  Task.h
//  FreelancingWithKids
//
//  Created by Eric Smith on 5/11/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property(strong, nonatomic) NSString *name;
+(id) taskWithName: (NSString *) name;

@end
