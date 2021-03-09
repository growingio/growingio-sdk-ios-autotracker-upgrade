//
//  GrowingBaseModel.h
//  Growing
//
//  Created by 陈曦 on 15/10/27.
//  Copyright © 2015年 GrowingIO. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GrowingNetworkConfig.h"

typedef void ( ^GROWNetworkSuccessBlock ) ( NSHTTPURLResponse *httpResponse , NSData *data);
typedef void ( ^GROWNetworkFailureBlock ) ( NSHTTPURLResponse *httpResponse , NSData *data, NSError *error );

typedef NS_ENUM(NSUInteger,GrowingModelType)
{
    GrowingModelTypeEvent,
    GrowingModelTypeSDKCircle,
    GrowingModelTypeCount
};

@interface GrowingBaseModel : NSObject

+ (instancetype)sdkInstance;
+ (instancetype)eventInstance;
+ (instancetype)shareInstanceWithType:(GrowingModelType)type;

@property (nonatomic, readonly) GrowingModelType modelType;

- (void)authorityVerification:(NSMutableURLRequest *)request;

/**
 For httpstatusCode 403 (except GrowingModelTypeEvent)
 
 @param finishBlock 重新授权后的回调,YES为授权成功,成功后底层将resend之前的请求 NO为授权失败
  
 @return YES为终止底层网络回调 NO为不终止底层网络回调
 */
- (BOOL)authorityErrorHandle:(void(^)(BOOL flag))finishBlock;

- (NSOperationQueue*)modelOperationQueue;

- (void)startTaskWithURL:(NSString *)url
              httpMethod:(NSString*)httpMethod
              parameters:(id)parameters // NSArray or NSDictionary
                 success:(GROWNetworkSuccessBlock)success
                 failure:(GROWNetworkFailureBlock)failure;

- (void)startTaskWithURL:(NSString *)url
              httpMethod:(NSString*)httpMethod
              parameters:(id)parameters // NSArray or NSDictionary
        timeoutInSeconds:(NSUInteger)timeout
                 success:(GROWNetworkSuccessBlock)success
                 failure:(GROWNetworkFailureBlock)failure;

- (void)startTaskWithURL:(NSString *)url
              httpMethod:(NSString*)httpMethod
              parameters:(id)parameters // NSArray or NSDictionary
            outsizeBlock:(void (^)(unsigned long long))outsizeBlock
           configRequest:(void(^)(NSMutableURLRequest* request))configRequest
          isSendingEvent:(BOOL)isSendingEvent
                     STM:(unsigned long long int)STM
        timeoutInSeconds:(NSUInteger)timeout
           isFromHTTPDNS:(BOOL)isFromHTTPDNS
                 success:(GROWNetworkSuccessBlock)success
                 failure:(GROWNetworkFailureBlock)failure;

@end
