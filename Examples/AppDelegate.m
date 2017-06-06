//
//  AppDelegate.m
//  PWListKit
//
//  Created by Huang Wei on 2017/6/6.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "AppDelegate.h"
#import "DemosViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[DemosViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
