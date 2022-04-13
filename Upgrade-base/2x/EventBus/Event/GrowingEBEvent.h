//
//  GrowingEBEvent.h
//  GrowingCoreKit
//
//  Created by apple on 2019/4/20.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrowingEBEvent : NSObject

@property (nonatomic, strong, readonly) NSDictionary *dataDict;

- (instancetype)initWithData:(NSDictionary *)dataDict;

@end

