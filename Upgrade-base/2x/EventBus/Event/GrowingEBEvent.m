//
//  GrowingEBEvent.m
//  GrowingCoreKit
//
//  Created by apple on 2019/4/20.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import "Upgrade-base/2x/EventBus/Event/GrowingEBEvent.h"

@implementation GrowingEBEvent

- (instancetype)initWithData:(NSDictionary *)dataDict
{
    
    if (self = [super init]) {
        _dataDict = dataDict;
    }
    return self;
    
}


@end
