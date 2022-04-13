//
// GrowingGlobal.h
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

@interface GrowingGlobal : NSObject

BOOL SDKDoNotTrack(void);
#define parameterKeyErrorLog @"当前数据的标识符不合法。合法的标识符的详细定义请参考：https://docs.growingio.com/v3/developer-manual/sdkintegrated/ios-sdk/ios-sdk-api/customize-api"
#define parameterValueErrorLog @"当前数据的值不合法。合法值的详细定义请参考：https://docs.growingio.com/v3/developer-manual/sdkintegrated/ios-sdk/ios-sdk-api/customize-api"

@end

NS_ASSUME_NONNULL_END
