//
//  GrowingVersionManager.m
//  GrowingCoreKit
//
//  Created by apple on 2019/9/9.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import "Upgrade-base/2x/GrowingVersionManager.h"

#import "GrowingTrackerCore/Helpers/NSDictionary+GrowingHelper.h"

@implementation GrowingVersionManager

static NSMutableDictionary *versionDict;
+ (void)registerVersionInfo:(NSDictionary *)infoDict
{
    if (versionDict.count == 0) {
        versionDict = [[NSMutableDictionary alloc] init];
    }
    [versionDict addEntriesFromDictionary:infoDict];
}

static NSString *versionInfoString;
+ (NSString *)versionInfo
{
    if (versionInfoString.length == 0) {
        versionInfoString = [versionDict growingHelper_jsonString];
    }
    return versionInfoString;
}

@end
