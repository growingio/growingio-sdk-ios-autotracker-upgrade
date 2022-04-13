//
//  GrowingEBMonitorEvent.m
//  GrowingCoreKit
//
//  Created by BeyondChao on 2019/11/26.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import "Upgrade-base/2x/EventBus/Event/GrowingEBMonitorEvent.h"

@implementation GrowingEBMonitorEvent

- (instancetype)initWithData:(NSDictionary *)data growingMonitorState:(GrowingMonitorState)monitorState {
    if (self = [super initWithData:data]) {
        _monitorState = monitorState;
    }
    return self;
}

@end
