//
// GrowingEvent.m
// GrowingAnalytics-upgrade-Autotracker-upgrade-2to3-Upgrade-base
//
//  Created by sheng on 2021/3/4.
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


#import "GrowingEvent.h"
#import "GrowingSession.h"
#import "GrowingTimeUtil.h"
#import "GrowingDeviceInfo.h"
#import "GROW_KDNetworkInterfaceManager.h"
#import "GrowingVisitEvent.h"
#import "GrowingLogMacros.h"
#import "GrowingLogger.h"
#import "GrowingGlobal.h"
@implementation GrowingEvent

- (instancetype)initWithUUID:(NSString*)uuid data:(NSDictionary*)data
{
    self = [super init];
    if (self)
    {
        _uuid = uuid;
        self.dataDict = [[NSMutableDictionary alloc] initWithDictionary:data];
    }
    return self;
}


- (instancetype)initWithTimestamp:(NSNumber *)tm
{
    self = [self initWithUUID:[[NSUUID UUID] UUIDString] data:nil];
    if (self)
    {
        self.dataDict[@"s"]  = [GrowingSession currentSession].sessionId ?: @"";
        if (tm)
        {
            self.dataDict[@"tm"] = tm;
        }
        else
        {
            self.dataDict[@"tm"] = @([GrowingTimeUtil currentTimeMillis]);
        }
        self.dataDict[@"t"] = [self eventTypeKey];
        self.dataDict[@"d"] = [GrowingDeviceInfo currentDeviceInfo].bundleID;
        if ([GrowingSession currentSession].loginUserId.length > 0) {
            self.dataDict[@"cs1"] = [GrowingSession currentSession].loginUserId;
        }
        self.dataDict[@"u"] = [GrowingDeviceInfo currentDeviceInfo].deviceIDString ?: @"";
    }
    return self;
}

- (instancetype)init
{
    return [self initWithTimestamp:nil];
}

+ (instancetype)event
{
    return [[self alloc] init];
}

+ (instancetype)eventWithTimestamp:(NSNumber *)tm
{
    return [[self alloc] initWithTimestamp:tm];
}

- (NSString*)description
{
    return self.dataDict.description;
}

- (NSString*)eventTypeKey {
    return @"";
}

// 以后也许可以和上一个函数 assignLocationIfAny 合并
- (void)assignRadioType
{
    // 字段为 r，取值为 CELL/WIFI/UNKNOWN/NONE
    GROW_KDNetworkInterfaceManager * network = [GROW_KDNetworkInterfaceManager sharedInstance];
    [network updateInterfaceInfo];
    if (network.isUnknown)
    {
        self.dataDict[@"r"] = @"UNKNOWN";
    }
    else if (network.WiFiValid)
    {
        self.dataDict[@"r"] = @"WIFI";
    }
    else if (network.WWANValid)
    {
        self.dataDict[@"r"] = @"CELL";
    }
    else
    {
        self.dataDict[@"r"] = @"NONE";
    }
}

- (GrowingBaseBuilder *)to3xEventBuilder {
    NSMutableDictionary *dict = self.dataDict;
    NSNumber *timestr = dict[@"tm"];
    long long timestamp = timestr.longLongValue;
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic setValue:dict[@"gio_Id"] forKey:@"gioId"];
    [mutDic setValue:dict[@"dataSourceId"] forKey:@"dataSourceId"];
    //关于 esid 和 gesid
    //2.0是在入库时候生成，3.0在event build时生成

    GrowingBaseBuilder *builder = nil;
    if ([dict[@"t"] isEqualToString:@"cstm"]) {
        builder = GrowingCustomEvent.builder.setEventName(dict[@"n"]).setAttributes(dict[@"var"]).setSessionId(dict[@"s"]).setTimestamp(timestamp).setDomain(dict[@"d"]).setUserId(dict[@"cs1"]).setExtraParams(mutDic).setDeviceId(dict[@"u"]);
    }else if ([dict[@"t"] isEqualToString:@"vstr"]) {
        builder = GrowingVisitEvent.builder.setSessionId(dict[@"s"]).setTimestamp(timestamp).setDomain(dict[@"d"]).setUserId(dict[@"cs1"]).setExtraParams(mutDic).setDeviceId(dict[@"u"]);
    }else {
        GIOLogError(@"to3xEventBuilder无法识别的事件类型 : %@",dict[@"t"]);
    }
    
  
    return builder;
}


@end
