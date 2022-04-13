//
//  GrowingEventPopupDecisionAction.h
//  GrowingTouchCoreKit
//
//  Created by GrowingIO on 2020/8/19.
//  Copyright © 2020 GrowingIO. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GrowingPopupWindowEvent;

NS_ASSUME_NONNULL_BEGIN

@interface GrowingEventPopupDecisionAction : NSObject

/// 弹窗展示、会发送展示事件
- (void)appeared;

/// 弹窗点击、会发送点击事件
- (void)clicked;

/// 弹窗关闭、会发送关闭事件
- (void)closed;

@end

NS_ASSUME_NONNULL_END
