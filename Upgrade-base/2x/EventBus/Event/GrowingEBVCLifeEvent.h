//
//  GrowingEBVCLifeEvent.h
//  GrowingCoreKit
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import "Upgrade-base/2x/EventBus/Event/GrowingEBEvent.h"

typedef NS_ENUM(NSUInteger, GrowingVCLife) {
    GrowingVCLifeWillAppear,
    GrowingVCLifeDidAppear,
    GrowingVCLifeWillDisappear,
    GrowingVCLifeDidDisappear,
};

@interface GrowingEBVCLifeEvent : GrowingEBEvent

- (instancetype)initWithLifeType:(GrowingVCLife)lifeType;

@property (nonatomic, assign, readonly) GrowingVCLife lifeType;

@end

