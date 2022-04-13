//
//  FoObjectSELObserver.h
//
//  Created by Fover0 on 15/8/19.
//

#import <Foundation/Foundation.h>
#import "Upgrade-base/2x/HookBase/FoObjectSELObserverMacro.h"

@protocol FoObjectSELObserverItem <NSObject>
- (void)remove;
@end


typedef NS_ENUM(NSUInteger, FoObjectSELObserverOption)
{
    FoObjectSELObserverOptionAfter      = 1,
    FoObjectSELObserverOptionBefore     = 2,
    FoObjectSELObserverOptionAddMethod  = 4,
};

@interface NSObject(FoObjectSELObserver)

- (id<FoObjectSELObserverItem>)addFoObserverSelector:(SEL)sel
                                            template:(void*)templateImp
                                                type:(FoObjectSELObserverOption)option
                                       callbackBlock:(id)callbackBlock;

@end

@interface NSObject(FoObjectOriginResultsOfRespondsToSelHelper)

- (BOOL)restoreOriginResultOfRespondsToSelector:(SEL) sel;
- (void)recordOriginResultOfRespondsToSelector:(SEL) sel;

@end

@interface NSProxy(FoObjectSELObserver)

- (id<FoObjectSELObserverItem>)addFoObserverSelector:(SEL)sel
                                            template:(void*)templateImp
                                                type:(FoObjectSELObserverOption)option
                                       callbackBlock:(id)callbackBlock;

@end

@interface NSProxy(FoObjectOriginResultsOfRespondsToSelHelper)

- (BOOL)restoreOriginResultOfRespondsToSelector:(SEL) sel;
- (void)recordOriginResultOfRespondsToSelector:(SEL) sel;

@end

@interface NSProxy(FoAspectMimicKVOSubclass)

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;
- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context;

@end
