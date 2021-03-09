//
//  GrowingPopupWindowEvent.h
//  GrowingTouchCoreKit
//
//  Created by GrowingIO on 2020/8/17.
//  Copyright © 2020 GrowingIO. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GrowingRule, GrowingABTest;

NS_ASSUME_NONNULL_BEGIN

@interface GrowingPopupWindowEvent : NSObject

/// 消息唯一标识，客户端可以用来去重。
@property (nonatomic, readonly, assign) NSInteger popupEventId;
/// 代表弹窗消息的状态，activated：有效，其他状态都不显示。
@property (nonatomic, readonly, copy) NSString *state;
/// 弹窗名称
@property (nonatomic, readonly, copy) NSString *name;
/// normal 类型的弹窗 html 地址，用 webView 加载。
@property (nonatomic, readonly, copy) NSString *content;
/// 优先级，数字越大优先级越高，如果优先级相同比较最后更新时间，最近更新的优先。
@property (nonatomic, readonly, assign) int priority;
/// 最近更新时间。
@property (nonatomic, readonly, assign) long long updateAt;
/// 弹窗触发规则
@property (nonatomic, readonly, strong) GrowingRule *rule;
/// A/B 测试
@property (nonatomic,readonly, strong) GrowingABTest *abTest;

@end

NS_ASSUME_NONNULL_END
