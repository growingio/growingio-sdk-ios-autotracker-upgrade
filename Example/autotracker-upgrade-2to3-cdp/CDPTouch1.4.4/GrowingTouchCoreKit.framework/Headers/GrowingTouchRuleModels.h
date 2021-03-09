//
//  GrowingTouchRuleModels.h
//  GrowingTouchCoreKit
//
//  Created by GrowingIO on 2019/12/5.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const GrowingRuleDisposableClickMode;
FOUNDATION_EXPORT NSString * const GrowingRuleLoopClickMode;

extern NSString *const GIO_LoginUserFilter;
extern NSString *const GIO_EventFilter;
extern NSString *const GIO_VisitorFilter;

@interface GrowingRuleFilterModel : NSObject <NSCoding>
/// 符号
@property(nonatomic, copy) NSString *symbol;
/// 类型
@property(nonatomic, copy) NSString *type;
/// 事件标识符
@property(nonatomic, copy) NSString *key;
/// 运算符
@property(nonatomic, copy) NSString *op;
/// 值类型
@property (nonatomic, copy) NSString *valueType;
/// 运算结果
@property(nonatomic, strong) NSArray *values;

@end

@interface GrowingRuleTriggerDimFilterModel : NSObject <NSCoding>

/// 维度名称
@property (nonatomic, copy) NSString *dim;
/// 运算符
@property (nonatomic, copy) NSString *op;
/// 值类型
@property (nonatomic, copy) NSString *valueType;
/// 运算结果
@property (nonatomic, strong) NSArray *values;

@end

@interface GrowingRuleTriggerFilterModel : NSObject <NSCoding>

/// 过滤类型
@property (nonatomic, copy) NSString *type;
/// 别名
@property (nonatomic, copy) NSString *alias;
/// 事件标识符
@property (nonatomic, copy) NSString *key;
/// 事件类型 （system: 预定义事件、custom: 自定义事件）
@property (nonatomic, copy) NSString *measurementType;
/// 次数或者求和
@property (nonatomic, copy) NSString *aggregator;
/// 运算符
@property (nonatomic, copy) NSString *op;
/// 运算结果
@property (nonatomic, strong) NSArray *values;
/// 额外属性
@property (nonatomic, copy) NSString *attribute;
/// 维度运算符
@property (nonatomic, copy) NSString *dimFiltersOp;
/// 过滤维度
@property (nonatomic, strong) NSArray<GrowingRuleTriggerDimFilterModel *> *dimFilters;

@end

@interface GrowingRuleFilter: NSObject <NSCoding>

/// 完整的条件表达式
@property (nonatomic, readonly, copy) NSString *expr;
/// 表达式的每个条件
@property (nonatomic, readonly, strong) NSArray<GrowingRuleFilterModel *> *exprs;

@end

@interface GrowingRuleTriggerFilter: NSObject <NSCoding>

/// 完整的条件表达式
@property (nonatomic, readonly, copy) NSString *conditionExpr;
/// 表达式的每个条件
@property (nonatomic, readonly, strong) NSArray<GrowingRuleTriggerFilterModel *> *conditions;

@end

@interface GrowingABTest : NSObject

/// 实验组的编号
@property (nonatomic, copy) NSString *dimension;
/// 当前的实验组（A组或B组）
@property (nonatomic, copy) NSString *symbol;
/// 控制组，YES：不要弹窗；NO: 需要弹窗
@property (nonatomic, assign) BOOL ctrlGroup;

@end

@interface GrowingRule : NSObject 

/// 消息有效开始时间。暂时不生效，传任意时间
@property(nonatomic, readonly, assign) long long startAt;
/// 消息有效截止时间。暂时不生效，传任意时间
@property(nonatomic, readonly, assign) long long endAt;
/// 消息触发次数
@property(nonatomic, readonly, assign) int limit;
/// 弹窗用户属性过滤规则
@property(nonatomic, readonly, strong) GrowingRuleFilter *ruleFilter;
/// 弹窗触发事件规则
@property(nonatomic, readonly, strong) GrowingRuleTriggerFilter *triggerFilter;
/// 弹窗间隔时间
@property(nonatomic, readonly, assign) long long triggerCd;
/// 去重配置 (loop：点完之后满足一定条件会继续弹出；dispose：点击之后再也不弹)
@property(nonatomic, readonly, copy) NSString *clickMode;
/// 弹窗跳转内容
@property(nonatomic, readonly, copy) NSString *target;

@end

