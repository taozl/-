//
//  AppDelegate+Cycle.h
//  PushDemo
//
//  Created by Yuki on 2020/12/11.
//  Copyright © 2020 Tzl. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Cycle)

///注册jPush
- (void)registJPushWithApplication:(UIApplication *)application Options:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END
