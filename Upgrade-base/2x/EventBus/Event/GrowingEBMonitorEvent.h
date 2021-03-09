//
//  GrowingEBMonitorEvent.h
//  GrowingCoreKit
//
//  Created by BeyondChao on 2019/11/26.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import "GrowingEBEvent.h"

typedef NS_ENUM (NSUInteger, GrowingMonitorState) {
    GrowingMonitorStateUploadExceptionDefault,
    GrowingMonitorStateUploadExceptionEnable,
    GrowingMonitorStateUploadExceptionDisable,
};

NS_ASSUME_NONNULL_BEGIN

@interface GrowingEBMonitorEvent : GrowingEBEvent

- (instancetype)initWithData:(NSDictionary *)data growingMonitorState:(GrowingMonitorState)monitorState;

@property (nonatomic, assign, readonly) GrowingMonitorState monitorState;

@end

NS_ASSUME_NONNULL_END
