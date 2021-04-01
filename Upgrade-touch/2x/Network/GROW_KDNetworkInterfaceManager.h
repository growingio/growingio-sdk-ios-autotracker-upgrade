//
//  KDNetworkInterfaceManager.h
//  Netpas
//
//  Created by GrowinIO on 4/23/15.
//  Copyright (c) 2015 GrowinIO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GROW_KDNetworkInterfaceManager : NSObject

@property (readonly) BOOL WWANValid;
@property (readonly) BOOL WiFiValid;
@property (readonly) BOOL isUnknown;

+ (instancetype)sharedInstance;

- (void)updateInterfaceInfo;

@end
