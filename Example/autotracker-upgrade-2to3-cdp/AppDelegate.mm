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
#import "Growing.h"
#import "GrowingAutotracker.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Growing upgrade];
    GrowingTrackConfiguration *config = [[GrowingTrackConfiguration alloc] initWithProjectId:@"a500f222e29e3b0c"];
    config.dataSourceId = @"b4a81e6c07645691";
    config.debugEnabled = YES;
    [GrowingAutotracker startWithConfiguration:config launchOptions:launchOptions];
   
    
//    [Growing setTrackerHost:@"http://117.50.92.65:8080"];
    NSDictionary *attribute = @{@"weight": @"1",
                                @"address": @"Hangzhou",
    };
    [Growing setUserAttributes:attribute];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
