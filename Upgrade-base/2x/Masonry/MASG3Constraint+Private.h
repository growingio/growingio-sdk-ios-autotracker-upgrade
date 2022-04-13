//
//  MASG3Constraint+Private.h
//  Masonry
//
//  Created by Nick Tymchenko on 29/04/14.
//  Copyright (c) 2014 cloudling. All rights reserved.
//

#import "Upgrade-base/2x/Masonry/MASG3Constraint.h"

@protocol MASG3ConstraintDelegate;


@interface MASG3Constraint ()

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL updateExisting;

/**
 *	Usually MASG3ConstraintMaker but could be a parent MASG3Constraint
 */
@property (nonatomic, weak) id<MASG3ConstraintDelegate> delegate;

/**
 *  Based on a provided value type, is equal to calling:
 *  NSNumber - setOffset:
 *  NSValue with CGPoint - setPointOffset:
 *  NSValue with CGSize - setSizeOffset:
 *  NSValue with MASG3EdgeInsets - setInsets:
 */
- (void)setLayoutConstantWithValue:(NSValue *)value;

@end


@interface MASG3Constraint (Abstract)

/**
 *	Sets the constraint relation to given NSLayoutRelation
 *  returns a block which accepts one of the following:
 *    MASG3ViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (MASG3Constraint * (^)(id, NSLayoutRelation))equalToWithRelation;

/**
 *	Override to set a custom chaining behaviour
 */
- (MASG3Constraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute;

@end


@protocol MASG3ConstraintDelegate <NSObject>

/**
 *	Notifies the delegate when the constraint needs to be replaced with another constraint. For example
 *  A MASG3ViewConstraint may turn into a MASG3CompositeConstraint when an array is passed to one of the equality blocks
 */
- (void)constraint:(MASG3Constraint *)constraint shouldBeReplacedWithConstraint:(MASG3Constraint *)replacementConstraint;

- (MASG3Constraint *)constraint:(MASG3Constraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute;

@end
