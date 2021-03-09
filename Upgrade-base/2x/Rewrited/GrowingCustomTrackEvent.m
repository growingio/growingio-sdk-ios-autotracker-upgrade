//
// GrowingCustomTrackEvent.m
// GrowingAnalytics-upgrade-Autotracker-upgrade-2to3-Upgrade-base
//
//  Created by sheng on 2021/3/3.
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


#import "GrowingCustomTrackEvent.h"
#import "GrowingLogMacros.h"
#import "GrowingArgumentChecker.h"
#import "GrowingCocoaLumberjack.h"
#import "GrowingSession.h"
#import "GrowingTimeUtil.h"
#import "GrowingDeviceInfo.h"
#import "GROW_KDNetworkInterfaceManager.h"
#import "GrowingGlobal.h"

@implementation GrowingCustomTrackEvent

- (instancetype)initWithEventName:(NSString *)eventName withNumber:(NSNumber *)number withVariable:(NSDictionary<NSString *, NSObject *> *)variable
{
    if (eventName == nil || ![eventName isKindOfClass:[NSString class]]) {
        GIOLogError(parameterKeyErrorLog);
        return nil;
    }
    //eventName 有效性判断
    if ([GrowingArgumentChecker isIllegalEventName:eventName])
    {
        return nil; // invalid eventName is not acceptable
    }
    //number有效性判断
    if (number == nil)
    {
        GIOLogError(parameterValueErrorLog);
        return nil;// invalid number is not acceptable
    }
    
    //小数需要截取到小数点后两位
    if (CFNumberIsFloatType((CFNumberRef)number))
    {
        NSString *str = [NSString stringWithFormat:@"%.2f", number.doubleValue];
        number = @(str.doubleValue);
    }
    
    
    GrowingCustomTrackEvent *customEvent = [[GrowingCustomTrackEvent alloc] init];
    NSMutableDictionary *dataDict = customEvent.dataDict;
    dataDict[@"n"] = eventName;
    if (variable.count != 0) {
        dataDict[@"var"] = variable;
    }
    if (![number isEqualToNumber: @LLONG_MIN]) {
        dataDict[@"num"] = number;
    }
    return customEvent;
}


- (NSString *)eventTypeKey
{
    return @"cstm";
}

@end
