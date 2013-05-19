//
//  TaskView.h
//  FreelancingWithKids
//
//  Created by Eric Smith on 5/16/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TaskView <NSObject>

-(void) updateProgress:(NSDecimalNumber *) progress;
@end
