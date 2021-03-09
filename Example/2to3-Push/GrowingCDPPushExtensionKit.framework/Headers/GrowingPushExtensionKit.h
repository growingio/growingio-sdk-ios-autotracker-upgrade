//
//  GrowingPushExtensionKit.h
//  GrowingPushExtensionKit
//
//  Created by GrowingIO on 2019/5/30.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UNNotificationRequest;
@class UNNotificationAttachment;

@interface GrowingPushExtensionKit : NSObject

/// 初始化SDK，请在主线程中调用
/// @param accountId 项目ID
/// @param dataSourceId 数据源ID
+ (void)startWithAccountId:(NSString *_Nonnull)accountId dataSourceId:(NSString *_Nonnull)dataSourceId;

//  pushExtensionKit 的版本号
+ (NSString *_Nonnull)pushExtensionKitVersion;

/// 事件上报和多媒体推送支持接口
/// @param request 推送请求
/// @param handler 处理消息的回执，回调方法中处理管理的富媒体文件和错误信息(事件上报的错误和附件下载错误)
/// @note  关联的富媒体文件，需要在GrowingIO 运营平台设置相关附件资源，SDK内部会自动下载
+ (void)handleNotificationRequest:(nonnull UNNotificationRequest *)request
                   withCompletion:(nullable void(^)( NSArray <UNNotificationAttachment *>* _Nullable attachments,  NSArray <NSError *>* _Nullable errors))handler;

// 设置数据收集平台服务器地址
+ (void)setTrackerHost:(NSString *_Nonnull)host;

+ (void)upgradeTo3x;

@end

