//
//  GrowingUIConfig.h
//  Growing
//
//  Created by 陈曦 on 15/11/7.
//  Copyright © 2015年 GrowingIO. All rights reserved.
//

#import "Upgrade-base/2x/GrowingUIHeader.h"

#define C_R_G_B_A(r,g,b,a)  [UIColor colorWithRed:r / 255.0f green:g / 255.0 blue:b / 255.0 alpha:a]
#define C_R_G_B(r,g,b)      C_R_G_B_A(r,g,b,1)

@interface GrowingUIConfig : NSObject

+ (UIColor*)circleListMainColor;
+ (UIColor*)circleColor;
+ (UIColor*)circleLightColor;

+ (UIColor*)circlErrorItemBackgroundColor;
+ (UIColor*)circlErrorItemBorderColor;

+ (UIColor*)circlingItemBackgroundColor;
+ (UIColor*)circlingItemBorderColor;

+ (UIColor*)circledItemBackgroundColor;
+ (UIColor*)circledItemBorderColor;

+ (UIColor*)mainColor;
+ (UIColor*)blueColor;
+ (UIColor*)redColor;
+ (UIColor*)placeHolderColor;
+ (UIColor*)textColor;
+ (UIColor*)textColorDisabled;
+ (UIColor*)secondTitleColor;
+ (UIColor*)highLightColor;
+ (UIColor*)sublineColor;
+ (UIColor*)grayBgColor;
+ (UIColor*)titleColor;
+ (UIColor*)titleColorDisabled;
+ (NSUInteger)textBigFontSize;
+ (NSUInteger)textSmallFontSize;
+ (NSUInteger)textTinyFontSize;
+ (UIColor*)textBigFontColor;
+ (UIColor*)textSmallFontColor;
+ (UIColor*)textTinyFontColor;
+ (UIColor*)radioOnColor;
+ (UIColor*)radioOffColor;
+ (UIColor*)separatorLineColor;
+ (UIColor*)eventListTextColor;
+ (UIColor*)eventListBgColor;

+ (UIColor*)colorWithHex:(unsigned int)colorHex;


@end

@interface UIColor(growingBlendColor)

- (UIColor*)colorWithAlpha:(CGFloat)alpha backgroundColor:(UIColor*)bgColor;

@end







