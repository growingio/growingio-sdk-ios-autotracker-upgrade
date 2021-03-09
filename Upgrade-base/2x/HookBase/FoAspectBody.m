//
//  FoAspectBody.m
//  Growing
//
//  Created by Junyang Ma on 3/29/17.
//  Copyright © 2017 GrowingIO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GrowingAspect.h"

@implementation CLASS_NAME(FoObjectSELObserver)


static char __FoObjectSELObserverManagerKey;
- (FoObjectSELObserverManager*)__FoObjectSELObserverManager
{
    return objc_getAssociatedObject(self, &__FoObjectSELObserverManagerKey);
}

- (FoObjectSELObserverManager*)__createFoObjectSELObserverManager
{
    FoObjectSELObserverManager *manager = [self __FoObjectSELObserverManager];
    if (!manager)
    {
        manager = [[FoObjectSELObserverManager alloc] init] ;
        manager.obj = self;
        objc_setAssociatedObject(self, &__FoObjectSELObserverManagerKey, manager, OBJC_ASSOCIATION_RETAIN);
        FoObjectSELObserverManagerRemover *remover = [[FoObjectSELObserverManagerRemover alloc] init];
        remover.manager = manager;
        
        static char __FoObjectSELObserverManagerRemoverKey;
        objc_setAssociatedObject(self,
                                 &__FoObjectSELObserverManagerRemoverKey,
                                 remover,
                                 OBJC_ASSOCIATION_RETAIN);
    }
    return manager;
}


- (id<FoObjectSELObserverItem>)addFoObserverSelector:(SEL)sel
                                            template:(void*)templateImp
                                                type:(FoObjectSELObserverOption)type
                                       callbackBlock:(id)callbackBlock
{
    FoObjectSELObserverItem *item = [[FoObjectSELObserverItem alloc] initWithObj:self
                                                                             sel:sel
                                                                        template:templateImp
                                                                            type:type
                                                                   callbackBlock:callbackBlock];

    FoObjectSELObserverItemShell *shell = [[FoObjectSELObserverItemShell alloc] init];
    shell->trueObj = item;
    return shell;
}

@end

@implementation CLASS_NAME(FoObjectSELObserverMacro)

- (NSArray*)__fo_beforeBlocks:(SEL)sel
{
    return [[[self __FoObjectSELObserverManager] beforeDict] valueForKey:NSStringFromSelector(sel)];
}

- (NSArray*)__fo_afterBlocks:(SEL)sel
{
    return [[[self __FoObjectSELObserverManager] afterDict] valueForKey:NSStringFromSelector(sel)];
}

@end

@implementation CLASS_NAME(FoObjectOriginResultsOfRespondsToSelHelper)
static char originResultsOfRespondsToSelectorKey;

- (BOOL)restoreOriginResultOfRespondsToSelector:(SEL) sel
{
    if ([GrowingInstance aspectMode] == GrowingAspectModeDynamicSwizzling) {
        void (*tempImp)(void) = nil;
        NSString *selString = [@"foAspectIMPItem_" stringByAppendingString:NSStringFromSelector(sel)];
        foAspectIMPItem *impItem = objc_getAssociatedObject([self class], NSSelectorFromString(selString));
        foAspectIMPItem *impSuperItem = objc_getAssociatedObject([self superclass], NSSelectorFromString(selString));
        if(impItem.oldIMP) {
            tempImp = (void*)impItem.oldIMP;
        } else if (impSuperItem.oldIMP) {
            //  先执行了父类，且父类本身就实现了代理方法
            tempImp = impSuperItem.oldIMP;
        } else if (!impSuperItem && class_respondsToSelector([self superclass], sel)) {
            //  父类没有执行，且父类本身实现了代理方法
            tempImp = (void*)class_getMethodImplementation([self superclass], sel);
        }
        //  主要排除情况：父类本身没有实现代理方法，先执行父类之后，添加了对应的方法，需要排除这种情况
        if (tempImp) {
            return YES;
        } else {
            return NO;
        }
    } else {
        NSMutableDictionary *originResultsOfRespondsToSelector = objc_getAssociatedObject(self, &originResultsOfRespondsToSelectorKey);
        // 如果 respondsToSelector:sel 的结果没有保存过，那么 originResultsOfRespondsToSelector[NSStringFromSelector(sel)] 会
        // 返回 nil, 最终结果会返回 NO
        return ((NSNumber*)originResultsOfRespondsToSelector[NSStringFromSelector(sel)]).boolValue;
    }
    
}

- (void)recordOriginResultOfRespondsToSelector:(SEL) sel
{
    BOOL isRespondsToSelector = [self respondsToSelector:sel];
    NSMutableDictionary *originResultsOfRespondsToSelector = objc_getAssociatedObject(self, &originResultsOfRespondsToSelectorKey);
    if (!originResultsOfRespondsToSelector) {
        originResultsOfRespondsToSelector = [NSMutableDictionary dictionaryWithCapacity:20];
        objc_setAssociatedObject(self,
                                 &originResultsOfRespondsToSelectorKey,
                                 originResultsOfRespondsToSelector,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if(!originResultsOfRespondsToSelector[NSStringFromSelector(sel)])
    {
        originResultsOfRespondsToSelector[NSStringFromSelector(sel)] = @(isRespondsToSelector);
    }
}
@end
