//
//  UITextFiled+GrowingHelper.m
//  Growing
//
//  Created by 陈曦 on 15/11/13.
//  Copyright © 2015年 GrowingIO. All rights reserved.
//

#import "Upgrade-base/2x/UITextField+GrowingHelper.h"

@implementation GrowingHelperTextField


- (CGRect)rectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + self.edgeInset.left,
                      bounds.origin.y + self.edgeInset.top,
                      bounds.size.width - self.edgeInset.left - self.edgeInset.right,
                      bounds.size.height - self.edgeInset.top - self.edgeInset.bottom);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return [self rectForBounds:bounds];
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return [self rectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self rectForBounds:bounds];
}

@end

