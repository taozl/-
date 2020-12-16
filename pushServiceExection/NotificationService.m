//
//  NotificationService.m
//  pushServiceExection
//
//  Created by Yuki on 2020/12/16.
//  Copyright © 2020 Tzl. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@", self.bestAttemptContent.title];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSDictionary *dict = request.content.userInfo;
    
    NSLog(@"来了远程通知--%@",dict);
    
    NSString *imgUrl = dict[@"image"];
    NSURL *url =  [NSURL URLWithString:imgUrl];
    if (url) {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
        //注意使用DownloadTask，
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:urlRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSString *path = [location.path stringByAppendingFormat:@".png"];
                NSError *err = nil;
                NSURL *pathUrl = [NSURL fileURLWithPath:path];
                [[NSFileManager defaultManager]moveItemAtURL:location toURL:pathUrl error:nil];
                UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"attachment" URL:pathUrl options:nil error:&err];
                if (att) {
                    self.bestAttemptContent.attachments = @[att];
                }else{
                    self.contentHandler(self.bestAttemptContent);
                }
            }else{
                self.contentHandler(self.bestAttemptContent);
            }
        }];
        ///开启任务
        [task resume];
    }else{
        self.contentHandler(self.bestAttemptContent);
    }
    
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
