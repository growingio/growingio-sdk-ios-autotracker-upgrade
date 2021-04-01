//
// GrowingEventManager+Growing2x.m
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


#import "GrowingEventManager+Growing2x.h"
#import "GrowingEventGenerator.h"
@implementation GrowingEventManager (Growing2x)

- (void)addEvent:(GrowingEvent *)event
        thisNode:(id _Nullable)thisNode
     triggerNode:(id)triggerNode
     withContext:(id)context {
    GrowingBaseBuilder *builder = event.to3xEventBuilder;
    if (builder) {
        [[GrowingEventManager shareInstance] postEventBuidler:builder];
    }
}

@end
