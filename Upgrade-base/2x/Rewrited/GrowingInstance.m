//
// GrowingInstance.m
// GrowingAnalytics-upgrade-Autotracker-upgrade-2to3-Upgrade-base
//
//  Created by sheng on 2021/3/2.
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

#import "Upgrade-base/Public/GrowingInstance.h"
#import "Upgrade-base/Public/Growing.h"

#import "GrowingTrackerCore/Manager/GrowingConfigurationManager.h"
#import "GrowingTrackerCore/Thirdparty/Logger/GrowingLogger.h"

@implementation GrowingInstance

+ (instancetype)sharedInstance
{
    static GrowingInstance *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GrowingInstance alloc] init];
    });
    
    return instance;
}
- (NSString *)accountID {
    return [GrowingConfigurationManager sharedInstance].trackConfiguration.projectId ? : @"";
}

static GrowingAspectMode growingAspectMode = GrowingAspectModeSubClass;
+ (void)setAspectMode:(GrowingAspectMode)mode
{
    if (![self isFreezeAspectMode])
    {
        growingAspectMode = mode;
    }
    else
    {
        GIOLogWarn(@"setAspectMode失败 程序监控已经开始 请在main函数第一行设置GrowingAspectMode");
    }
}

+ (GrowingAspectMode)aspectMode
{
    return growingAspectMode;
}

static BOOL isFreezeAspectMode = NO;
+ (void)setFreezeAspectMode
{
    isFreezeAspectMode = YES;
}

+ (BOOL)isFreezeAspectMode
{
    return isFreezeAspectMode;
}

//+ (void)reportShortChainDeeplink:(NSURL *)linkURL
//{
//    [[self sharedInstance] reportShortChainDeeplink:linkURL isManual:NO callback:nil];
//}
//
//- (void)reportShortChainDeeplink:(NSURL *)linkURL isManual:(BOOL)isManual callback:(void(^)(NSDictionary *params, NSTimeInterval processTime, NSError *error))callback
//{
//    if (![GrowingConfigurationManager sharedInstance].trackConfiguration.uploadExceptionEnable) {
//        return;
//    }
//
//    NSDate *startData = [NSDate date];
//    NSString *renngageMechanism = @"universal_link";
//    NSString *hashId = [linkURL.path componentsSeparatedByString:@"/"].lastObject;
//
//    [self loadUserAgentWithCompletion:^(NSString * ua) {
//
//        GrowingDeepLinkModel *deepLinkModel = [[GrowingDeepLinkModel alloc] init];
//
//        [deepLinkModel getParamByHashId:hashId query:linkURL.query
//                                     ua:ua
//                                 manual:isManual
//                                succeed:^(NSHTTPURLResponse *httpResponse, NSData *data) {
//
//            NSDictionary *responseDict = [data growingHelper_dictionaryObject];
//            NSNumber *statusNumber = responseDict[@"code"];
//            NSString *message = responseDict[@"msg"] ? : @"";
//
//            NSDictionary *dataDict = responseDict[@"data"];
//
//            if (statusNumber.intValue != 200) {
//                NSError *err = [NSError errorWithDomain:@"com.growingio.deeplink" code:statusNumber.integerValue userInfo:@{@"error" : message}];
//                NSDate *endTime = [NSDate date];
//                NSTimeInterval processTime = [endTime timeIntervalSinceDate:startData];
//                if (callback) {
//                    callback(nil, processTime, err);
//                } else if (GrowingInstance.deeplinkHandler) {
//                    GrowingInstance.deeplinkHandler(nil, processTime, err);
//                }
//                return;
//            }
//
//            NSString *link_id = [dataDict objectForKey:@"link_id"];
//            NSString *click_id = [dataDict objectForKey:@"click_id"];
//            NSNumber *tm_click = [dataDict objectForKey:@"tm_click"];
//            NSDictionary *custom_params = [dataDict objectForKey:@"custom_params"];
//
//            if (!isManual) {
//                [self reportReengageWithCustomParams:custom_params
//                                                  ua:ua
//                                   renngageMechanism:renngageMechanism
//                                             link_id:link_id
//                                            click_id:click_id
//                                            tm_click:tm_click];
//            }
//
//            if (!GrowingInstance.deeplinkHandler && !callback) {
//                return;
//            }
//
//            // 处理参数回调
//            NSMutableDictionary *dictInfo = [NSMutableDictionary dictionaryWithDictionary:custom_params];
//            if ([dictInfo objectForKey:@"_gio_var"]) {
//                [dictInfo removeObjectForKey:@"_gio_var"];
//            }
//            if (![dictInfo objectForKey:@"+deeplink_mechanism"]) {
//                [dictInfo setObject:renngageMechanism forKey:@"+deeplink_mechanism"];
//            }
//
//            NSError *err = nil;
//            if (custom_params.count == 0) {
//                // 默认错误
//                err = [NSError errorWithDomain:@"com.growingio.deeplink" code:1 userInfo:@{@"error" : @"no custom_params"}];
//            }
//
//            NSDate *endDate = [NSDate date];
//            NSTimeInterval processTime = [endDate timeIntervalSinceDate:startData];
//
//            if (callback) {
//                callback(dictInfo, processTime, err);
//            } else if (GrowingInstance.deeplinkHandler) {
//                GrowingInstance.deeplinkHandler(dictInfo, processTime, err);
//            }
//
//        } fail:^(NSHTTPURLResponse *httpResponse, NSData *data, NSError *error) {
//
//            NSDate *endTime = [NSDate date];
//            NSTimeInterval processTime = [endTime timeIntervalSinceDate:startData];
//
//            if (callback) {
//                callback(nil, processTime, error);
//            } else if (GrowingInstance.deeplinkHandler) {
//                GrowingInstance.deeplinkHandler(nil, processTime, error);
//            }
//        }];
//
//    }];
//}
//
//- (void)loadUserAgentWithCompletion:(void (^)(NSString *))completion {
//    if (self.userAgent) {
//        return completion(self.userAgent);
//    }
//
//    __weak typeof(self) weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //WKWebView的initWithFrame方法偶发崩溃，这里@try@catch保护
//        @try {
//            self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
//            [self.wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable response, NSError *_Nullable error) {
//                if (error || !response) {
//                    GIOLogError(@"WKWebView evaluateJavaScript load UA error:%@", error);
//                    completion(nil);
//                } else {
//                    weakSelf.userAgent = response;
//                    completion(weakSelf.userAgent);
//                }
//                weakSelf.wkWebView = nil;
//            }];
//        } @catch (NSException *exception) {
//            GIOLogDebug(@"loadUserAgentWithCompletion crash :%@",exception);
//            completion(nil);
//        }
//
//    });
//}


@end
