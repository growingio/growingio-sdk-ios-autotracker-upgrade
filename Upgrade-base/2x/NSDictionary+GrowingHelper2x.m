//
// NSDictionary+GrowingHelper2x.m
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


#import "NSDictionary+GrowingHelper2x.h"
#import "GrowingLogMacros.h"
#import "GrowingCocoaLumberjack.h"
#import "GrowingGlobal.h"

@implementation NSDictionary (GrowingHelper2x)

- (BOOL)isValidDicVar {
    for (NSString * k in self)
    {
        NSString * key = k ;
        if (self[key] == nil || key.length > 50 )
        {
            GIOLogError(parameterKeyErrorLog);
            return NO ;
        }
        if ([self[key] isKindOfClass:[NSNull class]] || self[key] == nil)
        {
            GIOLogError(parameterValueErrorLog);
            return NO ;
        }
        if ([self[key] isKindOfClass:[NSString class]])
        {
            NSString * v = self[key];
            if (v.length > 1000)
            {
                GIOLogError(parameterValueErrorLog);
                return NO ;
            }
        }
        if (![self[key] isKindOfClass:[NSString class]] && ![self[key] isKindOfClass:[NSNumber class]]) {
            GIOLogError(parameterValueErrorLog);
            return NO ;
        }
    }
    return YES ;
}

@end
