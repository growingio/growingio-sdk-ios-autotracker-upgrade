//
//  GrowingEventBus.h
//  GrowingCoreKit
//
//  Created by apple on 2019/4/20.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GrowingEBEvent;

@interface GrowingEventBus : NSObject

+ (void)send:(GrowingEBEvent *)event;

@end

