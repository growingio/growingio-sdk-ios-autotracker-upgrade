//
//  KDNetworkInterfaceManager.m
//  Netpas
//
//  Created by GrowinIO on 4/23/15.
//  Copyright (c) 2015 GrowinIO. All rights reserved.
//

#import "Upgrade-base/2x/Network/GROW_KDNetworkInterfaceManager.h"
#import "Upgrade-base/Public/GrowingInstance.h"

#import "GrowingTrackerCore/Thirdparty/Reachability/GrowingReachability.h"
#import "GrowingTrackerCore/Manager/GrowingConfigurationManager.h"

@interface GROW_KDNetworkInterfaceManager()
@property (nonatomic, retain) GrowingReachability * internetReachability;
@property (nonatomic, assign) BOOL isUnknown;
@end

@implementation GROW_KDNetworkInterfaceManager {
}

+ (instancetype)sharedInstance {
    if ([GrowingInstance sharedInstance].accountID.length == 0 ||
        ![GrowingConfigurationManager sharedInstance].trackConfiguration) {
        return nil;
    }
    
    static dispatch_once_t pred;
    __strong static id sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.internetReachability = [GrowingReachability reachabilityForInternetConnection];
        [self.internetReachability startNotifier];
        self.isUnknown = YES;
    }
    return self;
}

- (void)updateInterfaceInfo {
#ifdef GROWINGIO_SIMULATING_3G
    _WiFiValid = NO;
    _WWANValid = YES;
    _isUnknown = NO;
#else // #ifdef GROWINGIO_SIMULATING_3G
    GrowingNetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
    BOOL connectionRequired = [self.internetReachability connectionRequired];
    _isUnknown = (netStatus == GrowingUnknown);
    _WiFiValid = (netStatus == GrowingReachableViaWiFi && !connectionRequired);
    _WWANValid = (netStatus == GrowingReachableViaWWAN && !connectionRequired);
#endif // #ifdef GROWINGIO_SIMULATING_3G
}

@end
