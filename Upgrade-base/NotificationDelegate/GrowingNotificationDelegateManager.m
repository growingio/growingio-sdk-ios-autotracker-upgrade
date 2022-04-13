//
// GrowingNotificationDelegateManager.m
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

#import "Upgrade-base/NotificationDelegate/GrowingNotificationDelegateManager.h"

@interface GrowingNotificationDelegateManager ()

@property (strong, nonatomic, readonly) NSPointerArray *observers;
@property (strong, nonatomic, readonly) NSLock *observerLock;

@end

@implementation GrowingNotificationDelegateManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _observers = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];
        _observerLock = [[NSLock alloc] init];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[super allocWithZone:NULL] init];
    });

    return _sharedInstance;
}
// for safe sharedInstance
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

- (void)addNotificationDelegateObserver:(id<GrowingNotificationDelegateProtocol>)delegate {
    [self.observerLock lock];
    if (![self.observers.allObjects containsObject:delegate]) {
        [self.observers addPointer:(__bridge void *)delegate];
    }
    [self.observerLock unlock];
}

- (void)removeNotificationDelegateObserver:(id<GrowingNotificationDelegateProtocol>)delegate {
    [self.observerLock lock];
    [self.observers.allObjects enumerateObjectsWithOptions:NSEnumerationReverse
                                                usingBlock:^(NSObject *obj, NSUInteger idx, BOOL *_Nonnull stop) {
                                                    if (delegate == obj) {
                                                        [self.observers removePointerAtIndex:idx];
                                                        *stop = YES;
                                                    }
                                                }];
    [self.observerLock unlock];
}

- (void)dispatchApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self.observerLock lock];
    for (id observer in self.observers) {
        if ([observer respondsToSelector:@selector(growingApplication:didReceiveRemoteNotification:)]) {
            [observer growingApplication:application didReceiveRemoteNotification:userInfo];
        }
    }
    [self.observerLock unlock];
}


- (void)dispatchApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self.observerLock lock];
    for (id observer in self.observers) {
        if ([observer respondsToSelector:@selector(growingApplication:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
            [observer growingApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
        }
    }
    [self.observerLock unlock];
}

@end
 
