//
//  GrowingEBUserIdEvent.h
//  GrowingCoreKit
//
//  Created by GrowingIO on 2019/6/27.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import "Upgrade-base/2x/EventBus/Event/GrowingEBEvent.h"

typedef NS_ENUM(NSUInteger, GrowingUserIdOperateType) {
    GrowingSetUserIdType,
    GrowingClearUserIdType
};

@interface GrowingEBUserIdEvent : GrowingEBEvent

- (instancetype)initWithData:(NSDictionary *)data operateType:(GrowingUserIdOperateType)operateType;

@property (nonatomic, assign, readonly) GrowingUserIdOperateType operateType;

@end

