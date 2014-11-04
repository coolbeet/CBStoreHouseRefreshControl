//
//  AppDelegate.m
//  CBStoreHouseRefreshControl
//
//  Created by coolbeet on 10/26/14.
//  Copyright (c) 2014 Suyu Zhang. All rights reserved.
//

#import "AppDelegate.h"
#import "ContentViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blackColor];
    ContentViewController *contentViewController = [[ContentViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contentViewController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
