//
//  NSArray+MASG3ShorthandAdditions.h
//  Masonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "Upgrade-base/2x/Masonry/NSArray+MASG3Additions.h"

#ifdef MASG3_SHORTHAND

/**
 *	Shorthand array additions without the 'masG3_' prefixes,
 *  only enabled if MASG3_SHORTHAND is defined
 */
@interface NSArray (MASG3ShorthandAdditions)

- (NSArray *)makeConstraints:(void(^)(MASG3ConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(MASG3ConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(MASG3ConstraintMaker *make))block;

@end

@implementation NSArray (MASG3ShorthandAdditions)

- (NSArray *)makeConstraints:(void(^)(MASG3ConstraintMaker *))block {
    return [self masG3_makeConstraints:block];
}

- (NSArray *)updateConstraints:(void(^)(MASG3ConstraintMaker *))block {
    return [self masG3_updateConstraints:block];
}

- (NSArray *)remakeConstraints:(void(^)(MASG3ConstraintMaker *))block {
    return [self masG3_remakeConstraints:block];
}

@end

#endif
