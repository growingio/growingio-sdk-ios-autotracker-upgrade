//
//  FoDelegateSwizzling.h
//
//  Created by Fover0 on 15/8/26.
//

#import <Foundation/Foundation.h>
#import "FoSwizzling.h"
#import "FoObjectSELObserver.h"
#import "FoWeakObjectShell.h"
#import <GrowingCoreKit/GrowingCoreKit.h>

#import <objc/runtime.h>
#import <objc/message.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunneeded-internal-declaration"
static BOOL isHookDelegateSuccess(Class aClass)
{
    if (!aClass) {
        return YES;
    }
    if ([Growing getAspectMode] == GrowingAspectModeDynamicSwizzling) {
        return YES;
    }
    
    if ([NSStringFromClass(aClass) hasPrefix:@"NSKVONotifying"] || [NSStringFromClass(aClass) hasPrefix:@"GIOKVONotifying"]) {
        return YES;
    } else {
        Class superClass = class_getSuperclass(aClass);
        if (superClass == nil) {
            return NO;
        } else {
            return isHookDelegateSuccess(superClass);
        }
        
    }
}
#pragma clang diagnostic pop

#define FoHookDelegate(theClass,theSEL,theRetType,theDelegateType,theDelegateVar)                                       \
              __FoHookDelegate(FoHookInstance,                                                                          \
                               theClass,                                                                                \
                               theSEL,                                                                                  \
                               theRetType,                                                                              \
                               theDelegateType,                                                                         \
                               theDelegateVar)                                                                          \

#define FoHookDelegatePlus(theClassName, selfType,theSEL,theRetType,theDelegateType,theDelegateVar)                                       \
              __FoHookDelegatePlus(FoHookInstancePlus,                                                                          \
                               theClassName,                                                                                \
                               selfType,                                                                             \
                               theSEL,                                                                                  \
                               theRetType,                                                                              \
                               theDelegateType,                                                                         \
                               theDelegateVar)                                                                          \

#define FoHookWKWebViewDelegate(theClass,theSEL,theRetType,theDelegateType,theDelegateVar)                              \
             __FoHookWKWebViewDelegate(FoHookInstancePlus,                                                              \
                                       theClass,                                                                        \
                                       theSEL,                                                                          \
                                       theRetType,                                                                      \
                                       theDelegateType,                                                                 \
                                       theDelegateVar)                                                                  \

#define FoHookListViewDelegate(theClass,theSEL,theRetType,theDelegateType,theDelegateVar)                               \
              __FoHookListViewDelegate(FoHookInstance,                                                                  \
                                          theClass,                                                                     \
                                          theSEL,                                                                       \
                                          theRetType,                                                                   \
                                          theDelegateType,                                                              \
                                          theDelegateVar)                                                               \

// 如果把一个deallcating的对象作为delegate传入 则会crash  但是判断的接口都被废弃了  所以暂时不予修复
#define __FoHookDelegate(HOOKMACRO,theClass,theSEL,theRetType,theDelegateType,theDelegateVar)                           \
    HOOKMACRO(theClass, theSEL,theRetType,theDelegateType theDelegateVar)                                               \
    __FoHookDelegateBody(theClass, theSEL,theRetType,theDelegateType,theDelegateVar)

#define __FoHookDelegatePlus(HOOKMACRO,theClassName, selfType,theSEL,theRetType,theDelegateType,theDelegateVar)                           \
    HOOKMACRO(theClassName, selfType, theSEL,theRetType,theDelegateType theDelegateVar)                                               \
    __FoHookDelegateBody(objc_getClass(theClassName), theSEL,theRetType,theDelegateType,theDelegateVar)

#define __FoHookListViewDelegate(HOOKMACRO,theClass,theSEL,theRetType,theDelegateType,theDelegateVar)                   \
    HOOKMACRO(theClass, theSEL, theRetType, theDelegateType theDelegateVar)                                             \
    {                                                                                                                   \
        if (self.growingAttributesDonotTrack)                                                                           \
        {                                                                                                               \
            FoHookOrgin(theDelegateVar);                                                                                \
            return;                                                                                                     \
        }                                                                                                               \
    }                                                                                                                   \
    __FoHookDelegateBody(theClass,theSEL,theRetType,theDelegateType,theDelegateVar)

// 如果把一个deallcating的对象作为delegate传入 则会crash  但是判断的接口都被废弃了  所以暂时不予修复
#define __FoHookWKWebViewDelegate(HOOKMACRO,theClass,theSEL,theRetType,theDelegateType,theDelegateVar)                  \
    HOOKMACRO("WKWebView", UIView *, theSEL, theRetType, theDelegateType theDelegateVar)                                \
    {                                                                                                                   \
        if (self.growingAttributesDonotTrack || !IOS8_PLUS)                                                             \
        {                                                                                                               \
            FoHookOrgin(theDelegateVar);                                                                                \
            return;                                                                                                     \
        }                                                                                                               \
        if (theDelegateVar == nil)                                                                                      \
        {                                                                                                               \
            if ([NSStringFromSelector(theSEL) isEqualToString:@"setNavigationDelegate:"]) {                                                       \
                theDelegateVar = self.growingHook_defaultWKNavDelegate;                                                 \
            }                                                                                                           \
        }                                                                                                               \
    }                                                                                                                   \
    __FoHookDelegateBody(theClass, theSEL,theRetType,theDelegateType,theDelegateVar)

#define __FoHookDelegateBody(theClass,theSEL,theRetType,theDelegateType,theDelegateVar)                                 \
{                                                                                                                       \
    static char growHookDelegateItemsKey;                                                                               \
    static char growHookWeakDelegateKey;                                                                                \
    FoWeakObjectShell *oldDelegate = objc_getAssociatedObject(self, &growHookWeakDelegateKey);                          \
    if (oldDelegate.obj)                                                                                                \
    {                                                                                                                   \
        NSMapTable *table = objc_getAssociatedObject(oldDelegate.obj, &growHookDelegateItemsKey);                       \
        NSArray *arr = [table objectForKey:self];                                                                       \
        [table removeObjectForKey:self];                                                                                \
        if (table.count == 0)                                                                                           \
        {                                                                                                               \
            objc_setAssociatedObject(oldDelegate.obj,                                                                   \
                                     &growHookDelegateItemsKey,                                                         \
                                     nil,                                                                               \
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);                                                \
        }                                                                                                               \
        [arr makeObjectsPerformSelector:@selector(remove)];                                                             \
    }                                                                                                                   \
                                                                                                                        \
    theDelegateType __FoHookDelegate_VAR = theDelegateVar;                                                              \
    SEL __FoHookDelegateSetterSEL_VAR = theSEL;                                                                         \
    SEL __FoHookDelegateGetterSEL_VAR = NSSelectorFromString(@#theDelegateVar);                                         \
    theDelegateType __FoHookDelegate_current_VAR;                                                                       \
    BOOL result = ((BOOL (*)(id, SEL))objc_msgSend)(self,sel_registerName("allowsWeakReference"));                      \
    if (theDelegateVar && result)                                                                   \
    {                                                                                                                   \
        __unused __weak typeof(self) wself = self;                                                                      \
        FoWeakObjectShell *weakdelegate = [[FoWeakObjectShell alloc] init];                                             \
        weakdelegate.obj = theDelegateVar;                                                                              \
        objc_setAssociatedObject(self,                                                                                  \
                                 &growHookWeakDelegateKey,                                                              \
                                 weakdelegate,                                                                          \
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);                                                    \
        NSArray *items = @[                                                                                             \





#define FoHookDelegateEnd                                                                                               \
        ];                                                                                                              \
                                                                                                                        \
        NSMapTable *table = objc_getAssociatedObject(__FoHookDelegate_VAR, &growHookDelegateItemsKey);                  \
        if (!table)                                                                                                     \
        {                                                                                                               \
            table =                                                                                                     \
            [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory                                         \
                                                   | NSPointerFunctionsObjectPointerPersonality                         \
                                      valueOptions:NSPointerFunctionsObjectPointerPersonality                           \
                                          capacity:2];                                                                  \
            objc_setAssociatedObject(__FoHookDelegate_VAR,                                                              \
                                     &growHookDelegateItemsKey,                                                         \
                                     table,                                                                             \
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);                                                \
        }                                                                                                               \
        [table setObject:items forKey:self];                                                                            \
    }                                                                                                                   \
    static BOOL isSetOriginInstanceManually = NO;                                                                       \
    /* 避免原实现重复调用 */                                                                                               \
    if (!isSetOriginInstanceManually)                                                                                   \
    {                                                                                                                   \
        FoHookOrgin(__FoHookDelegate_VAR);                                                                              \
        /* 原实现可能改变 delegate 或 dataSource 的值，导致上面的的 Hook 没生效，所以需要重新 Hook 一次。 */                       \
        __FoHookDelegate_current_VAR = [self performSelector:__FoHookDelegateGetterSEL_VAR];                            \
        Class current_VAR_Class = object_getClass(__FoHookDelegate_current_VAR);                                        \
        BOOL hookSuccess = isHookDelegateSuccess(current_VAR_Class);                                                    \
        if(__FoHookDelegate_VAR != __FoHookDelegate_current_VAR || !hookSuccess)                                        \
        {                                                                                                               \
           isSetOriginInstanceManually = YES;                                                                           \
           [self performSelector:__FoHookDelegateSetterSEL_VAR                                                          \
                      withObject:__FoHookDelegate_current_VAR];                                                         \
        }                                                                                                               \
    }                                                                                                                   \
    else                                                                                                                \
    {                                                                                                                   \
        isSetOriginInstanceManually = NO;                                                                               \
    }                                                                                                                   \
}                                                                                                                       \
FoHookEnd                                                                                                               \
