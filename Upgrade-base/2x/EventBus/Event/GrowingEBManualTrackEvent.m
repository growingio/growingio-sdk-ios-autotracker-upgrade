//
//  GrowingEBManualTrackEvent.m
//  GrowingCoreKit
//
//  Created by GrowingIO on 2019/6/27.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import "Upgrade-base/2x/EventBus/Event/GrowingEBManualTrackEvent.h"

@implementation GrowingEBManualTrackEvent

- (instancetype)initWithData:(NSDictionary *)data manualTrackEventType:(GrowingManualTrackEventType)eventType {
    if (self = [super initWithData:data]) {
        _eventType = eventType;
    }
    return self;
}

@end
