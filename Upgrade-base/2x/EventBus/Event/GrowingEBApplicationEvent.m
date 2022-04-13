//
//  GrowingEBApplicationEvent.m
//  GrowingCoreKit
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import "Upgrade-base/2x/EventBus/Event/GrowingEBApplicationEvent.h"

@implementation GrowingEBApplicationEvent

- (instancetype)initWithData:(NSDictionary *)data lifeType:(GrowingApplication)lifeType
{
    if (self = [super initWithData:data]) {
        _lifeType = lifeType;
    }
    return self;
}

- (instancetype)initWithLifeType:(GrowingApplication)lifeType
{
    if (self = [super initWithData:nil]) {
        _lifeType = lifeType;
    }
    return self;
}

@end
