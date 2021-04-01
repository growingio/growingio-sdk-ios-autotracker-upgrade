//
//  GrowingMenu.h
//  Growing
//
//  Created by 陈曦 on 15/11/6.
//  Copyright © 2015年 GrowingIO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrowingWindow.h"

@class GrowingMenuView;

typedef NS_ENUM(NSUInteger, GrowingMenuShowType)
{
    GrowingMenuShowTypeAlert,
    GrowingMenuShowTypePresent
};

@interface GrowingMenu : GrowingWindowView

+ (void)showMenuView:(GrowingMenuView*)view;
+ (void)showMenuView:(GrowingMenuView*)view showType:(GrowingMenuShowType)type;
+ (void)showMenuView:(GrowingMenuView*)view showType:(GrowingMenuShowType)type complate:(void(^)(void))complate;

+ (void)hideMenuView:(GrowingMenuView*)view;
+ (void)hideMenuView:(GrowingMenuView*)view showType:(GrowingMenuShowType)type;
+ (void)hideMenuView:(GrowingMenuView*)view showType:(GrowingMenuShowType)type complate:(void(^)(void))complate;;

+ (NSUInteger)showMenuCount;

+ (CGSize)maxSizeForType:(GrowingMenuShowType)type;

@end
