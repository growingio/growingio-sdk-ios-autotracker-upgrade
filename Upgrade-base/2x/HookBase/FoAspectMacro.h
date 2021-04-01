//
//  FoAspectMacro.h
//  Growing
//
//  Created by Junyang Ma on 3/30/17.
//  Copyright © 2017 GrowingIO. All rights reserved.
//

@interface CLASS_NAME(FoObjectSELObserverMacro)

- (NSArray*)__fo_beforeBlocks:(SEL)sel;
- (NSArray*)__fo_afterBlocks:(SEL)sel;

@end
