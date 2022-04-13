//
//  FoObjectSELObserverMacro.h
//
//  Created by Fover0 on 15/8/22.
//

#ifndef d_FoObjectSELObserverMacro_h
#define d_FoObjectSELObserverMacro_h

#import <objc/runtime.h>
#import "Upgrade-base/2x/HookBase/metamacros.h"


#define functionDefine(index,varType)   \
            ,varType param##index

#define functionCall(index,varType)     \
            ,param##index

#define functionCallforeachParam(paramMacro,...) \
        metamacro_if_eq(1,metamacro_argcount(__VA_ARGS__))()(metamacro_foreach(paramMacro,, metamacro_tail(__VA_ARGS__)))

#define functionDefineforeach(...)      \
        functionCallforeachParam(functionDefine,__VA_ARGS__)

#define functionCallforeach(...)      \
        functionCallforeachParam(functionCall,__VA_ARGS__)

#define functionHookCallInArr(ARRAY,RETURNVARSET,RETURNCALL,EARLYRETURNMACRO,EARLYRETURNCODE, ...)                  \
        for (FoObjectSELObserverItem *item in ARRAY )                                                               \
        {                                                                                                           \
            if (item.block)                                                                                         \
            {                                                                                                       \
                RETURNVARSET ((typeof(tempBlock))item.block)(self,tempSel functionCallforeach(__VA_ARGS__) RETURNCALL EARLYRETURNMACRO(NOTUSED)); \
                if (shouldEarlyReturn)                                                                              \
                {                                                                                                   \
                    EARLYRETURNCODE;                                                                                \
                }                                                                                                   \
            }                                                                                                       \
        }                                                                                                           \


#define _FoSwizzleVoidParama(ReturnType)
#define _FoSwizzleReturnParama(ReturnType) ,retVal

#define _FoSwizzleVoidVarDefine(ReturnType,RETURNVarDefine)
#define _FoSwizzleReturnVarDefine(ReturnType,RETURNVarDefine) ReturnType retVal = (ReturnType)0;
#define _FoSwizzleStructVarDefine(ReturnType,RETURNVarDefine) ReturnType retVal = RETURNVarDefine;

#define _FoSwizzleVoidFunctionDefine(ReturnType)
#define _FoSwizzleReturnFunctionDefine(ReturnType) ,ReturnType

#define _FoSwizzleVoidSet(ReturnType)
#define _FoSwizzleReturnSet(ReturnType) retVal =

#define _FoSwizzleVoidReturn(ReturnType) return
#define _FoSwizzleReturnReturn(ReturnType) return retVal

#define _FoSwizzleNormalImp class_getMethodImplementation

#if defined(__arm64__)
#define _FoSwizzleStructImp class_getMethodImplementation
#else
#define _FoSwizzleStructImp class_getMethodImplementation_stret
#endif

// before-block
#define _FoSwizzleEarlyReturnParamBeforeBlock(NOTUSED) ,&shouldEarlyReturn
// after-block doesn't need an early-return flag, because origin method is already called, and all after-blocks are not in order
#define _FoSwizzleEarlyReturnParamAfterBlock(NOTUSED) ,nil

#define __FoSwizzleTemplet(SELECTOR,                                                                                            \
                           getIMPFunction,                                                                                      \
                           ReturnType,ReturnDefaultValue,                                                                       \
                           oldReturnParam , RETURNVarDefine,                                                                    \
                           RETURNFunctionDefine , RETURNSET ,RETURNRETURN,  ...)                                                \
        static ReturnType metamacro_concat(__,metamacro_head(__VA_ARGS__)) (id self,SEL _cmd functionDefineforeach(__VA_ARGS__)  )     \
        {                                                                                                                       \
            BOOL shouldEarlyReturn = NO;                                                                                        \
            SEL tempSel = SELECTOR;                                                                                             \
            ReturnType (^tempBlock)(id,SEL functionDefineforeach(__VA_ARGS__) RETURNFunctionDefine(ReturnType), BOOL*) = nil;   \
            RETURNVarDefine(ReturnType,ReturnDefaultValue)                                                                      \
            /*before*/                                                                                                          \
            functionHookCallInArr([self __fo_beforeBlocks:tempSel],                                                             \
                                  RETURNSET(ReturnType),                                                                        \
                                  oldReturnParam(ReturnType),                                                                   \
                                  _FoSwizzleEarlyReturnParamBeforeBlock,                                                        \
                                  RETURNRETURN(ReturnType),                                                                     \
                                  __VA_ARGS__)                                                                                  \
            /*orig*/                                                                                                            \
            Class superClass = class_getSuperclass(object_getClass(self));                                                      \
            ReturnType (*tempImp)(id,SEL functionDefineforeach(__VA_ARGS__)) = nil;                                             \
            Method method = class_getInstanceMethod(superClass, tempSel);                                                       \
            if (method)                                                                                                         \
            {                                                                                                                   \
                tempImp = (void*)method_getImplementation(method);                                                              \
            }                                                                                                                   \
            else                                                                                                                \
            {                                                                                                                   \
                /* 取出未添加 KVO 子类前， respondsToSelector 的结果 */                                                             \
                BOOL isRespondsToSelector = [self restoreOriginResultOfRespondsToSelector:tempSel];                             \
                /* 如果在添 KVO 子类前，原来的 Class 没有实现该方法，那么就不需要取出原来的 Class 中的 IMP, 因为反正也没有 */                \
                if (isRespondsToSelector)                                                                                       \
                {                                                                                                               \
                    tempImp = (void*)getIMPFunction(superClass, tempSel);                                                       \
                }                                                                                                               \
            }                                                                                                                   \
                                                                                                                                \
            if (tempImp)                                                                                                        \
            {                                                                                                                   \
                RETURNSET(ReturnType) tempImp(self,tempSel  functionCallforeach(__VA_ARGS__)  );                                \
            }                                                                                                                   \
            /*after*/                                                                                                           \
            functionHookCallInArr([self __fo_afterBlocks:tempSel],                                                              \
                                  RETURNSET(ReturnType),                                                                        \
                                  oldReturnParam(ReturnType),                                                                   \
                                  _FoSwizzleEarlyReturnParamAfterBlock,                                                         \
                                  /* empty return statement */,                                                                 \
                                  __VA_ARGS__)                                                                                  \
            RETURNRETURN(ReturnType);                                                                                           \
        }                                                                                                                       \
        static void * metamacro_head(__VA_ARGS__) = metamacro_concat(__,metamacro_head(__VA_ARGS__));                           \


#define FoSwizzleTempletVoid(SELECTOR,ReturnType, ...)  \
        __FoSwizzleTemplet(SELECTOR,class_getMethodImplementation, ReturnType , ,  _FoSwizzleVoidParama , _FoSwizzleVoidVarDefine ,  _FoSwizzleVoidFunctionDefine , _FoSwizzleVoidSet ,_FoSwizzleVoidReturn , __VA_ARGS__)

#define FoSwizzleTemplet(SELECTOR,ReturnType, ...)  \
        __FoSwizzleTemplet(SELECTOR,class_getMethodImplementation, ReturnType , ,  _FoSwizzleReturnParama , _FoSwizzleReturnVarDefine ,  _FoSwizzleReturnFunctionDefine , _FoSwizzleReturnSet ,_FoSwizzleReturnReturn , __VA_ARGS__)

#define FoSwizzleTempletStruct(SELECTOR,ReturnType,ReturnDefaultValue, ...)  \
        __FoSwizzleTemplet(SELECTOR,_FoSwizzleStructImp ,ReturnType ,ReturnDefaultValue,  _FoSwizzleReturnParama , _FoSwizzleStructVarDefine ,  _FoSwizzleReturnFunctionDefine , _FoSwizzleReturnSet ,_FoSwizzleReturnReturn , __VA_ARGS__)


#endif

@interface FoObjectSELObserverItem : NSObject
@property (nonatomic, strong) id  block;
@end

#define CLASS_NAME NSObject
#include "FoAspectMacro.h"
#undef CLASS_NAME

#define CLASS_NAME NSProxy
#include "FoAspectMacro.h"
#undef CLASS_NAME
