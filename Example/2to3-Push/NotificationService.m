//
// NotificationService.m
// 2to3-Push
//
//  Created by sheng on 2021/3/6.
//  Copyright (C) 2017 Beijing Yishu Technology Co., Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


#import "NotificationService.h"
#import <GrowingCDPPushExtensionKit/GrowingPushExtensionKit.h>
@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    // 设置AccountID 和 dataSourceID
    [GrowingPushExtensionKit upgradeTo3x];
    [GrowingPushExtensionKit startWithAccountId:@"91eaf9b283361032" dataSourceId:@"8425024422dec9a6"];
    // 设置Trackhost，埋点上报地址
    [GrowingPushExtensionKit setTrackerHost:@"https://uat-api.growingio.com"];
    [GrowingPushExtensionKit handleNotificationRequest:request
                                        withCompletion:^(NSArray<UNNotificationAttachment *> * _Nullable attachments, NSArray<NSError *> * _Nullable errors) {
        
        // Modify the notification content here...
        self.bestAttemptContent.attachments = attachments;   // 设置附件
        self.contentHandler(self.bestAttemptContent);
    }];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
