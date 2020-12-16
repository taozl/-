
//
//  AppDelegate+Cycle.m
//  PushDemo
//
//  Created by Yuki on 2020/12/11.
//  Copyright © 2020 Tzl. All rights reserved.
//

#import "AppDelegate+Cycle.h"
#import <JPUSHService.h>
#import <UserNotifications/UserNotifications.h>

#define JPUSHKEY @"40d11c36925f96bf000cb272"
@interface AppDelegate ()<JPUSHRegisterDelegate>

@end
@implementation AppDelegate (Cycle)


///开始注册jpush
- (void)registJPushWithApplication:(UIApplication *)application Options:(NSDictionary *)launchOptions{
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc]init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //【初始化sdk】
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHKEY
                          channel:@"AppStore"
                 apsForProduction:NO
            advertisingIdentifier:@""];
    
    /**  程序未启动，点击icon图标接收到消息  **/
    NSDictionary *remoteNotifi = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    NSString *str = [NSString stringWithFormat:@"从icon点击过来的 ----接收到了推送信息:%@",remoteNotifi];
    [self showAlertWithStr:str];
    
    ///设置Alias
    [JPUSHService setAlias:@"1234567890" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:1];
    
    
}

//注册token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
}


///iOS 7 - iOS 10之间接收到通知信息点击通知栏唤醒App
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSString *str = [NSString stringWithFormat:@"从通知栏点击过来的 ios7 - ios 10 -----接受到了通知信息：%@",userInfo];
    [self showAlertWithStr:str];
}

///iOS10以上接收到通知信息点击通知栏唤醒App
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler API_AVAILABLE(ios(10.0)){
    ///app活跃状态接收到通知消息
    NSString *str = [NSString stringWithFormat:@"从通知栏点击过来的ios 10willPresent-----接受到了通知信息：%@",notification.request.content.userInfo];
    [self showAlertWithStr:str];
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    ///app点击通知栏启动接收到消息
    NSString *str = [NSString stringWithFormat:@"从通知栏点击过来的ios 10didReceive-----接受到了通知信息：%@",response.notification.request.content.userInfo];
    [self showAlertWithStr:str];
}

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
  if (notification) {
    //从通知界面直接进入应用
  }else{
    //从通知设置界面进入应用
  }
     NSString *str = [NSString stringWithFormat:@"从通知栏点击过来的ios 12openSettingsForNotification-----接受到了通知信息：%@",notification.request.content.userInfo];
    [self showAlertWithStr:str];
}




#pragma mark - --------- 弹出弹框  ---------
- (void)showAlertWithStr:(NSString *)Str{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"接收到消息了" message:[NSString stringWithFormat:@"%@",Str] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:^{
            
        }];
    }]];
    [self.window.rootViewController presentViewController:alert animated:YES completion:^{
        
    }];
}

@end
