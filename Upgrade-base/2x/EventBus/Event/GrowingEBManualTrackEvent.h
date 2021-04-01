//
//  GrowingEBManualTrackEvent.h
//  GrowingCoreKit
//
//  Created by GrowingIO on 2019/6/27.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import "GrowingEBEvent.h"

typedef NS_ENUM(NSInteger, GrowingManualTrackEventType) {
    GrowingManualTrackEvarEventType,
    GrowingManualTrackCustomEventType,
    GrowingManualTrackPeopleVarEventType,
    GrowingManualTrackVisitorEventType
};


@interface GrowingEBManualTrackEvent : GrowingEBEvent

- (instancetype)initWithData:(NSDictionary *)data manualTrackEventType:(GrowingManualTrackEventType)eventType;

@property (nonatomic, assign, readonly) GrowingManualTrackEventType eventType;


@end
