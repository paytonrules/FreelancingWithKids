//
//  main.m
//  FreelancingWithKidsSpecs
//
//  Created by Eric Smith on 5/11/13.
//  Copyright (c) 2013 Eric Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <OCDSpec2/OCDSpec2.h>

@interface OCDSpec2EntryPoint : NSObject
@end

@implementation OCDSpec2EntryPoint

- (void) applicationDidFinishLaunching:(UIApplication*)app {
  exit(OCDSpec2RunAllTests());
}

@end
int main(int argc, char *argv[])
{
  @autoreleasepool {
    return OCDSpec2RunAllTests();
  }
}
