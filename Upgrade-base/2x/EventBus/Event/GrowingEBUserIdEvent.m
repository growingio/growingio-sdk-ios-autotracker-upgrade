//
//  GrowingEBUserIdEvent.m
//  GrowingCoreKit
//
//  Created by GrowingIO on 2019/6/27.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import "Upgrade-base/2x/EventBus/Event/GrowingEBUserIdEvent.h"

@implementation GrowingEBUserIdEvent

- (instancetype)initWithData:(NSDictionary *)data operateType:(GrowingUserIdOperateType)operateType {
    if (self = [super initWithData:data]) {
        _operateType = operateType;
    }
    return self;
}

@end
