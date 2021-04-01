//
//  MASG3Constraint.h
//  Masonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "MASG3Utilities.h"

/**
 *	Enables Constraints to be created with chainable syntax
 *  Constraint can represent single NSLayoutConstraint (MASG3ViewConstraint) 
 *  or a group of NSLayoutConstraints (MASG3ComposisteConstraint)
 */
@interface MASG3Constraint : NSObject

// Chaining Support

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects MASG3Constraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (MASG3Constraint * (^)(MASG3EdgeInsets insets))insets;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects MASG3Constraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeWidth, NSLayoutAttributeHeight
 */
- (MASG3Constraint * (^)(CGSize offset))sizeOffset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects MASG3Constraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeCenterX, NSLayoutAttributeCenterY
 */
- (MASG3Constraint * (^)(CGPoint offset))centerOffset;

/**
 *	Modifies the NSLayoutConstraint constant
 */
- (MASG3Constraint * (^)(CGFloat offset))offset;

/**
 *  Modifies the NSLayoutConstraint constant based on a value type
 */
- (MASG3Constraint * (^)(NSValue *value))valueOffset;

/**
 *	Sets the NSLayoutConstraint multiplier property
 */
- (MASG3Constraint * (^)(CGFloat multiplier))multipliedBy;

/**
 *	Sets the NSLayoutConstraint multiplier to 1.0/dividedBy
 */
- (MASG3Constraint * (^)(CGFloat divider))dividedBy;

/**
 *	Sets the NSLayoutConstraint priority to a float or MASG3LayoutPriority
 */
- (MASG3Constraint * (^)(MASG3LayoutPriority priority))priority;

/**
 *	Sets the NSLayoutConstraint priority to MASG3LayoutPriorityLow
 */
- (MASG3Constraint * (^)(void))priorityLow;

/**
 *	Sets the NSLayoutConstraint priority to MASG3LayoutPriorityMedium
 */
- (MASG3Constraint * (^)(void))priorityMedium;

/**
 *	Sets the NSLayoutConstraint priority to MASG3LayoutPriorityHigh
 */
- (MASG3Constraint * (^)(void))priorityHigh;

/**
 *	Sets the constraint relation to NSLayoutRelationEqual
 *  returns a block which accepts one of the following:
 *    MASG3ViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (MASG3Constraint * (^)(id attr))equalTo;

/**
 *	Sets the constraint relation to NSLayoutRelationGreaterThanOrEqual
 *  returns a block which accepts one of the following:
 *    MASG3ViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (MASG3Constraint * (^)(id attr))greaterThanOrEqualTo;

/**
 *	Sets the constraint relation to NSLayoutRelationLessThanOrEqual
 *  returns a block which accepts one of the following:
 *    MASG3ViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (MASG3Constraint * (^)(id attr))lessThanOrEqualTo;

/**
 *	Optional semantic property which has no effect but improves the readability of constraint
 */
- (MASG3Constraint *)with;

/**
 *	Optional semantic property which has no effect but improves the readability of constraint
 */
- (MASG3Constraint *)and;

/**
 *	Creates a new MASG3CompositeConstraint with the called attribute and reciever
 */
- (MASG3Constraint *)left;
- (MASG3Constraint *)top;
- (MASG3Constraint *)right;
- (MASG3Constraint *)bottom;
- (MASG3Constraint *)leading;
- (MASG3Constraint *)trailing;
- (MASG3Constraint *)width;
- (MASG3Constraint *)height;
- (MASG3Constraint *)centerX;
- (MASG3Constraint *)centerY;
- (MASG3Constraint *)baseline;

#if TARGET_OS_IPHONE

- (MASG3Constraint *)leftMargin;
- (MASG3Constraint *)rightMargin;
- (MASG3Constraint *)topMargin;
- (MASG3Constraint *)bottomMargin;
- (MASG3Constraint *)leadingMargin;
- (MASG3Constraint *)trailingMargin;
- (MASG3Constraint *)centerXWithinMargins;
- (MASG3Constraint *)centerYWithinMargins;

#endif


/**
 *	Sets the constraint debug name
 */
- (MASG3Constraint * (^)(id key))key;

// NSLayoutConstraint constant Setters
// for use outside of masG3_updateConstraints/masG3_makeConstraints blocks

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects MASG3Constraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (void)setInsets:(MASG3EdgeInsets)insets;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects MASG3Constraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeWidth, NSLayoutAttributeHeight
 */
- (void)setSizeOffset:(CGSize)sizeOffset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects MASG3Constraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeCenterX, NSLayoutAttributeCenterY
 */
- (void)setCenterOffset:(CGPoint)centerOffset;

/**
 *	Modifies the NSLayoutConstraint constant
 */
- (void)setOffset:(CGFloat)offset;


// NSLayoutConstraint Installation support

#if TARGET_OS_MAC && !TARGET_OS_IPHONE
/**
 *  Whether or not to go through the animator proxy when modifying the constraint
 */
@property (nonatomic, copy, readonly) MASG3Constraint *animator;
#endif

/**
 *  Activates an NSLayoutConstraint if it's supported by an OS. 
 *  Invokes install otherwise.
 */
- (void)activate;

/**
 *  Deactivates previously installed/activated NSLayoutConstraint.
 */
- (void)deactivate;

/**
 *	Creates a NSLayoutConstraint and adds it to the appropriate view.
 */
- (void)install;

/**
 *	Removes previously installed NSLayoutConstraint
 */
- (void)uninstall;

@end


/**
 *  Convenience auto-boxing macros for MASG3Constraint methods.
 *
 *  Defining MASG3_SHORTHAND_GLOBALS will turn on auto-boxing for default syntax.
 *  A potential drawback of this is that the unprefixed macros will appear in global scope.
 */
#define masG3_equalTo(...)                 equalTo(MASG3BoxValue((__VA_ARGS__)))
#define masG3_greaterThanOrEqualTo(...)    greaterThanOrEqualTo(MASG3BoxValue((__VA_ARGS__)))
#define masG3_lessThanOrEqualTo(...)       lessThanOrEqualTo(MASG3BoxValue((__VA_ARGS__)))

#define masG3_offset(...)                  valueOffset(MASG3BoxValue((__VA_ARGS__)))


#ifdef MASG3_SHORTHAND_GLOBALS

#define equalTo(...)                     masG3_equalTo(__VA_ARGS__)
#define greaterThanOrEqualTo(...)        masG3_greaterThanOrEqualTo(__VA_ARGS__)
#define lessThanOrEqualTo(...)           masG3_lessThanOrEqualTo(__VA_ARGS__)

#define offset(...)                      masG3_offset(__VA_ARGS__)

#endif


@interface MASG3Constraint (AutoboxingSupport)

/**
 *  Aliases to corresponding relation methods (for shorthand macros)
 *  Also needed to aid autocompletion
 */
- (MASG3Constraint * (^)(id attr))masG3_equalTo;
- (MASG3Constraint * (^)(id attr))masG3_greaterThanOrEqualTo;
- (MASG3Constraint * (^)(id attr))masG3_lessThanOrEqualTo;

/**
 *  A dummy method to aid autocompletion
 */
- (MASG3Constraint * (^)(id offset))masG3_offset;

@end
