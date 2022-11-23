//
// GrowingUserDefaults.m
// GrowingAnalytics-upgrade
//
//  Created by YoloMao on 2022/11/23.
//  Copyright (C) 2017 Beijing Yishu Technology Co., Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "GrowingUserDefaults.h"

@interface GrowingUserDefaults()

@property (nonatomic, strong) NSUserDefaults *ud;

@end

@implementation GrowingUserDefaults

- (instancetype)init {
    if (self = [super init]) {
        _ud = [[NSUserDefaults alloc] initWithSuiteName:@"growingio.upgrade.userdefault"];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static GrowingUserDefaults *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)setValue:(nullable id)value forKey:(NSString *)key {
    [self.ud setObject:value forKey:key];
}

- (NSString *)valueForKey:(NSString *)key {
    return [self.ud stringForKey:key];
}

@end
