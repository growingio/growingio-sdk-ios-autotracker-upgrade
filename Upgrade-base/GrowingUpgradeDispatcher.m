//
// GrowingUpgradeDispatcher.m
// GrowingAnalytics-upgrade-Autotracker-upgrade-2to3-Upgrade-base
//
//  Created by sheng on 2021/2/24.
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

#import "Upgrade-base/GrowingUpgradeDispatcher.h"
#import "Upgrade-base/2x/EventBus/GrowingEventBus.h"
#import "Upgrade-base/2x/EventBus/Event/GrowingEBApplicationEvent.h"
#import "Upgrade-base/2x/EventBus/Event/GrowingEBVCLifeEvent.h"
#import "Upgrade-base/2x/EventBus/Event/GrowingEBManualTrackEvent.h"
#import "Upgrade-base/2x/EventBus/Event/GrowingEBUserIdEvent.h"
#import "Upgrade-base/2x/GrowingMediator.h"

#import "GrowingULAppLifecycle.h"
#import "GrowingTrackerCore/Manager/GrowingSession.h"
#import "GrowingTrackerCore/Public/GrowingBaseEvent.h"
#import "GrowingTrackerCore/Event/GrowingBaseAttributesEvent.h"
#import "GrowingTrackerCore/Event/GrowingCustomEvent.h"
#import "GrowingTrackerCore/Event/GrowingTrackEventType.h"
#import "GrowingTrackerCore/Helpers/NSURL+GrowingHelper.h"

@interface GrowingUpgradeDispatcher ()<GrowingULAppLifecycleDelegate,GrowingUserIdChangedDelegate>
@end

@implementation GrowingUpgradeDispatcher

+ (instancetype)sharedInstance {
    static GrowingUpgradeDispatcher *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GrowingUpgradeDispatcher alloc] init];
    });
    return instance;
}


- (void)applicationDidFinishLaunching:(NSDictionary *)userInfo {
    NSMutableDictionary *eventDataDic =  [[NSMutableDictionary alloc] init];
    if (userInfo){
        eventDataDic[@"data"] = userInfo;
    }
    GrowingEBApplicationEvent *applicationEvent = [[GrowingEBApplicationEvent alloc] initWithData:eventDataDic lifeType:GrowingApplicationDidFinishLaunching];
    [GrowingEventBus send:applicationEvent];
}

- (void)applicationWillTerminate {
    GrowingEBApplicationEvent *applicationEvent = [[GrowingEBApplicationEvent alloc] initWithLifeType:GrowingApplicationWillTerminate];
    [GrowingEventBus send:applicationEvent];
}

- (void)applicationDidBecomeActive {
    GrowingEBApplicationEvent *applicationEvent = [[GrowingEBApplicationEvent alloc] initWithLifeType:GrowingApplicationDidBecomeActive];
    [GrowingEventBus send:applicationEvent];
}

- (void)applicationWillResignActive {
    GrowingEBApplicationEvent *applicationEvent = [[GrowingEBApplicationEvent alloc] initWithLifeType:GrowingApplicationWillResignActive];
    [GrowingEventBus send:applicationEvent];
}

- (void)applicationDidEnterBackground {
    GrowingEBApplicationEvent *applicationEvent = [[GrowingEBApplicationEvent alloc] initWithLifeType:GrowingApplicationDidEnterBackground];
    [GrowingEventBus send:applicationEvent];
}

- (void)applicationWillEnterForeground {
    GrowingEBApplicationEvent *applicationEvent = [[GrowingEBApplicationEvent alloc] initWithLifeType:GrowingApplicationWillEnterForeground];
    [GrowingEventBus send:applicationEvent];
}

#pragma mark - GrowingUserIdChangedDelegate

- (void)userIdDidChangedFrom:(NSString *)oldUserId to:(NSString *)newUserId {
    if (newUserId == nil) {
        GrowingEBUserIdEvent *setUserIdEvent = [[GrowingEBUserIdEvent alloc] initWithData:nil operateType:GrowingClearUserIdType];
        [GrowingEventBus send:setUserIdEvent];
    } else {
        GrowingEBUserIdEvent *setUserIdEvent = [[GrowingEBUserIdEvent alloc] initWithData:@{@"data": newUserId} operateType:GrowingSetUserIdType];
        [GrowingEventBus send:setUserIdEvent];
    }
}

#pragma mark - GrowingULViewControllerLifecycleDelegate

- (void)viewControllerDidAppear:(UIViewController *)controller {
    GrowingEBVCLifeEvent *lifeEvent = [[GrowingEBVCLifeEvent alloc] initWithLifeType:GrowingVCLifeDidAppear];
    [GrowingEventBus send:lifeEvent];
}

- (void)viewControllerDidDisappear:(UIViewController *)controller {
    GrowingEBVCLifeEvent *lifeEvent = [[GrowingEBVCLifeEvent alloc] initWithLifeType:GrowingVCLifeDidDisappear];
    [GrowingEventBus send:lifeEvent];
}

#pragma mark - GrowingNotificationDelegateProtocol

- (void)growingApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSMutableDictionary *eventDataDic =  [[NSMutableDictionary alloc] init];
    eventDataDic[@"data"] = userInfo;
    GrowingEBApplicationEvent *applicationEvent = [[GrowingEBApplicationEvent alloc] initWithData:eventDataDic lifeType:GrowingApplicationDidReceiveRemoteNotification];
    [GrowingEventBus send:applicationEvent];
}

- (void)growingApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSMutableDictionary *eventDataDic =  [[NSMutableDictionary alloc] init];
    eventDataDic[@"data"] = userInfo;
    GrowingEBApplicationEvent *applicationEvent = [[GrowingEBApplicationEvent alloc] initWithData:eventDataDic lifeType:GrowingApplicationDidReceiveRemoteNotification];
    [GrowingEventBus send:applicationEvent];
}

#pragma mark - GrowingEventInterceptor

//在完成构造event之后，返回event
- (void)growingEventManagerEventDidBuild:(GrowingBaseEvent* _Nullable)event {
    //  eventBus 传入 GTouch
    if (event.eventType == GrowingEventTypeVisitorAttributes) {
        GrowingBaseAttributesEvent *attrEvent = (GrowingBaseAttributesEvent*)event;
        GrowingEBManualTrackEvent *visitorTrackEvent = [[GrowingEBManualTrackEvent alloc] initWithData:@{@"data" : attrEvent.attributes?:@{}} manualTrackEventType:GrowingManualTrackVisitorEventType];
        [GrowingEventBus send:visitorTrackEvent];
    } else if (event.eventType == GrowingEventTypeCustom) {
        GrowingCustomEvent *customEvent = (GrowingCustomEvent*)event;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"s"] = customEvent.sessionId;
        dict[@"tm"] = @(customEvent.timestamp);
        dict[@"t"] = @"cstm";
        dict[@"d"] = customEvent.domain;
        dict[@"cs1"] = customEvent.userId;
        if (customEvent.extraParams) {
            dict[@"gio_Id"] = customEvent.extraParams[@"gioId"];
            dict[@"dataSourceId"] = event.extraParams[@"dataSourceId"];
        }
        dict[@"u"] = customEvent.deviceId;
        dict[@"esid"] = @(customEvent.eventSequenceId);
        dict[@"gesid"] = @(customEvent.globalSequenceId);
        dict[@"n"] = customEvent.eventName;
        dict[@"var"] = customEvent.attributes;
//        dict[@"p"] = customEvent.;
        GrowingEBManualTrackEvent *customTrackEvent = [[GrowingEBManualTrackEvent alloc] initWithData:@{@"data" : dict} manualTrackEventType:GrowingManualTrackCustomEventType];
        [GrowingEventBus send:customTrackEvent];
    }
    
}

#pragma mark - old deeplink

- (BOOL)isV1Url:(NSURL *)url
{
    return ([url.host isEqualToString:@"datayi.cn"] || [url.host hasSuffix:@".datayi.cn"]);
}

- (BOOL)isGrowingIOUrl:(NSURL *)url
{
    if(!url)
    {
        return NO;
    }
    
    // 检查是否是GrowingIO的业务URL
    
    BOOL isV1Url = [self isV1Url:url];
    
    if (!isV1Url && ![url.scheme hasPrefix:@"growing."] && !([url.absoluteString rangeOfString:@"growingio.com"].location != NSNotFound || [url.absoluteString rangeOfString:@"gio.ren"].location != NSNotFound))
    {
        return NO;
    }
    
    // 分发
    if (!isV1Url && ![[url host] isEqualToString:@"growing"] && !([url.absoluteString rangeOfString:@"growingio.com"].location != NSNotFound || [url.absoluteString rangeOfString:@"gio.ren"].location != NSNotFound))
    {
        return NO;
    }
    return YES;
}

/// 处理url，如果能够处理则返回YES,否则返回NO
/// @param url 链接Url
- (BOOL)growingHandlerUrl:(NSURL *)url {
    if (![self isGrowingIOUrl:url]) {
        return NO;
    }
    NSDictionary *params = url.growingHelper_queryDict;
    
    if ([params.allKeys containsObject:@"gtouchType"]) {
        [[[GrowingMediator sharedInstance] performClass:@"GrowingTouchHandleURL" action:@"growingTouchHandleUrl:" params:@{@"0":params}] boolValue];
        return YES;
    }
    return  NO;
}

@end
