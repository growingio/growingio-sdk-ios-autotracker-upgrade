//
// AppDelegate.m
// autotracker-upgrade-2to3-cdp
//
//  Created by sheng on 2020/12/11.
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


#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "Growing.h"
#import "GrowingAutotracker.h"
#import <GrowingTouchCoreKit/GrowingTouchCoreKit.h>
#import <GrowingCDPCoreKit/GrowingCoreKit.h>
//#import "GrowingCoreKit.h"
#import "GrowingTrackConfiguration+CdpTracker.h"
#import "TrackViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[TrackViewController alloc] init];//设置根视图控制器
    [self.window makeKeyAndVisible];//设置成为主窗口并显示
    
    [Growing upgrade];
    GrowingTrackConfiguration *config = [[GrowingTrackConfiguration alloc] initWithProjectId:@"91eaf9b283361032"];
    config.dataSourceId = @"8425024422dec9a6";
    config.debugEnabled = YES;
    config.dataCollectionServerHost = @"https://uat-api.growingio.com";
//    config.dataCollectionServerHost = @"https://run.mocky.io/v3/08999138-a180-431d-a136-051f3c6bd306";
    [GrowingAutotracker startWithConfiguration:config launchOptions:launchOptions];
   
    
//    [Growing setTrackerHost:@"http://117.50.92.65:8080"];
    [GrowingTouch setServerHost:@"http://cdp.growingio.com"];
    [GrowingTouch start];
    // 设置debug模式
    [GrowingTouch setDebugEnable:YES];
    
    [GrowingTouch setEventPopupDelegate:self];
    return YES;
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return NO;
}

// universal Link执行
- (BOOL) application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
  restorationHandler:(void (^)(NSArray<id <UIUserActivityRestoring>> *_Nullable))restorationHandler {
//    [Growing handleURL:userActivity.webpageURL];
    restorationHandler(nil);
    return YES;
}

- (void)onEventPopupLoadSuccess:(NSString *)trackEventId eventType:(NSString *)eventType {
//    NSLog(@"%s trackEventId = %@, eventType = %@", __func__, trackEventId, eventType);
}

- (void)onEventPopupLoadFailed:(NSString *)trackEventId eventType:(NSString *)eventType withError:(NSError *)error {
//    NSLog(@"%s trackEventId = %@, eventType = %@", __func__, trackEventId, eventType);
}

- (BOOL)onClickedEventPopup:(NSString *)trackEventId eventType:(NSString *)eventType openUrl:(NSString *)openUrl {
//    NSLog(@"%s trackEventId = %@, eventType = %@", __func__, trackEventId, eventType);
    return NO;
}

- (void)onCancelEventPopup:(NSString *)trackEventId eventType:(NSString *)eventType {
//    NSLog(@"%s trackEventId = %@, eventType = %@", __func__, trackEventId, eventType);
}

- (void)onTrackEventTimeout:(NSString *)trackEventId eventType:(NSString *)eventType {
//    NSLog(@"%s trackEventId = %@, eventType = %@", __func__, trackEventId, eventType);
}

#pragma mark - notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [GrowingTouch registerDeviceToken:deviceToken];
    
    NSMutableString *deviceTokenString = [NSMutableString string];
    const char *bytes = deviceToken.bytes;
    NSInteger count = deviceToken.length;
    for (NSInteger i = 0; i < count; i++) {
        [deviceTokenString appendFormat:@"%02x", bytes[i] & 0xff];
    }
    NSLog(@"Token 字符串：%@", deviceTokenString);
}

- (void)registerRemoteNotification {
    if (@available(iOS 10,*)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound )
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (granted) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                                          [[UIApplication sharedApplication] registerForRemoteNotifications];
                                      });
                                  }
                              }];
    } else if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}


@end
