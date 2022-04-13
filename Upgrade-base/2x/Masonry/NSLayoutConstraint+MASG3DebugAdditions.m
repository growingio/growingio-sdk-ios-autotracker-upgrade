//
//  NSLayoutConstraint+MASG3DebugAdditions.m
//  Masonry
//
//  Created by Jonas Budelmann on 3/08/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "Upgrade-base/2x/Masonry/NSLayoutConstraint+MASG3DebugAdditions.h"
#import "Upgrade-base/2x/Masonry/MASG3Constraint.h"
#import "Upgrade-base/2x/Masonry/MASG3LayoutConstraint.h"

@implementation NSLayoutConstraint (MASG3DebugAdditions)

#pragma mark - description maps

+ (NSDictionary *)growingLayoutRelationDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
        descriptionMap = @{
            @(NSLayoutRelationEqual)                : @"==",
            @(NSLayoutRelationGreaterThanOrEqual)   : @">=",
            @(NSLayoutRelationLessThanOrEqual)      : @"<=",
        };
    });
    return descriptionMap;
}

+ (NSDictionary *)growingLayoutAttributeDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
        descriptionMap = @{
            @(NSLayoutAttributeTop)      : @"top",
            @(NSLayoutAttributeLeft)     : @"left",
            @(NSLayoutAttributeBottom)   : @"bottom",
            @(NSLayoutAttributeRight)    : @"right",
            @(NSLayoutAttributeLeading)  : @"leading",
            @(NSLayoutAttributeTrailing) : @"trailing",
            @(NSLayoutAttributeWidth)    : @"width",
            @(NSLayoutAttributeHeight)   : @"height",
            @(NSLayoutAttributeCenterX)  : @"centerX",
            @(NSLayoutAttributeCenterY)  : @"centerY",
            @(NSLayoutAttributeBaseline) : @"baseline",
            
#if TARGET_OS_IPHONE
            @(NSLayoutAttributeLeftMargin)           : @"leftMargin",
            @(NSLayoutAttributeRightMargin)          : @"rightMargin",
            @(NSLayoutAttributeTopMargin)            : @"topMargin",
            @(NSLayoutAttributeBottomMargin)         : @"bottomMargin",
            @(NSLayoutAttributeLeadingMargin)        : @"leadingMargin",
            @(NSLayoutAttributeTrailingMargin)       : @"trailingMargin",
            @(NSLayoutAttributeCenterXWithinMargins) : @"centerXWithinMargins",
            @(NSLayoutAttributeCenterYWithinMargins) : @"centerYWithinMargins",
#endif
            
        };
    
    });
    return descriptionMap;
}


+ (NSDictionary *)growingLayoutPriorityDescriptionsByValue {
    static dispatch_once_t once;
    static NSDictionary *descriptionMap;
    dispatch_once(&once, ^{
#if TARGET_OS_IPHONE
        descriptionMap = @{
            @(MASG3LayoutPriorityDefaultHigh)      : @"high",
            @(MASG3LayoutPriorityDefaultLow)       : @"low",
            @(MASG3LayoutPriorityDefaultMedium)    : @"medium",
            @(MASG3LayoutPriorityRequired)         : @"required",
            @(MASG3LayoutPriorityFittingSizeLevel) : @"fitting size",
        };
#elif TARGET_OS_MAC
        descriptionMap = @{
            @(MASG3LayoutPriorityDefaultHigh)                 : @"high",
            @(MASG3LayoutPriorityDragThatCanResizeWindow)     : @"drag can resize window",
            @(MASG3LayoutPriorityDefaultMedium)               : @"medium",
            @(MASG3LayoutPriorityWindowSizeStayPut)           : @"window size stay put",
            @(MASG3LayoutPriorityDragThatCannotResizeWindow)  : @"drag cannot resize window",
            @(MASG3LayoutPriorityDefaultLow)                  : @"low",
            @(MASG3LayoutPriorityFittingSizeCompression)      : @"fitting size",
            @(MASG3LayoutPriorityRequired)                    : @"required",
        };
#endif
    });
    return descriptionMap;
}

#pragma mark - description override

+ (NSString *)growingDescriptionForObject:(id)obj {
    if ([obj respondsToSelector:@selector(masG3_key)] && [obj masG3_key]) {
        return [NSString stringWithFormat:@"%@:%@", [obj class], [obj masG3_key]];
    }
    return [NSString stringWithFormat:@"%@:%p", [obj class], obj];
}

- (NSString *)description {
    NSMutableString *description = [[NSMutableString alloc] initWithString:@"<"];

    [description appendString:[self.class growingDescriptionForObject:self]];

    [description appendFormat:@" %@", [self.class growingDescriptionForObject:self.firstItem]];
    if (self.firstAttribute != NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@".%@", [self.class.growingLayoutAttributeDescriptionsByValue objectForKey:@(self.firstAttribute)]];
    }

    [description appendFormat:@" %@", [self.class.growingLayoutRelationDescriptionsByValue objectForKey:@(self.relation)]];

    if (self.secondItem) {
        [description appendFormat:@" %@", [self.class growingDescriptionForObject:self.secondItem]];
    }
    if (self.secondAttribute != NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@".%@", [self.class.growingLayoutAttributeDescriptionsByValue objectForKey:@(self.secondAttribute)]];
    }
    
    if (self.multiplier != 1) {
        [description appendFormat:@" * %g", self.multiplier];
    }
    
    if (self.secondAttribute == NSLayoutAttributeNotAnAttribute) {
        [description appendFormat:@" %g", self.constant];
    } else {
        if (self.constant) {
            [description appendFormat:@" %@ %g", (self.constant < 0 ? @"-" : @"+"), ABS(self.constant)];
        }
    }

    if (self.priority != MASG3LayoutPriorityRequired) {
        [description appendFormat:@" ^%@", [self.class.growingLayoutPriorityDescriptionsByValue objectForKey:@(self.priority)] ?: [NSNumber numberWithDouble:self.priority]];
    }

    [description appendString:@">"];
    return description;
}

@end
