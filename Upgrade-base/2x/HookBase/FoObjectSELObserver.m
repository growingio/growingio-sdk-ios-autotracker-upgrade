//
//  FoObjectSELObserver.m
//
//  Created by Fover0 on 15/8/19.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>

#import "FoObjectSELObserver.h"
#import "FoObjectSELObserverMacro.h"
#import "FoSwizzling.h"
#import "GrowingInstance.h"
#import "GrowingMediator.h"
#import <pthread.h>
#import "GrowingCocoaLumberjack.h"
#import "GrowingInstance.h"
#import "GrowingAspect.h"

@interface FoObjectSELObserverItem()<FoObjectSELObserverItem>

@property (nonatomic, assign) id  obj;
@property (nonatomic, assign) SEL sel;
@property (nonatomic, copy)   NSString *kvoKeyPath;
@property (nullable)          void *objObservationInfo;
@property (nonatomic, assign) Class aClass;

- (instancetype)initWithObj:(id)obj
                        sel:(SEL)sel
                   template:(void*)templateImp
                       type:(FoObjectSELObserverOption)type
              callbackBlock:(id)block;
@end

@interface FoObjectSELObserverItemShell : NSObject<FoObjectSELObserverItem>
{
@public
    __weak id<FoObjectSELObserverItem> trueObj;
}
@end

@implementation FoObjectSELObserverItemShell

- (void)remove
{
    [trueObj remove];
}

@end

@interface FoObjectSELObserverManager : NSObject

@property (nonatomic, assign) id obj;
@property (nonatomic, readonly) NSMutableDictionary *beforeDict;
@property (nonatomic, readonly) NSMutableDictionary *afterDict;
@property (nonatomic, assign) BOOL addRespondsToSelectorFlag;

- (void)remove;
- (void)addItem:(FoObjectSELObserverItem*)item
           type:(FoObjectSELObserverOption)type
            sel:(SEL)sel;
- (void)removeItem:(FoObjectSELObserverItem*)item
              type:(FoObjectSELObserverOption)type
               sel:(SEL)sel;
- (void)addRespondsToSelectorHook;
@end

@interface FoObjectSELObserverManagerRemover : NSObject
@property (nonatomic, retain) FoObjectSELObserverManager *manager;
@end

@implementation FoObjectSELObserverManagerRemover

- (void)dealloc
{
    [self.manager remove];
}

@end



@implementation NSObject(FoObjectSELObserver)


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

@implementation NSObject(FoObjectSELObserverMacro)

- (NSArray*)__fo_beforeBlocks:(SEL)sel
{
    return [[[self __FoObjectSELObserverManager] beforeDict] valueForKey:NSStringFromSelector(sel)];
}

- (NSArray*)__fo_afterBlocks:(SEL)sel
{
    return [[[self __FoObjectSELObserverManager] afterDict] valueForKey:NSStringFromSelector(sel)];
}

@end

@implementation NSObject(FoObjectOriginResultsOfRespondsToSelHelper)
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

@implementation NSProxy(FoObjectSELObserver)


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

@implementation NSProxy(FoObjectSELObserverMacro)

- (NSArray*)__fo_beforeBlocks:(SEL)sel
{
    return [[[self __FoObjectSELObserverManager] beforeDict] valueForKey:NSStringFromSelector(sel)];
}

- (NSArray*)__fo_afterBlocks:(SEL)sel
{
    return [[[self __FoObjectSELObserverManager] afterDict] valueForKey:NSStringFromSelector(sel)];
}

@end

@implementation NSProxy(FoObjectOriginResultsOfRespondsToSelHelper)
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


#define FoAspectMimicKVOSubclassPrefix @"GIOKVONotifying_"

static void FoAspectHookedGetClass(Class subclass, Class originClass)
{
    Method method = class_getInstanceMethod(subclass, @selector(class));
    IMP newIMP = imp_implementationWithBlock(^(id self) {
        return originClass;
    });
    class_replaceMethod(subclass, @selector(class), newIMP, method_getTypeEncoding(method));
}


// 因为只有 NSObject 支持 KVO，NSProxy 不支持，所以我们为 NSPrxy 添加和 NSObject 一样的 addObserver 的方法,
// 模仿真正的 KVO, 动态地建立子类，该类前缀设为 GIOKVONotifying_。
// 从而保证 GrowingAspectModeSubClass 的 AspectMode 对 NSObject 和 NSProxy 的对象都有效
@implementation NSProxy(FoAspectMimicKVOSubclass)

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    Class objectClass = object_getClass(self);
    // className 需要是原本的类的类名，所以需要去掉 GIOKVONotifying_ 前缀
    NSString *className = [NSStringFromClass(objectClass) componentsSeparatedByString:FoAspectMimicKVOSubclassPrefix].lastObject;
    const char *subclassName = [FoAspectMimicKVOSubclassPrefix stringByAppendingString:className].UTF8String;
    Class subclass = objc_getClass(subclassName);
    if (subclass == nil) {
        subclass = objc_allocateClassPair(objectClass, subclassName, 0);
        FoAspectHookedGetClass(subclass, objectClass);
        FoAspectHookedGetClass(object_getClass(subclass), objectClass);
        objc_registerClassPair(subclass);
    }
    object_setClass(self, subclass);
}

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    // 什么都不需要做
}

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
    // 什么都不需要做
}

@end



@implementation FoObjectSELObserverItem


- (instancetype)initWithObj:(id)obj
                        sel:(SEL)sel
                   template:(void*)templateImp
                       type:(FoObjectSELObserverOption)type
              callbackBlock:(id)block
{
    if (!obj || !sel || !templateImp || !block)
    {
        return nil;
    }
    
    if (![obj respondsToSelector:sel] && !(type & FoObjectSELObserverOptionAddMethod))
    {
        return nil;
    }
    
    self = [super init];
    if (self)
    {
        self.obj = obj;
        self.sel = sel;
        self.block = block;
        self.kvoKeyPath = [NSString stringWithFormat:@"FoObjectSELObserver_%@",[NSProcessInfo processInfo].globallyUniqueString];
        
        // 保存未添加 KVO 子类前， respondsToSelector 的结果
        [self.obj recordOriginResultOfRespondsToSelector:sel];
        
        [obj addObserver:self
               forKeyPath:self.kvoKeyPath
                  options:NSKeyValueObservingOptionNew
                  context:nil];
        if ([obj isKindOfClass:[NSObject class]]) {
            self.objObservationInfo = ((NSObject *)obj).observationInfo;
        }
        
        Class objectClass = object_getClass(obj);
        self.aClass = objectClass;

        Class superClass = class_getSuperclass(objectClass);
        
        
        //基于安全的判断
        if (superClass != [obj class])
        {
            //基于rac判断 这样判断的目的是,如果有rac之外的库也动态创建子类可以方便我们知晓
            if (class_getSuperclass(superClass) != [obj class] || ![NSStringFromClass(objectClass) hasSuffix:@"_RACSelectorSignal"]) {
                GIOLogWarn(@"GIO 客户工程使用runtime技术改写了class, 造成我们GrowingAspectModeSubClass失效,请寻找适配方法");
                [obj removeObserver:self forKeyPath:self.kvoKeyPath];
                self.objObservationInfo = nil;
                self.kvoKeyPath = nil;
                return nil;
            } else {
                GIOLogWarn(@"GIO 客户工程使用了RAC框架");
            }
        }
        
        Method oldMethod = class_getInstanceMethod(superClass , sel);

        class_addMethod(objectClass,
                        sel,
                        templateImp,
                        method_getTypeEncoding(oldMethod));
        
        [[obj __createFoObjectSELObserverManager] addItem:self type:type sel:sel];
        
        if (!oldMethod)
        {
            [[obj __FoObjectSELObserverManager] addRespondsToSelectorHook];
        }
    }
    return self;
}

static pthread_mutex_t kvoMutex;
pthread_mutex_t * getkvoMutexPointer()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pthread_mutex_init(&kvoMutex, NULL);
    });
    return &kvoMutex;
}


- (void)remove
{
    pthread_mutex_t * pMutex = getkvoMutexPointer();
    pthread_mutex_lock(pMutex);
    
    if (self.block && self.obj && self.sel && self.kvoKeyPath)
    {
        [[self.obj __FoObjectSELObserverManager] removeItem:self type:FoObjectSELObserverOptionBefore sel:self.sel];
        [[self.obj __FoObjectSELObserverManager] removeItem:self type:FoObjectSELObserverOptionAfter sel:self.sel];
        
        BOOL isRemoveObserver = NO;
        // 详见bug: https://codes.growingio.com/T12219, JIRA: PI-2093
        // 直接改用 isProxy 进行判断 obj 是否继承自 NSObject
        // 原因按 Apple 注释如下:
        /*
         Returns a Boolean value that indicates whether the receiver does not descend from NSObject.
         This method is necessary because sending isKindOfClass: or isMemberOfClass: to an NSProxy object will test the object the proxy stands in for, not the proxy itself. Use this method to test if the receiver is a proxy (or a member of some other root class).
         
         Returns: NO if the receiver really descends from NSObject, otherwise YES.
         */
        if (![self.obj isProxy] &&
            ((NSObject *)self.obj).observationInfo == nil) {
            ((NSObject *)self.obj).observationInfo = self.objObservationInfo;
            [self objectRemoveKVO];
            isRemoveObserver = YES;
            ((NSObject *)self.obj).observationInfo = nil;
        }
        if (!isRemoveObserver) {
            [self objectRemoveKVO];
        }
    }
    self.kvoKeyPath = nil;
    self.obj = nil;
    self.sel = nil;
    self.block = nil;
    self.objObservationInfo = nil;
    self.aClass = nil;
    
    pthread_mutex_unlock(pMutex);
}

- (void)objectRemoveKVO
{
    //此处try的意义在于兼容firebase,但try只是临时方案,根本解决法应该firebase去改进
    //https://github.com/firebase/firebase-ios-sdk/issues/581#issuecomment-353262872
    @try {
            [self.obj removeObserver:self
                          forKeyPath:self.kvoKeyPath];
    } @catch (NSException *e) {
        Class aClass = object_getClass(self.obj);
        object_setClass(self.obj, self.aClass);
        @try {
            [self.obj removeObserver:self
                          forKeyPath:self.kvoKeyPath];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        object_setClass(self.obj, aClass);
        // nop
    } @finally {
    }
}

- (void)dealloc
{
    [self remove];
}

@end

@implementation FoObjectSELObserverManager

@synthesize beforeDict = _beforeDict;
@synthesize afterDict = _afterDict;

- (NSMutableDictionary*)beforeDict
{
    if (!_beforeDict)
    {
        _beforeDict = [[NSMutableDictionary alloc] init];
    }
    return _beforeDict;
}

- (NSMutableDictionary*)afterDict
{
    if (!_afterDict)
    {
        _afterDict = [[NSMutableDictionary alloc] init];
    }
    return _afterDict;
}

- (NSMutableArray*)arrForType:(FoObjectSELObserverOption)type sel:(SEL)sel
{
    NSMutableDictionary *dict = (type & FoObjectSELObserverOptionAfter) ? self.afterDict : self.beforeDict;
    NSString *key = NSStringFromSelector(sel);
    NSMutableArray *arr = [dict valueForKey:key];
    if (!arr)
    {
        arr = [[NSMutableArray alloc] init];
        [dict setValue:arr forKey:key];
    }
    return arr;
}

- (void)addItem:(FoObjectSELObserverItem*)item
           type:(FoObjectSELObserverOption)type
            sel:(SEL)sel
{
    [[self arrForType:type sel:sel] addObject:item];
}

- (void)removeItem:(FoObjectSELObserverItem*)item
              type:(FoObjectSELObserverOption)type
               sel:(SEL)sel
{
    [[self arrForType:type sel:sel] removeObject:item];
}

- (void)removeDictArr:(NSMutableDictionary*)dict
{
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, NSMutableArray *arr, BOOL *stop) {
        [arr enumerateObjectsUsingBlock:^(FoObjectSELObserverItem *item, NSUInteger idx, BOOL *stop) {
            [item remove];
        }];
        [arr removeAllObjects];
    }];
    [dict removeAllObjects];
}

- (void)remove
{
    [self removeDictArr:self.beforeDict];
    [self removeDictArr:self.afterDict];
    self.obj = nil;
}

FoSwizzleTemplet(@selector(respondsToSelector:),
                 BOOL,selhoookrespondsToSelector,SEL);

- (void)addRespondsToSelectorHook
{
    if (!self.addRespondsToSelectorFlag)
    {
        self.addRespondsToSelectorFlag = YES;
        FoObjectSELObserverItemShell *itemShell = [self.obj addFoObserverSelector:@selector(respondsToSelector:)
                               template:selhoookrespondsToSelector
                                   type:FoObjectSELObserverOptionAfter
                          callbackBlock:^BOOL(NSObject *object, SEL selector , SEL pSel, BOOL oldReturn){
                              if (!oldReturn)
                              {
                                  if ([object __fo_afterBlocks:pSel].count || [[object __fo_beforeBlocks:pSel] count])
                                  {
                                      oldReturn = YES;
                                  }
                              }
                              return oldReturn;
                          }];
        if ([self.obj isKindOfClass:[UITableView class]]) {
            NSDictionary *params = nil;
            if (itemShell) {
                params = @{@"0":itemShell};
            }
            [[GrowingMediator sharedInstance] performTarget:self.obj action:@"setGrowingHook_RespondsToSelector:" params:params];
        }
    }
}

@end

//FoSwizzleTemplet    (BOOL          ,  FoReturnBOOLwithSEL, SEL);
//FoSwizzleTemplet    (BOOL          ,  FoReturnBOOLwithID_ID2, id,id);
//FoSwizzleTemplet    (BOOL          ,  FoReturnBOOLwithID_ID2_ID3, id,id,id);
//FoSwizzleTemplet    (id            ,  FoReturnIDwithID_ID2, id,id);
//FoSwizzleTemplet    (id            ,  FoReturnIDwithID_ID2_ID3, id,id,id);
//FoSwizzleTemplet    (id            ,  FoReturnIDWithCGPoint_ID,CGPoint,id);
//
//FoSwizzleTempletVoid(void          ,  FoReturnVoid);
//FoSwizzleTempletVoid(void          ,  FoReturnVoidWithCGFloat,CGFloat);
//FoSwizzleTempletVoid(void          ,  FoReturnVoidWithBool,BOOL);
//FoSwizzleTempletVoid(void          ,  FoReturnVoidWithID,id);
//FoSwizzleTempletVoid(void          ,  FoReturnVoidWithID_ID2,id,id);
//FoSwizzleTempletVoid(void          ,  FoReturnVoidWithID_ID2_ID3,id,id,id);
//FoSwizzleTempletStruct(CGPoint, CGPointZero, FoReturnPoint);


