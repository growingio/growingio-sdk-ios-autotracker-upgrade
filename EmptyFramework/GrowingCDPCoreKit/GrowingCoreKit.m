//
//  GrowingCoreKit.m
//  GrowingCoreKit
//
//  Created by apple on 2018/5/14.
//  Copyright © 2018年 GrowingIO. All rights reserved.
//

#import "GrowingCoreKit.h"
#import <UIKit/UIWebView.h>
#import "GrowingAutotracker.h"
#import "GrowingConfigurationManager.h"
#import "GrowingSession.h"
#import "GrowingEventManager.h"
#import "GrowingHybridPageEvent.h"
#import "GrowingTimeUtil.h"
#import "GrowingLog.h"
#import "GrowingTTYLogger.h"
#import "GrowingArgumentChecker.h"
#import "GrowingEventGenerator.h"
#import "GrowingLogMacros.h"
#import "GrowingCocoaLumberjack.h"
#import "GrowingDispatchManager.h"
#import "GrowingPersistenceDataProvider.h"
#import "GrowingCdpEventInterceptor.h"
#import "NSString+GrowingHelper.h"
#import "GrowingUpgradeDispatcher.h"
#import "GrowingSession.h"
#import "GrowingViewControllerLifecycle.h"
#import "GrowingNotificationDelegateAutotracker.h"
#import "GrowingNotificationDelegateManager.h"
#import "GrowingEventManager.h"
#import "GrowingInstance.h"
#import "GrowingDeepLinkHandler.h"
#import "GrowingAppLifecycle.h"

#define GIOInvalidateMethod GIOLogError(@"%s在 SDK Version 3.0 以上已禁用",__FUNCTION__);

@implementation Growing

static NSString *growingBundleId = nil;

+ (void)setAspectMode:(GrowingAspectMode)aspectMode {
    [GrowingInstance setAspectMode:aspectMode];
}

+ (GrowingAspectMode)getAspectMode {
    return [GrowingInstance aspectMode];
}

+ (void)setBundleId:(NSString *)bundleId {
    growingBundleId = bundleId;
}

+ (NSString *)getBundleId {
    return growingBundleId;
}

static NSString *growingUrlScheme = nil;

+ (void)setUrlScheme:(NSString *)urlScheme {
    growingUrlScheme = urlScheme;
}

+ (NSString *)getUrlScheme {
    return growingUrlScheme;
}

+ (BOOL)handleUrl:(NSURL *)aUrl {
    GIOInvalidateMethod
    return 0;
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

+ (void)versionCheck {
    GIOInvalidateMethod
}

#pragma clang diagnostic pop

+ (BOOL)urlSchemeCheck {
    return YES;
}

static BOOL _enableLog;

+ (void)setEnableLog:(BOOL)enableLog {
    _enableLog = enableLog;
    if ([GrowingAutotracker sharedInstance]) {
        if (_enableLog) {
            [GrowingLog addLogger:[GrowingTTYLogger sharedInstance] withLevel:GrowingLogLevelDebug];
        } else {
            [GrowingLog removeLogger:[GrowingTTYLogger sharedInstance]];
            [GrowingLog addLogger:[GrowingTTYLogger sharedInstance] withLevel:GrowingLogLevelError];
        }
    }
}

+ (BOOL)getEnableLog {
    return _enableLog;
}

static NSString *kGrowingUserdefault_2xto3x = @"kGrowingUserdefault_2xto3x_cdp";

#define GROWINGIO_KEYCHAIN_KEY  @"GROWINGIO_KEYCHAIN_KEY"
#define GROWINGIO_CUSTOM_U_KEY  @"GROWINGIO_CUSTOM_U_KEY"

/// 需要在初始化前调用, 将userId以及deviceId从v2版本迁移到v3版本中
+ (void)upgrade {
    [GrowingNotificationDelegateAutotracker track];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[GrowingAppLifecycle sharedInstance] addAppLifecycleDelegate:[GrowingUpgradeDispatcher sharedInstance]];
        [[GrowingSession currentSession] addUserIdChangedDelegate:[GrowingUpgradeDispatcher sharedInstance]];
        [[GrowingViewControllerLifecycle sharedInstance] addViewControllerLifecycleDelegate:[GrowingUpgradeDispatcher sharedInstance]];
        [[GrowingNotificationDelegateManager sharedInstance] addNotificationDelegateObserver:[GrowingUpgradeDispatcher sharedInstance]];
        [[GrowingEventManager shareInstance] addInterceptor:[GrowingUpgradeDispatcher sharedInstance]];
        [[GrowingDeepLinkHandler sharedInstance] addHandlersObject:[GrowingUpgradeDispatcher sharedInstance]];
    });
    NSString *isUpgraded = [[GrowingPersistenceDataProvider sharedInstance] getStringforKey:kGrowingUserdefault_2xto3x];
    if (isUpgraded) {
        return;
    }
    NSString *dirPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"libGrowing-CDP"];
    NSString *filePath = [dirPath stringByAppendingPathComponent:@"D00C531B-CC47-48D4-A84A-FEAB505FDFD5.plist"];
    NSMutableDictionary * persistentData = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath]) {
        persistentData = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        if (!persistentData) {
            GIOLogError(@"未检查到SDK Version 2.x版本相关的UserId、deviceId数据");
            return;
        }
        //2.x的userId
        NSString* cs1 = [persistentData valueForKey:@"CS1"];
        //2.x的gioId
        NSString* gioId = [persistentData valueForKey:@"gioId"];
        if (cs1 && cs1.length > 0) {
            [[GrowingPersistenceDataProvider sharedInstance] setLoginUserId:cs1];
        }
        if (gioId && gioId.length > 0) {
            [[GrowingPersistenceDataProvider sharedInstance] setString:gioId forKey:kGrowingUserdefault_gioId];
        }
    }
    //如果用户自定
    NSString *custom = [self keyChainObjectForKey:GROWINGIO_CUSTOM_U_KEY];
    if (custom.growingHelper_isValidU) {
        [[GrowingPersistenceDataProvider sharedInstance] setDeviceId:custom];
    }else {
        NSString *keychain = [self keyChainObjectForKey:GROWINGIO_KEYCHAIN_KEY];
        if (keychain.growingHelper_isValidU) {
            [[GrowingPersistenceDataProvider sharedInstance] setDeviceId:keychain];
        }
    }
    [[GrowingPersistenceDataProvider sharedInstance] setString:@"1" forKey:kGrowingUserdefault_2xto3x];
}

// keychain
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)key {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    (id)kSecClassGenericPassword, (id)kSecClass,
                                             key, (id)kSecAttrService,
                                             key, (id)kSecAttrAccount,
      (id)kSecAttrAccessibleAlwaysThisDeviceOnly, (id)kSecAttrAccessible,
            nil];
}

+ (id)keyChainObjectForKey:(NSString *)key {
    id ret = nil;
    //线上版本 SecItemCopyMatching 出现偶现crash
    @try {
        NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
        //Configure the search setting
        //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
        [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
        [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
        CFDataRef keyData = NULL;
        if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        if (keyData)
            CFRelease(keyData);
    } @catch (NSException *exception) {
        GIOLogError(@"Get Keychain Data For Key :%@ Error: %@",key,exception);
    }
    return ret;
}

static BOOL _disablePushTrack = YES;

// 禁止采集push点击
+ (void)disablePushTrack:(BOOL)disable {
    GIOInvalidateMethod
}

+ (BOOL)getDisablePushTrack {
    GIOInvalidateMethod
    return NO;
}

+ (void)setEnableLocationTrack:(BOOL)enable; {
    GIOInvalidateMethod
}

+ (BOOL)getEnableLocationTrack {
    GIOInvalidateMethod
    return  NO;
}

+ (void)setEncryptStringBlock:(NSString *(^)(NSString *string))block {
    GIOInvalidateMethod
}

+ (void)setCS1Value:(nonnull NSString *)value {
    GIOInvalidateMethod
}

+ (void)disable {
    GIOInvalidateMethod
}

// 设置 GDPR 生效
+ (void)disableDataCollect {
    [GrowingConfigurationManager sharedInstance].trackConfiguration.dataCollectionEnabled = YES;
}

// 设置 GDPR 失效
+ (void)enableDataCollect {
    [GrowingConfigurationManager sharedInstance].trackConfiguration.dataCollectionEnabled = NO;
}

+ (void)setFlushInterval:(NSTimeInterval)interval {
    [GrowingConfigurationManager sharedInstance].trackConfiguration.dataUploadInterval = interval;
}

+ (NSTimeInterval)getFlushInterval {
    return [GrowingConfigurationManager sharedInstance].trackConfiguration.dataUploadInterval;
}

+ (void)setSessionInterval:(NSTimeInterval)interval {
    [GrowingConfigurationManager sharedInstance].trackConfiguration.sessionInterval = interval;
}

+ (NSTimeInterval)getSessionInterval {
    return [GrowingConfigurationManager sharedInstance].trackConfiguration.sessionInterval;
}

+ (void)setDailyDataLimit:(NSUInteger)numberOfKiloByte {
    [GrowingConfigurationManager sharedInstance].trackConfiguration.cellularDataLimit = numberOfKiloByte;
}

+ (NSUInteger)getDailyDataLimit {
    return  [GrowingConfigurationManager sharedInstance].trackConfiguration.cellularDataLimit;
}

+ (void)setTrackerHost:(NSString *)host {
    [GrowingConfigurationManager sharedInstance].trackConfiguration.dataCollectionServerHost = host;
}

+ (void)setDataHost:(NSString *)host {
    [GrowingConfigurationManager sharedInstance].trackConfiguration.dataCollectionServerHost = host;
}

+ (void)setAssetsHost:(NSString *)host {
    GIOInvalidateMethod
}

+ (void)setGtaHost:(NSString *)host {
    GIOInvalidateMethod
}

+ (void)setWsHost:(NSString *)host {
    GIOInvalidateMethod
}

+ (void)setReportHost:(NSString *)host {
    GIOInvalidateMethod
}

+ (void)setZone:(NSString *)zone {
    GIOInvalidateMethod
}

+ (void)setDeviceIDModeToCustomBlock:(NSString *(^)(void))customBlock {
    GIOInvalidateMethod
}

+ (NSString *)getDeviceId {
    return [[GrowingAutotracker sharedInstance] getDeviceId];
}

+ (NSString *)getVisitUserId {
    return [[GrowingAutotracker sharedInstance] getDeviceId];
}

+ (NSString *)getSessionId {
    return [[GrowingSession currentSession] sessionId];;
}

// 埋点相关
+ (void)setUserId:(NSString *)userId {
    [[GrowingAutotracker sharedInstance] setLoginUserId:userId];
}

+ (void)clearUserId {
    [[GrowingAutotracker sharedInstance] cleanLoginUserId];
}

+ (void)setEvar:(NSDictionary<NSString *, NSObject *> *)variable {
    variable = [self fit3xDictionary:variable];
    if ([GrowingArgumentChecker isIllegalAttributes:variable]) {
        return;
    }
    [GrowingEventGenerator generateConversionAttributesEvent:variable];
}

+ (void)setEvarWithKey:(NSString *)key andStringValue:(NSString *)stringValue {
    
    if ([GrowingArgumentChecker isIllegalEventName:key] || [GrowingArgumentChecker isIllegalEventName:stringValue]) {
        return;
    }
    [GrowingEventGenerator generateVisitorAttributesEvent:@{key: stringValue}];
}

+ (void)setEvarWithKey:(NSString *)key andNumberValue:(NSNumber *)numberValue {
    if ([GrowingArgumentChecker isIllegalEventName:key] || numberValue == nil) {
        return;
    }
    [GrowingEventGenerator generateVisitorAttributesEvent:@{key: numberValue}];
}

+ (void)setVisitor:(NSDictionary<NSString *, NSObject *> *)variable {
    variable = [self fit3xDictionary:variable];
    if ([GrowingArgumentChecker isIllegalAttributes:variable]) {
        return;
    }
    [GrowingEventGenerator generateVisitorAttributesEvent:variable];
}

+ (void)setPeopleVariable:(NSDictionary<NSString *, NSObject *> *)variable {
    variable = [self fit3xDictionary:variable];
    if ([GrowingArgumentChecker isIllegalAttributes:variable]) {
        return;
    }
    [GrowingEventGenerator generateLoginUserAttributesEvent:variable];
}

+ (void)setPeopleVariableWithKey:(NSString *)key andStringValue:(NSString *) stringValue{
    if ([GrowingArgumentChecker isIllegalEventName:key] || [GrowingArgumentChecker isIllegalEventName:stringValue]) {
        return;
    }
    [GrowingEventGenerator generateLoginUserAttributesEvent:@{key: stringValue}];
}

+ (void)setPeopleVariableWithKey:(NSString *)key andNumberValue:(NSNumber *)numberValue {
    if ([GrowingArgumentChecker isIllegalEventName:key] || numberValue == nil) {
        return;
    }
    [GrowingEventGenerator generateLoginUserAttributesEvent:@{key: numberValue}];
}

+ (void)track:(NSString *)eventId {
    [[GrowingAutotracker sharedInstance] trackCustomEvent:eventId];
}

+ (void)track:(NSString *)eventId withVariable:(NSDictionary<NSString *, NSObject *> *)variable {
    variable = [self fit3xDictionary:variable];
    [[GrowingAutotracker sharedInstance] trackCustomEvent:eventId withAttributes:variable];
}

+ (NSDictionary *)fit3xDictionary:(NSDictionary*)variable {
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:variable];
    for (NSString *key in variable.allKeys) {
        id obj = variable[key];
        if ([obj isKindOfClass:[NSNumber class]]) {
            NSString *value = ((NSNumber *)obj).stringValue;
            [mutDic setValue:value forKey:key];
        }
    }
    return mutDic;
}

+ (void)track:(NSString *)eventId
     withItem:(NSString *)itemId
      itemKey:(NSString *)itemKey {
    [[GrowingAutotracker sharedInstance] trackCustomEvent:eventId itemKey:itemKey itemId:itemId];
    
}

+ (void)track:(NSString *)eventId
 withVariable:(NSDictionary<NSString *, id> *)variable
      forItem:(NSString *)itemId
      itemKey:(NSString *)itemKey {
    [[GrowingAutotracker sharedInstance] trackCustomEvent:eventId itemKey:itemKey itemId:itemId withAttributes:variable];
}


+ (void)trackPage:(NSString *)pageName {
    [self trackPage:pageName withVariable:nil];
}

+ (void)trackPage:(NSString *)pageName withVariable:(NSDictionary<NSString *, id> *)variable {
    variable = [self fit3xDictionary:variable];
    NSString *newPageName;
    if (![pageName hasPrefix:@"/"]) {
        newPageName = [NSString stringWithFormat:@"/%@", pageName];
    } else {
        newPageName = pageName;
    }
    BOOL hasVariable = variable != nil;
    NSString *query = nil;
    if (hasVariable) {
        query = [NSString string];
        NSEnumerator *e = [variable keyEnumerator];
        NSString *key;
        while ((key = [e nextObject]) != nil) {
            NSString *value = variable[key];
            query = [NSString stringWithFormat:@"%@%@=%@&", query, key, value];
        }
        query = [query substringToIndex:([query length] - 1)];
    }
    
    [[GrowingEventManager shareInstance] postEventBuidler:GrowingHybridPageEvent.builder.setPath(pageName).setQuery(query).setTimestamp([GrowingTimeUtil currentTimeMillis])];
}

+ (void)setUserAttributes:(NSDictionary<NSString *, id> *)attributes {
    attributes = [self fit3xDictionary:attributes];
    [[GrowingAutotracker sharedInstance] setLoginUserAttributes:attributes];
}

+ (void)setUploadExceptionEnable:(BOOL)uploadExceptionEnable {
    [GrowingConfigurationManager sharedInstance].trackConfiguration.uploadExceptionEnable = uploadExceptionEnable;
}

+ (void)sendGrowingEBMonitorEventState:(int)state {
    GIOInvalidateMethod
}

+ (void)bridgeForWKWebView:(WKWebView *)webView {
    GIOInvalidateMethod
}

@end

