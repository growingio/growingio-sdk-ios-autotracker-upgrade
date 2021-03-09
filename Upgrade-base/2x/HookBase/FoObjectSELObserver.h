//
//  FoObjectSELObserver.h
//
//  Created by Fover0 on 15/8/19.
//

#import <Foundation/Foundation.h>
#import "FoObjectSELObserverMacro.h"

@protocol FoObjectSELObserverItem <NSObject>
- (void)remove;
@end


typedef NS_ENUM(NSUInteger, FoObjectSELObserverOption)
{
    FoObjectSELObserverOptionAfter      = 1,
    FoObjectSELObserverOptionBefore     = 2,
    FoObjectSELObserverOptionAddMethod  = 4,
};

#define CLASS_NAME NSObject
#include "FoAspectBody.h"
#undef CLASS_NAME

#define CLASS_NAME NSProxy
#include "FoAspectBody.h"
#undef CLASS_NAME

@interface NSProxy(FoAspectMimicKVOSubclass)

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;
- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context;

@end
