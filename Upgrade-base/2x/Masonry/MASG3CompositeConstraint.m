//
//  MASG3CompositeConstraint.m
//  Masonry
//
//  Created by Jonas Budelmann on 21/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "MASG3CompositeConstraint.h"
#import "MASG3Constraint+Private.h"

@interface MASG3CompositeConstraint () <MASG3ConstraintDelegate>

@property (nonatomic, strong) id masG3_key;
@property (nonatomic, strong) NSMutableArray *childConstraints;

@end

@implementation MASG3CompositeConstraint

- (id)initWithChildren:(NSArray *)children {
    self = [super init];
    if (!self) return nil;

    _childConstraints = [children mutableCopy];
    for (MASG3Constraint *constraint in _childConstraints) {
        constraint.delegate = self;
    }

    return self;
}

#pragma mark - MASG3ConstraintDelegate

- (void)constraint:(MASG3Constraint *)constraint shouldBeReplacedWithConstraint:(MASG3Constraint *)replacementConstraint {
    NSUInteger index = [self.childConstraints indexOfObject:constraint];
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.childConstraints replaceObjectAtIndex:index withObject:replacementConstraint];
}

- (MASG3Constraint *)constraint:(MASG3Constraint __unused *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    id<MASG3ConstraintDelegate> strongDelegate = self.delegate;
    MASG3Constraint *newConstraint = [strongDelegate constraint:self addConstraintWithLayoutAttribute:layoutAttribute];
    newConstraint.delegate = self;
    [self.childConstraints addObject:newConstraint];
    return newConstraint;
}

#pragma mark - NSLayoutConstraint multiplier proxies 

- (MASG3Constraint * (^)(CGFloat))multipliedBy {
    return ^id(CGFloat multiplier) {
        for (MASG3Constraint *constraint in self.childConstraints) {
            constraint.multipliedBy(multiplier);
        }
        return self;
    };
}

- (MASG3Constraint * (^)(CGFloat))dividedBy {
    return ^id(CGFloat divider) {
        for (MASG3Constraint *constraint in self.childConstraints) {
            constraint.dividedBy(divider);
        }
        return self;
    };
}

#pragma mark - MASG3LayoutPriority proxy

- (MASG3Constraint * (^)(MASG3LayoutPriority))priority {
    return ^id(MASG3LayoutPriority priority) {
        for (MASG3Constraint *constraint in self.childConstraints) {
            constraint.priority(priority);
        }
        return self;
    };
}

#pragma mark - NSLayoutRelation proxy

- (MASG3Constraint * (^)(id, NSLayoutRelation))equalToWithRelation {
    return ^id(id attr, NSLayoutRelation relation) {
        for (MASG3Constraint *constraint in self.childConstraints.copy) {
            constraint.equalToWithRelation(attr, relation);
        }
        return self;
    };
}

#pragma mark - attribute chaining

- (MASG3Constraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    [self constraint:self addConstraintWithLayoutAttribute:layoutAttribute];
    return self;
}

#pragma mark - Animator proxy

#if TARGET_OS_MAC && !TARGET_OS_IPHONE

- (MASG3Constraint *)animator {
    for (MASG3Constraint *constraint in self.childConstraints) {
        [constraint animator];
    }
    return self;
}

#endif

#pragma mark - debug helpers

- (MASG3Constraint * (^)(id))key {
    return ^id(id key) {
        self.masG3_key = key;
        int i = 0;
        for (MASG3Constraint *constraint in self.childConstraints) {
            constraint.key([NSString stringWithFormat:@"%@[%d]", key, i++]);
        }
        return self;
    };
}

#pragma mark - NSLayoutConstraint constant setters

- (void)setInsets:(MASG3EdgeInsets)insets {
    for (MASG3Constraint *constraint in self.childConstraints) {
        constraint.insets = insets;
    }
}

- (void)setOffset:(CGFloat)offset {
    for (MASG3Constraint *constraint in self.childConstraints) {
        constraint.offset = offset;
    }
}

- (void)setSizeOffset:(CGSize)sizeOffset {
    for (MASG3Constraint *constraint in self.childConstraints) {
        constraint.sizeOffset = sizeOffset;
    }
}

- (void)setCenterOffset:(CGPoint)centerOffset {
    for (MASG3Constraint *constraint in self.childConstraints) {
        constraint.centerOffset = centerOffset;
    }
}

#pragma mark - MASG3Constraint

- (void)activate {
    for (MASG3Constraint *constraint in self.childConstraints) {
        [constraint activate];
    }
}

- (void)deactivate {
    for (MASG3Constraint *constraint in self.childConstraints) {
        [constraint deactivate];
    }
}

- (void)install {
    for (MASG3Constraint *constraint in self.childConstraints) {
        constraint.updateExisting = self.updateExisting;
        [constraint install];
    }
}

- (void)uninstall {
    for (MASG3Constraint *constraint in self.childConstraints) {
        [constraint uninstall];
    }
}

@end
