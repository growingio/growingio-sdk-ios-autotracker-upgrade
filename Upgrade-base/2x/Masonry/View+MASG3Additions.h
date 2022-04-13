//
//  UIView+MASG3Additions.h
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "Upgrade-base/2x/Masonry/MASG3Utilities.h"
#import "Upgrade-base/2x/Masonry/MASG3ConstraintMaker.h"
#import "Upgrade-base/2x/Masonry/MASG3ViewAttribute.h"

/**
 *	Provides constraint maker block
 *  and convience methods for creating MASG3ViewAttribute which are view + NSLayoutAttribute pairs
 */
@interface MASG3_VIEW (MASG3Additions)

/**
 *	following properties return a new MASG3ViewAttribute with current view and appropriate NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_left;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_top;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_right;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_bottom;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_leading;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_trailing;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_width;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_height;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_centerX;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_centerY;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_baseline;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *(^masG3_attribute)(NSLayoutAttribute attr);

#if TARGET_OS_IPHONE

@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_leftMargin;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_rightMargin;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_topMargin;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_bottomMargin;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_leadingMargin;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_trailingMargin;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_centerXWithinMargins;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_centerYWithinMargins;

#endif

/**
 *	a key to associate with this view
 */
@property (nonatomic, strong) id masG3_key;

/**
 *	Finds the closest common superview between this view and another view
 *
 *	@param	view	other view
 *
 *	@return	returns nil if common superview could not be found
 */
- (instancetype)masG3_closestCommonSuperview:(MASG3_VIEW *)view;

/**
 *  Creates a MASG3ConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created MASG3Constraints
 */
- (NSArray *)masG3_makeConstraints:(void(^)(MASG3ConstraintMaker *make))block;

/**
 *  Creates a MASG3ConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  If an existing constraint exists then it will be updated instead.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated MASG3Constraints
 */
- (NSArray *)masG3_updateConstraints:(void(^)(MASG3ConstraintMaker *make))block;

/**
 *  Creates a MASG3ConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  All constraints previously installed for the view will be removed.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated MASG3Constraints
 */
- (NSArray *)masG3_remakeConstraints:(void(^)(MASG3ConstraintMaker *make))block;

@end
