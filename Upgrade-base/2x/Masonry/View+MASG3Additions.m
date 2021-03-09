//
//  UIView+MASG3Additions.m
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "View+MASG3Additions.h"
#import <objc/runtime.h>

@implementation MASG3_VIEW (MASG3Additions)

- (NSArray *)masG3_makeConstraints:(void(^)(MASG3ConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    MASG3ConstraintMaker *constraintMaker = [[MASG3ConstraintMaker alloc] initWithView:self];
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)masG3_updateConstraints:(void(^)(MASG3ConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    MASG3ConstraintMaker *constraintMaker = [[MASG3ConstraintMaker alloc] initWithView:self];
    constraintMaker.updateExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)masG3_remakeConstraints:(void(^)(MASG3ConstraintMaker *make))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    MASG3ConstraintMaker *constraintMaker = [[MASG3ConstraintMaker alloc] initWithView:self];
    constraintMaker.removeExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

#pragma mark - NSLayoutAttribute properties

- (MASG3ViewAttribute *)masG3_left {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeft];
}

- (MASG3ViewAttribute *)masG3_top {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTop];
}

- (MASG3ViewAttribute *)masG3_right {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRight];
}

- (MASG3ViewAttribute *)masG3_bottom {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottom];
}

- (MASG3ViewAttribute *)masG3_leading {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeading];
}

- (MASG3ViewAttribute *)masG3_trailing {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailing];
}

- (MASG3ViewAttribute *)masG3_width {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeWidth];
}

- (MASG3ViewAttribute *)masG3_height {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeHeight];
}

- (MASG3ViewAttribute *)masG3_centerX {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterX];
}

- (MASG3ViewAttribute *)masG3_centerY {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterY];
}

- (MASG3ViewAttribute *)masG3_baseline {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBaseline];
}

- (MASG3ViewAttribute *(^)(NSLayoutAttribute))masG3_attribute
{
    return ^(NSLayoutAttribute attr) {
        return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:attr];
    };
}

#if TARGET_OS_IPHONE

- (MASG3ViewAttribute *)masG3_leftMargin {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeftMargin];
}

- (MASG3ViewAttribute *)masG3_rightMargin {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRightMargin];
}

- (MASG3ViewAttribute *)masG3_topMargin {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTopMargin];
}

- (MASG3ViewAttribute *)masG3_bottomMargin {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottomMargin];
}

- (MASG3ViewAttribute *)masG3_leadingMargin {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (MASG3ViewAttribute *)masG3_trailingMargin {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (MASG3ViewAttribute *)masG3_centerXWithinMargins {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (MASG3ViewAttribute *)masG3_centerYWithinMargins {
    return [[MASG3ViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif

#pragma mark - associated properties

- (id)masG3_key {
    return objc_getAssociatedObject(self, @selector(masG3_key));
}

- (void)setMasG3_key:(id)key {
    objc_setAssociatedObject(self, @selector(masG3_key), key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - heirachy

- (instancetype)masG3_closestCommonSuperview:(MASG3_VIEW *)view {
    MASG3_VIEW *closestCommonSuperview = nil;

    MASG3_VIEW *secondViewSuperview = view;
    while (!closestCommonSuperview && secondViewSuperview) {
        MASG3_VIEW *firstViewSuperview = self;
        while (!closestCommonSuperview && firstViewSuperview) {
            if (secondViewSuperview == firstViewSuperview) {
                closestCommonSuperview = secondViewSuperview;
            }
            firstViewSuperview = firstViewSuperview.superview;
        }
        secondViewSuperview = secondViewSuperview.superview;
    }
    return closestCommonSuperview;
}

@end
