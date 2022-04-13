//
//  MASG3ConstraintBuilder.h
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "Upgrade-base/2x/Masonry/MASG3Constraint.h"
#import "Upgrade-base/2x/Masonry/MASG3Utilities.h"

typedef NS_OPTIONS(NSInteger, MASG3Attribute) {
    MASG3AttributeLeft = 1 << NSLayoutAttributeLeft,
    MASG3AttributeRight = 1 << NSLayoutAttributeRight,
    MASG3AttributeTop = 1 << NSLayoutAttributeTop,
    MASG3AttributeBottom = 1 << NSLayoutAttributeBottom,
    MASG3AttributeLeading = 1 << NSLayoutAttributeLeading,
    MASG3AttributeTrailing = 1 << NSLayoutAttributeTrailing,
    MASG3AttributeWidth = 1 << NSLayoutAttributeWidth,
    MASG3AttributeHeight = 1 << NSLayoutAttributeHeight,
    MASG3AttributeCenterX = 1 << NSLayoutAttributeCenterX,
    MASG3AttributeCenterY = 1 << NSLayoutAttributeCenterY,
    MASG3AttributeBaseline = 1 << NSLayoutAttributeBaseline,
    
#if TARGET_OS_IPHONE
    
    MASG3AttributeLeftMargin = 1 << NSLayoutAttributeLeftMargin,
    MASG3AttributeRightMargin = 1 << NSLayoutAttributeRightMargin,
    MASG3AttributeTopMargin = 1 << NSLayoutAttributeTopMargin,
    MASG3AttributeBottomMargin = 1 << NSLayoutAttributeBottomMargin,
    MASG3AttributeLeadingMargin = 1 << NSLayoutAttributeLeadingMargin,
    MASG3AttributeTrailingMargin = 1 << NSLayoutAttributeTrailingMargin,
    MASG3AttributeCenterXWithinMargins = 1 << NSLayoutAttributeCenterXWithinMargins,
    MASG3AttributeCenterYWithinMargins = 1 << NSLayoutAttributeCenterYWithinMargins,

#endif
    
};

/**
 *  Provides factory methods for creating MASG3Constraints.
 *  Constraints are collected until they are ready to be installed
 *
 */
@interface MASG3ConstraintMaker : NSObject

/**
 *	The following properties return a new MASG3ViewConstraint
 *  with the first item set to the makers associated view and the appropriate MASG3ViewAttribute
 */
@property (nonatomic, strong, readonly) MASG3Constraint *left;
@property (nonatomic, strong, readonly) MASG3Constraint *top;
@property (nonatomic, strong, readonly) MASG3Constraint *right;
@property (nonatomic, strong, readonly) MASG3Constraint *bottom;
@property (nonatomic, strong, readonly) MASG3Constraint *leading;
@property (nonatomic, strong, readonly) MASG3Constraint *trailing;
@property (nonatomic, strong, readonly) MASG3Constraint *width;
@property (nonatomic, strong, readonly) MASG3Constraint *height;
@property (nonatomic, strong, readonly) MASG3Constraint *centerX;
@property (nonatomic, strong, readonly) MASG3Constraint *centerY;
@property (nonatomic, strong, readonly) MASG3Constraint *baseline;

#if TARGET_OS_IPHONE

@property (nonatomic, strong, readonly) MASG3Constraint *leftMargin;
@property (nonatomic, strong, readonly) MASG3Constraint *rightMargin;
@property (nonatomic, strong, readonly) MASG3Constraint *topMargin;
@property (nonatomic, strong, readonly) MASG3Constraint *bottomMargin;
@property (nonatomic, strong, readonly) MASG3Constraint *leadingMargin;
@property (nonatomic, strong, readonly) MASG3Constraint *trailingMargin;
@property (nonatomic, strong, readonly) MASG3Constraint *centerXWithinMargins;
@property (nonatomic, strong, readonly) MASG3Constraint *centerYWithinMargins;

#endif

/**
 *  Returns a block which creates a new MASG3CompositeConstraint with the first item set
 *  to the makers associated view and children corresponding to the set bits in the
 *  MASG3Attribute parameter. Combine multiple attributes via binary-or.
 */
@property (nonatomic, strong, readonly) MASG3Constraint *(^attributes)(MASG3Attribute attrs);

/**
 *	Creates a MASG3CompositeConstraint with type MASG3CompositeConstraintTypeEdges
 *  which generates the appropriate MASG3ViewConstraint children (top, left, bottom, right)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) MASG3Constraint *edges;

/**
 *	Creates a MASG3CompositeConstraint with type MASG3CompositeConstraintTypeSize
 *  which generates the appropriate MASG3ViewConstraint children (width, height)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) MASG3Constraint *size;

/**
 *	Creates a MASG3CompositeConstraint with type MASG3CompositeConstraintTypeCenter
 *  which generates the appropriate MASG3ViewConstraint children (centerX, centerY)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) MASG3Constraint *center;

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL updateExisting;

/**
 *  Whether or not to remove existing constraints prior to installing
 */
@property (nonatomic, assign) BOOL removeExisting;

/**
 *	initialises the maker with a default view
 *
 *	@param	view	any MASG3Constrait are created with this view as the first item
 *
 *	@return	a new MASG3ConstraintMaker
 */
- (id)initWithView:(MASG3_VIEW *)view;

/**
 *	Calls install method on any MASG3Constraints which have been created by this maker
 *
 *	@return	an array of all the installed MASG3Constraints
 */
- (NSArray *)install;

- (MASG3Constraint * (^)(dispatch_block_t))group;

@end
