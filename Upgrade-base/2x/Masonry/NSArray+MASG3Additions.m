//
//  NSArray+MASG3Additions.m
//  
//
//  Created by Daniel Hammond on 11/26/13.
//
//

#import "Upgrade-base/2x/Masonry/NSArray+MASG3Additions.h"
#import "Upgrade-base/2x/Masonry/View+MASG3Additions.h"

@implementation NSArray (MASG3Additions)

- (NSArray *)masG3_makeConstraints:(void(^)(MASG3ConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (MASG3_VIEW *view in self) {
        NSAssert([view isKindOfClass:[MASG3_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view masG3_makeConstraints:block]];
    }
    return constraints;
}

- (NSArray *)masG3_updateConstraints:(void(^)(MASG3ConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (MASG3_VIEW *view in self) {
        NSAssert([view isKindOfClass:[MASG3_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view masG3_updateConstraints:block]];
    }
    return constraints;
}

- (NSArray *)masG3_remakeConstraints:(void(^)(MASG3ConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (MASG3_VIEW *view in self) {
        NSAssert([view isKindOfClass:[MASG3_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view masG3_remakeConstraints:block]];
    }
    return constraints;
}

- (void)masG3_distributeViewsAlongAxis:(MASG3AxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    MASG3_VIEW *tempSuperView = [self masG3_commonSuperviewOfViews];
    if (axisType == MASG3AxisTypeHorizontal) {
        MASG3_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            MASG3_VIEW *v = [self objectAtIndex:i];
            [v masG3_makeConstraints:^(MASG3ConstraintMaker *make) {
                if (prev) {
                    make.width.equalTo(prev);
                    make.left.equalTo(prev.masG3_right).offset(fixedSpacing);
                    if (i == (CGFloat)self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
    else {
        MASG3_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            MASG3_VIEW *v = [self objectAtIndex:i];
            [v masG3_makeConstraints:^(MASG3ConstraintMaker *make) {
                if (prev) {
                    make.height.equalTo(prev);
                    make.top.equalTo(prev.masG3_bottom).offset(fixedSpacing);
                    if (i == (CGFloat)self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }                    
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
}

- (void)masG3_distributeViewsAlongAxis:(MASG3AxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    MASG3_VIEW *tempSuperView = [self masG3_commonSuperviewOfViews];
    if (axisType == MASG3AxisTypeHorizontal) {
        MASG3_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            MASG3_VIEW *v = [self objectAtIndex:i];
            [v masG3_makeConstraints:^(MASG3ConstraintMaker *make) {
                if (prev) {
                    CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                    make.width.equalTo(@(fixedItemLength));
                    if (i == (CGFloat)self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        make.right.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                    make.width.equalTo(@(fixedItemLength));
                }
            }];
            prev = v;
        }
    }
    else {
        MASG3_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            MASG3_VIEW *v = [self objectAtIndex:i];
            [v masG3_makeConstraints:^(MASG3ConstraintMaker *make) {
                if (prev) {
                    CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                    make.height.equalTo(@(fixedItemLength));
                    if (i == (CGFloat)self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        make.bottom.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                    make.height.equalTo(@(fixedItemLength));
                }
            }];
            prev = v;
        }
    }
}

- (MASG3_VIEW *)masG3_commonSuperviewOfViews
{
    MASG3_VIEW *commonSuperview = nil;
    MASG3_VIEW *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[MASG3_VIEW class]]) {
            MASG3_VIEW *view = (MASG3_VIEW *)object;
            if (previousView) {
                commonSuperview = [view masG3_closestCommonSuperview:commonSuperview];
            } else {
                commonSuperview = view;
            }
            previousView = view;
        }
    }
    NSAssert(commonSuperview, @"Can't constrain views that do not share a common superview. Make sure that all the views in this array have been added into the same view hierarchy.");
    return commonSuperview;
}

@end
