//
//  MASG3CompositeConstraint.h
//  Masonry
//
//  Created by Jonas Budelmann on 21/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "Upgrade-base/2x/Masonry/MASG3Constraint.h"
#import "Upgrade-base/2x/Masonry/MASG3Utilities.h"

/**
 *	A group of MASG3Constraint objects
 */
@interface MASG3CompositeConstraint : MASG3Constraint

/**
 *	Creates a composite with a predefined array of children
 *
 *	@param	children	child MASG3Constraints
 *
 *	@return	a composite constraint
 */
- (id)initWithChildren:(NSArray *)children;

@end
