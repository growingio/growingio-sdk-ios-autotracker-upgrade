//
//  MASG3ConstraintBuilder.m
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "MASG3ConstraintMaker.h"
#import "MASG3ViewConstraint.h"
#import "MASG3CompositeConstraint.h"
#import "MASG3Constraint+Private.h"
#import "MASG3ViewAttribute.h"
#import "View+MASG3Additions.h"

@interface MASG3ConstraintMaker () <MASG3ConstraintDelegate>

@property (nonatomic, weak) MASG3_VIEW *view;
@property (nonatomic, strong) NSMutableArray *constraints;

@end

@implementation MASG3ConstraintMaker

- (id)initWithView:(MASG3_VIEW *)view {
    self = [super init];
    if (!self) return nil;
    
    self.view = view;
    self.constraints = NSMutableArray.new;
    
    return self;
}

- (NSArray *)install {
    if (self.removeExisting) {
        NSArray *installedConstraints = [MASG3ViewConstraint installedConstraintsForView:self.view];
        for (MASG3Constraint *constraint in installedConstraints) {
            [constraint uninstall];
        }
    }
    NSArray *constraints = self.constraints.copy;
    for (MASG3Constraint *constraint in constraints) {
        constraint.updateExisting = self.updateExisting;
        [constraint install];
    }
    [self.constraints removeAllObjects];
    return constraints;
}

#pragma mark - MASG3ConstraintDelegate

- (void)constraint:(MASG3Constraint *)constraint shouldBeReplacedWithConstraint:(MASG3Constraint *)replacementConstraint {
    NSUInteger index = [self.constraints indexOfObject:constraint];
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.constraints replaceObjectAtIndex:index withObject:replacementConstraint];
}

- (MASG3Constraint *)constraint:(MASG3Constraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    MASG3ViewAttribute *viewAttribute = [[MASG3ViewAttribute alloc] initWithView:self.view layoutAttribute:layoutAttribute];
    MASG3ViewConstraint *newConstraint = [[MASG3ViewConstraint alloc] initWithFirstViewAttribute:viewAttribute];
    if ([constraint isKindOfClass:MASG3ViewConstraint.class]) {
        //replace with composite constraint
        NSArray *children = @[constraint, newConstraint];
        MASG3CompositeConstraint *compositeConstraint = [[MASG3CompositeConstraint alloc] initWithChildren:children];
        compositeConstraint.delegate = self;
        [self constraint:constraint shouldBeReplacedWithConstraint:compositeConstraint];
        return compositeConstraint;
    }
    if (!constraint) {
        newConstraint.delegate = self;
        [self.constraints addObject:newConstraint];
    }
    return newConstraint;
}

- (MASG3Constraint *)addConstraintWithAttributes:(MASG3Attribute)attrs {
    __unused MASG3Attribute anyAttribute = (MASG3AttributeLeft | MASG3AttributeRight | MASG3AttributeTop | MASG3AttributeBottom | MASG3AttributeLeading
                                          | MASG3AttributeTrailing | MASG3AttributeWidth | MASG3AttributeHeight | MASG3AttributeCenterX
                                          | MASG3AttributeCenterY | MASG3AttributeBaseline
#if TARGET_OS_IPHONE
                                          | MASG3AttributeLeftMargin | MASG3AttributeRightMargin | MASG3AttributeTopMargin | MASG3AttributeBottomMargin
                                          | MASG3AttributeLeadingMargin | MASG3AttributeTrailingMargin | MASG3AttributeCenterXWithinMargins
                                          | MASG3AttributeCenterYWithinMargins
#endif
                                          );
    
    NSAssert((attrs & anyAttribute) != 0, @"You didn't pass any attribute to make.attributes(...)");
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    if (attrs & MASG3AttributeLeft) [attributes addObject:self.view.masG3_left];
    if (attrs & MASG3AttributeRight) [attributes addObject:self.view.masG3_right];
    if (attrs & MASG3AttributeTop) [attributes addObject:self.view.masG3_top];
    if (attrs & MASG3AttributeBottom) [attributes addObject:self.view.masG3_bottom];
    if (attrs & MASG3AttributeLeading) [attributes addObject:self.view.masG3_leading];
    if (attrs & MASG3AttributeTrailing) [attributes addObject:self.view.masG3_trailing];
    if (attrs & MASG3AttributeWidth) [attributes addObject:self.view.masG3_width];
    if (attrs & MASG3AttributeHeight) [attributes addObject:self.view.masG3_height];
    if (attrs & MASG3AttributeCenterX) [attributes addObject:self.view.masG3_centerX];
    if (attrs & MASG3AttributeCenterY) [attributes addObject:self.view.masG3_centerY];
    if (attrs & MASG3AttributeBaseline) [attributes addObject:self.view.masG3_baseline];
    
#if TARGET_OS_IPHONE
    
    if (attrs & MASG3AttributeLeftMargin) [attributes addObject:self.view.masG3_leftMargin];
    if (attrs & MASG3AttributeRightMargin) [attributes addObject:self.view.masG3_rightMargin];
    if (attrs & MASG3AttributeTopMargin) [attributes addObject:self.view.masG3_topMargin];
    if (attrs & MASG3AttributeBottomMargin) [attributes addObject:self.view.masG3_bottomMargin];
    if (attrs & MASG3AttributeLeadingMargin) [attributes addObject:self.view.masG3_leadingMargin];
    if (attrs & MASG3AttributeTrailingMargin) [attributes addObject:self.view.masG3_trailingMargin];
    if (attrs & MASG3AttributeCenterXWithinMargins) [attributes addObject:self.view.masG3_centerXWithinMargins];
    if (attrs & MASG3AttributeCenterYWithinMargins) [attributes addObject:self.view.masG3_centerYWithinMargins];
    
#endif
    
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:attributes.count];
    
    for (MASG3ViewAttribute *a in attributes) {
        [children addObject:[[MASG3ViewConstraint alloc] initWithFirstViewAttribute:a]];
    }
    
    MASG3CompositeConstraint *constraint = [[MASG3CompositeConstraint alloc] initWithChildren:children];
    constraint.delegate = self;
    [self.constraints addObject:constraint];
    return constraint;
}

#pragma mark - standard Attributes

- (MASG3Constraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    return [self constraint:nil addConstraintWithLayoutAttribute:layoutAttribute];
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

- (MASG3Constraint *(^)(MASG3Attribute))attributes {
    return ^(MASG3Attribute attrs){
        return [self addConstraintWithAttributes:attrs];
    };
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


#pragma mark - composite Attributes

- (MASG3Constraint *)edges {
    return [self addConstraintWithAttributes:MASG3AttributeTop | MASG3AttributeLeft | MASG3AttributeRight | MASG3AttributeBottom];
}

- (MASG3Constraint *)size {
    return [self addConstraintWithAttributes:MASG3AttributeWidth | MASG3AttributeHeight];
}

- (MASG3Constraint *)center {
    return [self addConstraintWithAttributes:MASG3AttributeCenterX | MASG3AttributeCenterY];
}

#pragma mark - grouping

- (MASG3Constraint *(^)(dispatch_block_t group))group {
    return ^id(dispatch_block_t group) {
        NSInteger previousCount = self.constraints.count;
        group();

        NSArray *children = [self.constraints subarrayWithRange:NSMakeRange(previousCount, self.constraints.count - previousCount)];
        MASG3CompositeConstraint *constraint = [[MASG3CompositeConstraint alloc] initWithChildren:children];
        constraint.delegate = self;
        return constraint;
    };
}

@end
