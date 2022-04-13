//
//  GrowingEBApplicationEvent.h
//  GrowingCoreKit
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import "Upgrade-base/2x/EventBus/Event/GrowingEBEvent.h"

typedef NS_ENUM(NSUInteger, GrowingApplication) {
    GrowingApplicationDidFinishLaunching,
    GrowingApplicationWillTerminate,
    GrowingApplicationDidEnterBackground,
    GrowingApplicationDidBecomeActive,
    GrowingApplicationWillResignActive,
    GrowingApplicationWillEnterForeground,
    GrowingApplicationDidReceiveRemoteNotification,
};

@interface GrowingEBApplicationEvent : GrowingEBEvent

- (instancetype)initWithData:(NSDictionary *)data lifeType:(GrowingApplication)lifeType;

- (instancetype)initWithLifeType:(GrowingApplication)lifeType;

@property (nonatomic, assign, readonly) GrowingApplication lifeType;

@end

