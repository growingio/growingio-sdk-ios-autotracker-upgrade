//
// GrowingEvent.h
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GrowingBaseBuilder;

@interface GrowingEvent : NSObject

@property (nonatomic, retain  , nonnull) NSMutableDictionary *dataDict;
@property (nonatomic, readonly, nonnull) NSString *uuid;

- (_Nullable instancetype)initWithUUID:(NSString* _Nonnull)uuid
                                  data:(NSDictionary* _Nullable)data NS_DESIGNATED_INITIALIZER;

//2.0 event转 3.0 event
- (GrowingBaseBuilder *)to3xEventBuilder;

@end

NS_ASSUME_NONNULL_END
