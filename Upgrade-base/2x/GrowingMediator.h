//
//  GrowingMediator.h
//  Growing
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018年 GrowingIO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrowingMediator : NSObject

+ (instancetype)sharedInstance;

/**
 * 调用模块类方法
 * @param className   类名称
 * @param actionName  方法名称
 * @param params      方法参数->字典的key为第几个参数,从0开始 比如xx是第0个参数 @{@"0":xx}
 */
- (id)performClass:(NSString *)className action:(NSString *)actionName params:(NSDictionary *)params;

/**
 * 调用模块实例方法
 * @param target      实例
 * @param actionName  方法名称
 * @param params      方法参数->字典的key为第几个参数,从0开始 比如xx是第0个参数 @{@"0":xx}
 */
- (id)performTarget:(NSObject *)target action:(NSString *)actionName params:(NSDictionary *)params;

@end
