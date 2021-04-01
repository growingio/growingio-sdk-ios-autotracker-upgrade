//
//  GrowingEBVCLifeEvent.m
//  GrowingCoreKit
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import "GrowingEBVCLifeEvent.h"

@implementation GrowingEBVCLifeEvent

- (instancetype)initWithLifeType:(GrowingVCLife)lifeType
{
    if (self = [super initWithData:nil]) {
        _lifeType = lifeType;
    }
    return self;
}


@end
