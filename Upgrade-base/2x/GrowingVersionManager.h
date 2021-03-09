//
//  GrowingVersionManager.h
//  GrowingCoreKit
//
//  Created by apple on 2019/9/9.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GrowingVersionManager : NSObject

+ (void)registerVersionInfo:(NSDictionary *)infoDict;

+ (NSString *)versionInfo;

@end

