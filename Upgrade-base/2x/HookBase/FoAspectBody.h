//
//  FoAspectBody.h
//  Growing
//
//  Created by Junyang Ma on 3/29/17.
//  Copyright © 2017 GrowingIO. All rights reserved.
//

@interface CLASS_NAME(FoObjectSELObserver)

- (id<FoObjectSELObserverItem>)addFoObserverSelector:(SEL)sel
                                            template:(void*)templateImp
                                                type:(FoObjectSELObserverOption)option
                                       callbackBlock:(id)callbackBlock;

@end

@interface CLASS_NAME(FoObjectOriginResultsOfRespondsToSelHelper)

- (BOOL)restoreOriginResultOfRespondsToSelector:(SEL) sel;
- (void)recordOriginResultOfRespondsToSelector:(SEL) sel;

@end
