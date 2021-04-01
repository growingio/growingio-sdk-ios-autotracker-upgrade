//
// GrowingNotificationDelegateAutotracker.m
// GrowingAnalytics-Autotracker-AutotrackerCore-TrackerCore
//
//  Created by sheng on 2021/3/1.
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


#import "GrowingNotificationDelegateAutotracker.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "GrowingNotificationDelegateManager.h"

@implementation GrowingNotificationDelegateAutotracker

+ (void)track {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSObject* delegate = [UIApplication sharedApplication].delegate;
        if ([delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
            SEL sel = @selector(application:didReceiveRemoteNotification:fetchCompletionHandler:);
            Method method = class_getInstanceMethod(delegate.class,sel);
            IMP originImp = method_getImplementation(method);
            method_setImplementation(method, imp_implementationWithBlock(^(id target,UIApplication *application,NSDictionary *userInfo,void (^completionHandler)(UIBackgroundFetchResult)) {
                [[GrowingNotificationDelegateManager sharedInstance] dispatchApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
                BOOL (*tempImp)(id obj, SEL sel,UIApplication *application,NSDictionary *userInfo,void (^completionHandler)(UIBackgroundFetchResult)) = (void*)originImp;
                return tempImp(target,sel,application,userInfo,completionHandler);
            }));
        } else if ([delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:)]) {
            SEL sel = @selector(application:didReceiveRemoteNotification:);
            Method method = class_getInstanceMethod(delegate.class,sel);
            IMP originImp = method_getImplementation(method);
            method_setImplementation(method, imp_implementationWithBlock(^(id target,UIApplication *application,NSDictionary *userInfo) {
                [[GrowingNotificationDelegateManager sharedInstance] dispatchApplication:application didReceiveRemoteNotification:userInfo];
                BOOL (*tempImp)(id obj, SEL sel,UIApplication *application,NSDictionary *userInfo) = (void*)originImp;
                return tempImp(target,sel,application,userInfo);
            }));
        }
    
    });
}

@end
