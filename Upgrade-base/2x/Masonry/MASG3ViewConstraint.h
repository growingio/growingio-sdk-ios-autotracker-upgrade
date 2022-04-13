//
//  MASG3Constraint.h
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "Upgrade-base/2x/Masonry/MASG3ViewAttribute.h"
#import "Upgrade-base/2x/Masonry/MASG3Constraint.h"
#import "Upgrade-base/2x/Masonry/MASG3LayoutConstraint.h"
#import "Upgrade-base/2x/Masonry/MASG3Utilities.h"

/**
 *  A single constraint.
 *  Contains the attributes neccessary for creating a NSLayoutConstraint and adding it to the appropriate view
 */
@interface MASG3ViewConstraint : MASG3Constraint <NSCopying>

/**
 *	First item/view and first attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) MASG3ViewAttribute *firstViewAttribute;

/**
 *	Second item/view and second attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) MASG3ViewAttribute *secondViewAttribute;

/**
 *	initialises the MASG3ViewConstraint with the first part of the equation
 *
 *	@param	firstViewAttribute	view.masG3_left, view.masG3_width etc.
 *
 *	@return	a new view constraint
 */
- (id)initWithFirstViewAttribute:(MASG3ViewAttribute *)firstViewAttribute;

/**
 *  Returns all MASG3ViewConstraints installed with this view as a first item.
 *
 *  @param  view  A view to retrieve constraints for.
 *
 *  @return An array of MASG3ViewConstraints.
 */
+ (NSArray *)installedConstraintsForView:(MASG3_VIEW *)view;

@end
