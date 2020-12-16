//
//  AppDelegate.m
//  PushDemo
//
//  Created by Yuki on 2020/12/11.
//  Copyright © 2020 Tzl. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeController.h"
#import "AppDelegate+Cycle.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    ///注册Jpush
    [self registJPushWithApplication:application Options:launchOptions];
    
    self.window = [[UIWindow alloc]initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:HomeController.new];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}



@end
