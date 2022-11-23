//
//  GrowingBaseModel.m
//  Growing
//
//  Created by 陈曦 on 15/10/27.
//  Copyright © 2015年 GrowingIO. All rights reserved.
//

#import "Upgrade-base/2x/GrowingBaseModel.h"

#import "GrowingTrackerCore/Helpers/NSDictionary+GrowingHelper.h"
#import "GrowingTrackerCore/Helpers/NSArray+GrowingHelper.h"
#import "GrowingTrackerCore/Helpers/NSData+GrowingHelper.h"
#import "GrowingTrackerCore/Thirdparty/Logger/GrowingLogger.h"
#import "GrowingULTimeUtil.h"

static NSMutableArray<NSMutableDictionary*> *allTypeInstance = nil;
static NSMutableDictionary *allAccountIdDict = nil;

@interface GrowingBaseModel()<NSURLSessionDelegate>
{
    NSOperationQueue *_queue;
}

@property (nonatomic, retain)  NSMutableURLRequest *request;

@end

@implementation GrowingBaseModel

- (NSOperationQueue*)modelOperationQueue
{
    if (!_queue)
    {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

+ (instancetype)shareInstanceWithType:(GrowingModelType)type
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allTypeInstance = [[NSMutableArray alloc] initWithCapacity:GrowingModelTypeCount];
        for (NSUInteger i = 0 ; i < GrowingModelTypeCount ; i ++)
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [allTypeInstance addObject:dict];
        }
    });
    
    NSMutableDictionary *dict = allTypeInstance[type];
    GrowingBaseModel *obj = nil;
    @synchronized (dict) {
        obj = [dict valueForKey:NSStringFromClass(self)];
        if (!obj)
        {
            obj = [[self alloc] init];
            obj ->_modelType = type;
            [dict setValue:obj forKey:NSStringFromClass(self)];
        }
    }
    return obj;
}

+ (instancetype)sdkInstance
{
    return [self shareInstanceWithType:GrowingModelTypeSDKCircle];
}

+ (instancetype)eventInstance
{
    return [self shareInstanceWithType:GrowingModelTypeEvent];
}

- (void)authorityVerification:(NSMutableURLRequest *)request
{
    // do nothing
}

- (BOOL)authorityErrorHandle:(void(^)(BOOL flag))finishBlock
{
    finishBlock = nil;
    return NO;
}

- (void)startTaskWithURL:(NSString *)url
              httpMethod:(NSString *)httpMethod
              parameters:(id)parameters // NSArray or NSDictionary
                 success:(GROWNetworkSuccessBlock)success
                 failure:(GROWNetworkFailureBlock)failure
{
    [self startTaskWithURL:url
                httpMethod:httpMethod
                parameters:parameters
              outsizeBlock:nil
             configRequest:nil
            isSendingEvent:NO
                       STM:0
          timeoutInSeconds:0
             isFromHTTPDNS:NO
                   success:success
                   failure:failure];
}

- (void)startTaskWithURL:(NSString *)url
              httpMethod:(NSString *)httpMethod
              parameters:(id)parameters // NSArray or NSDictionary
        timeoutInSeconds:(NSUInteger)timeout
                 success:(GROWNetworkSuccessBlock)success
                 failure:(GROWNetworkFailureBlock)failure
{
    [self startTaskWithURL:url
                httpMethod:httpMethod
                parameters:parameters
              outsizeBlock:nil
             configRequest:nil
            isSendingEvent:NO
                       STM:0
          timeoutInSeconds:timeout
             isFromHTTPDNS:NO
                   success:success
                   failure:failure];
}

- (void)startTaskWithURL:(NSString *)url
              httpMethod:(NSString *)httpMethod
              parameters:(id)parameters // NSArray or NSDictionary
            outsizeBlock:(void (^)(unsigned long long))outsizeBlock
           configRequest:(void (^)(NSMutableURLRequest *))configRequest
          isSendingEvent:(BOOL)isSendingEvent
                     STM:(unsigned long long int)STM
        timeoutInSeconds:(NSUInteger)timeout
           isFromHTTPDNS:(BOOL)isFromHTTPDNS
                 success:(GROWNetworkSuccessBlock)success
                 failure:(GROWNetworkFailureBlock)failure
{
    self.request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self.request setHTTPMethod:httpMethod];
    if (timeout > 0)
    {
        self.request.timeoutInterval = (NSTimeInterval)timeout;
    }

    if (configRequest != nil)
    {
        configRequest(self.request);
    }

    [self authorityVerification:self.request];
    
    [self.request addValue:@([GrowingULTimeUtil currentTimeMillis]).stringValue forHTTPHeaderField:@"X-Timestamp"];
    [self.request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSData *JSONData = nil;
    if (parameters)
    {
        JSONData = [parameters growingHelper_jsonData];
    }

    if (isSendingEvent)
    {
        JSONData = [JSONData growingHelper_LZ4String];

        JSONData = [JSONData growingHelper_xorEncryptWithHint:(STM & 0xFF)];
        [self.request addValue:@"3" forHTTPHeaderField:@"X-Compress-Codec"]; // 3 stands for iOS LZ4 compression
        [self.request addValue:@"1" forHTTPHeaderField:@"X-Crypt-Codec"]; // 1 stands for XOR encryption
        [self.request addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];

    }
    else if (JSONData.length > 0)
    {
        [self.request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }

    [self.request setHTTPBody:JSONData];
    
    if (outsizeBlock)
    {
        outsizeBlock(JSONData.length);
    }
    
    if (!success) success = ^( NSHTTPURLResponse *httpResponse , NSData *data ){};
    if (!failure) failure = ^( NSHTTPURLResponse *httpResponse , NSData *data, NSError *error ){};
    
    NSURLSession *session;
    
    // 判断是否是 HTTPDNS 解析出的 IP 作为 host, 如果是需要将原本的 host 放入 request 的 Header 中，会在下面 didReceiveChallenge 的 delegate 中取出
    if (!isFromHTTPDNS)
    {
        session = [NSURLSession sharedSession];
    }
    else
    {
        [self.request addValue:[GrowingNetworkConfig.sharedInstance growingApiHostEnd] forHTTPHeaderField:@"host"];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:configuration
                                                delegate:self
                                                     delegateQueue:self.modelOperationQueue];
    }
    
    NSURLSessionTask *task = [session dataTaskWithRequest:self.request
                                        completionHandler:^(NSData * _Nullable data,
                                                            NSURLResponse * _Nullable _response,
                                                            NSError * _Nullable connectionError) {
                               NSHTTPURLResponse *response = (id)_response;
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   if (connectionError) {
                                       GIOLogError(@"Request(%p) failed with connection error: %@", self.request, connectionError);
                                       failure(response,data,connectionError);
                                       return;
                                   }
                                   
                                   if (self.modelType != GrowingModelTypeEvent
                                       && response.statusCode == 403)
                                   {
                                       BOOL shouldReturn = [self authorityErrorHandle:^(BOOL flag) {
                                           if (flag) {
                                               [self startTaskWithURL:url
                                                           httpMethod:httpMethod
                                                           parameters:parameters
                                                         outsizeBlock:outsizeBlock
                                                        configRequest:configRequest
                                                       isSendingEvent:isSendingEvent
                                                                  STM:STM
                                                     timeoutInSeconds:timeout
                                                        isFromHTTPDNS:isFromHTTPDNS
                                                              success:success
                                                              failure:failure];
                                           } else {
                                               if (failure) {
                                                   failure(response,data,connectionError);
                                               }
                                           }
                                       }];
                                       
                                       if (shouldReturn) {
                                           return;
                                       }
                                   }
                                   
                                   
                                   if (response.statusCode != 200) {
                                       GIOLogError(@"Request(%p) failed with unexpected status code: %ld.", self.request, response.statusCode);
                                       failure(response,data,connectionError);
                                       return;
                                   }
                                   
                                   GIOLogDebug(@"Request(%p) succeeded: %ld.", self.request, response.statusCode);
                                   success(response, data);
                               });
                           }];
    GIOLogDebug(@"Request(%p) has been sent.", self.request);
    
    [task resume];
}

// 下面的代码源自 https://help.aliyun.com/document_detail/30143.html?spm=5176.doc30139.2.10.oVZJ7p，是阿里官方提供的用来解决因为使用 HTTPDNS 导致 "domain不匹配" 问题的解决方案
/*
 * NSURLSession
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{
    if (!challenge) {
        return;
    }
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
    /*
     * 获取原始域名信息。
     */
    NSString* host = [[self.request allHTTPHeaderFields] objectForKey:@"host"];
    if (!host) {
        host = self.request.URL.host;
    }
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([self evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:host]) {
            disposition = NSURLSessionAuthChallengeUseCredential;
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    // 对于其他的challenges直接使用默认的验证方案
    completionHandler(disposition,credential);
}

- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(NSString *)domain
{
    /*
     * 创建证书校验策略
     */
    NSMutableArray *policies = [NSMutableArray array];
    if (domain) {
        [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)domain)];
    } else {
        [policies addObject:(__bridge_transfer id)SecPolicyCreateBasicX509()];
    }
    /*
     * 绑定校验策略到服务端的证书上
     */
    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);
    /*
     * 评估当前serverTrust是否可信任，
     * 官方建议在result = kSecTrustResultUnspecified 或 kSecTrustResultProceed
     * 的情况下serverTrust可以被验证通过，https://developer.apple.com/library/ios/technotes/tn2232/_index.html
     * 关于SecTrustResultType的详细信息请参考SecTrust.h
     */
    SecTrustResultType result;
    SecTrustEvaluate(serverTrust, &result);
    return (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);

}

@end
