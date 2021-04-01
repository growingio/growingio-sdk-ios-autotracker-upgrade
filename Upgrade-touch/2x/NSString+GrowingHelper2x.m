//
// NSString+GrowingHelper2x.m
// GrowingAnalytics-upgrade-Autotracker-upgrade-2to3-Upgrade-base
//
//  Created by sheng on 2021/3/4.
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


#import "NSString+GrowingHelper2x.h"
#import "GrowingLogMacros.h"
#import "GrowingCocoaLumberjack.h"
#import "GrowingGlobal.h"
@implementation NSString (GrowingHelper2x)

//添加Log
- (BOOL)isValidKey{
    BOOL ret = [self isValidIdentifier];
    if (!ret) {
        GIOLogError(parameterKeyErrorLog);
    }
    return ret;
}

/**
 判断标志符是否有效
 文档：https://docs.google.com/document/d/1lpx1wzCktp0JJFbLUl4o357kvALYGKDQHbzFXgRhYT0/edit#
 
 @return 有效返回 YES，否则为NO
 */
- (BOOL)isValidIdentifier{
    //标识符不允许空字符串，不允许nil
    //标识符的长度限制在50个英文字符之内
    if (self.length == 0 || self.length > 50) {
        return NO;
    }
//    //标识符仅允许大小写英文、数字、下划线、以及英文冒号，并且不能以数字和冒号开头
//    static NSRegularExpression *idExp = nil;
//    if (!idExp) {
//        idExp = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z_][a-zA-Z0-9_:]*$" options:0 error:nil];
//    }
//    NSRange range = [idExp rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
//    if (range.location == 0 && range.length == self.length) {
//        return YES;
//    }
    return YES;
}

@end
