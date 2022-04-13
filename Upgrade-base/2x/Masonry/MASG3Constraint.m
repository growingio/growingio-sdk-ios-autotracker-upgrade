//
//  MASG3Constraint.m
//  Masonry
//
//  Created by Nick Tymchenko on 1/20/14.
//

#import "Upgrade-base/2x/Masonry/MASG3Constraint.h"
#import "Upgrade-base/2x/Masonry/MASG3Constraint+Private.h"

#define MASG3MethodNotImplemented() \
    @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                                 userInfo:nil]

@implementation MASG3Constraint

#pragma mark - Init

- (id)init {
	NSAssert(![self isMemberOfClass:[MASG3Constraint class]], @"MASG3Constraint is an abstract class, you should not instantiate it directly.");
	return [super init];
}

#pragma mark - NSLayoutRelation proxies

- (MASG3Constraint * (^)(id))equalTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
    };
}

- (MASG3Constraint * (^)(id))masG3_equalTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
    };
}

- (MASG3Constraint * (^)(id))greaterThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationGreaterThanOrEqual);
    };
}

- (MASG3Constraint * (^)(id))masG3_greaterThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationGreaterThanOrEqual);
    };
}

- (MASG3Constraint * (^)(id))lessThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationLessThanOrEqual);
    };
}

- (MASG3Constraint * (^)(id))masG3_lessThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationLessThanOrEqual);
    };
}

#pragma mark - MASG3LayoutPriority proxies

- (MASG3Constraint * (^)(void))priorityLow {
    return ^id{
        self.priority(MASG3LayoutPriorityDefaultLow);
        return self;
    };
}

- (MASG3Constraint * (^)(void))priorityMedium {
    return ^id{
        self.priority(MASG3LayoutPriorityDefaultMedium);
        return self;
    };
}

- (MASG3Constraint * (^)(void))priorityHigh {
    return ^id{
        self.priority(MASG3LayoutPriorityDefaultHigh);
        return self;
    };
}

#pragma mark - NSLayoutConstraint constant proxies

- (MASG3Constraint * (^)(MASG3EdgeInsets))insets {
    return ^id(MASG3EdgeInsets insets){
        self.insets = insets;
        return self;
    };
}

- (MASG3Constraint * (^)(CGSize))sizeOffset {
    return ^id(CGSize offset) {
        self.sizeOffset = offset;
        return self;
    };
}

- (MASG3Constraint * (^)(CGPoint))centerOffset {
    return ^id(CGPoint offset) {
        self.centerOffset = offset;
        return self;
    };
}

- (MASG3Constraint * (^)(CGFloat))offset {
    return ^id(CGFloat offset){
        self.offset = offset;
        return self;
    };
}

- (MASG3Constraint * (^)(NSValue *value))valueOffset {
    return ^id(NSValue *offset) {
        NSAssert([offset isKindOfClass:NSValue.class], @"expected an NSValue offset, got: %@", offset);
        [self setLayoutConstantWithValue:offset];
        return self;
    };
}

- (MASG3Constraint * (^)(id offset))masG3_offset {
    // Will never be called due to macro
    return nil;
}

#pragma mark - NSLayoutConstraint constant setter

- (void)setLayoutConstantWithValue:(NSValue *)value {
    if ([value isKindOfClass:NSNumber.class]) {
        self.offset = [(NSNumber *)value doubleValue];
    } else if (strcmp(value.objCType, @encode(CGPoint)) == 0) {
        CGPoint point;
        [value getValue:&point];
        self.centerOffset = point;
    } else if (strcmp(value.objCType, @encode(CGSize)) == 0) {
        CGSize size;
        [value getValue:&size];
        self.sizeOffset = size;
    } else if (strcmp(value.objCType, @encode(MASG3EdgeInsets)) == 0) {
        MASG3EdgeInsets insets;
        [value getValue:&insets];
        self.insets = insets;
    } else {
        NSAssert(NO, @"attempting to set layout constant with unsupported value: %@", value);
    }
}

#pragma mark - Semantic properties

- (MASG3Constraint *)with {
    return self;
}

- (MASG3Constraint *)and {
    return self;
}

#pragma mark - Chaining

- (MASG3Constraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute __unused)layoutAttribute {
    MASG3MethodNotImplemented();
}

- (MASG3Constraint *)left {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
}

- (MASG3Constraint *)top {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop];
}

- (MASG3Constraint *)right {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRight];
}

- (MASG3Constraint *)bottom {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottom];
}

- (MASG3Constraint *)leading {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeading];
}

- (MASG3Constraint *)trailing {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailing];
}

- (MASG3Constraint *)width {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeWidth];
}

- (MASG3Constraint *)height {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeHeight];
}

- (MASG3Constraint *)centerX {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];
}

- (MASG3Constraint *)centerY {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];
}

- (MASG3Constraint *)baseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBaseline];
}

#if TARGET_OS_IPHONE

- (MASG3Constraint *)leftMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeftMargin];
}

- (MASG3Constraint *)rightMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRightMargin];
}

- (MASG3Constraint *)topMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTopMargin];
}

- (MASG3Constraint *)bottomMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottomMargin];
}

- (MASG3Constraint *)leadingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (MASG3Constraint *)trailingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (MASG3Constraint *)centerXWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (MASG3Constraint *)centerYWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif

#pragma mark - Abstract

- (MASG3Constraint * (^)(CGFloat multiplier))multipliedBy { MASG3MethodNotImplemented(); }

- (MASG3Constraint * (^)(CGFloat divider))dividedBy { MASG3MethodNotImplemented(); }

- (MASG3Constraint * (^)(MASG3LayoutPriority priority))priority { MASG3MethodNotImplemented(); }

- (MASG3Constraint * (^)(id, NSLayoutRelation))equalToWithRelation { MASG3MethodNotImplemented(); }

- (MASG3Constraint * (^)(id key))key { MASG3MethodNotImplemented(); }

- (void)setInsets:(MASG3EdgeInsets __unused)insets { MASG3MethodNotImplemented(); }

- (void)setSizeOffset:(CGSize __unused)sizeOffset { MASG3MethodNotImplemented(); }

- (void)setCenterOffset:(CGPoint __unused)centerOffset { MASG3MethodNotImplemented(); }

- (void)setOffset:(CGFloat __unused)offset { MASG3MethodNotImplemented(); }

#if TARGET_OS_MAC && !TARGET_OS_IPHONE

- (MASG3Constraint *)animator { MASG3MethodNotImplemented(); }

#endif

- (void)activate { MASG3MethodNotImplemented(); }

- (void)deactivate { MASG3MethodNotImplemented(); }

- (void)install { MASG3MethodNotImplemented(); }

- (void)uninstall { MASG3MethodNotImplemented(); }

@end
