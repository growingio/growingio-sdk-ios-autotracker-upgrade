//
//  GrowingAspect.h
//  Growing
//
//  Created by 陈曦 on 16/5/23.
//  Copyright © 2016年 GrowingIO. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Upgrade-base/2x/HookBase/FoAspect.h"
#import "Upgrade-base/2x/HookBase/FoObjectSELObserver.h"
#import "Upgrade-base/2x/HookBase/metamacros.h"
#import "GrowingInstance.h"

#define _GrowingAspectForeachParam(paramMacro,...)                                                                                   \
        metamacro_if_eq(2,metamacro_argcount(__VA_ARGS__))                                                                      \
        ()                                                                                                                      \
        (metamacro_foreach(paramMacro,, metamacro_tail(metamacro_take(metamacro_dec(metamacro_argcount(__VA_ARGS__)), __VA_ARGS__ ))))                                                           \

#define _GrowingAspectGetCode(...)           \
        metamacro_drop(metamacro_dec( metamacro_argcount(__VA_ARGS__)),__VA_ARGS__)

#define _GrowingAspectOldMACRO(TYPE)        \
        , TYPE

#define _GrowingAspectOld(INDEX,VALUE)      \
        _GrowingAspectOldMACRO VALUE        \

#define _GrowingAspectRunOldMACRO(TYPE)     \
        ,

#define _GrowingAspectRunOld(INDEX,VALUE)    \
            _GrowingAspectRunOldMACRO VALUE  \

#define _GrowingAspectNEWMACRO(TYPE)        \
        ,(TYPE)

#define _GrowingAspectNEW(INDEX,VALUE)      \
        _GrowingAspectNEWMACRO VALUE

#define _GrowingAspectRETURN(TYPE)          \
        foAspectIsVoidType(TYPE)            \
        ()                                  \
        (, TYPE originReturnValue)

#define _GrowingAspectRETURNPOINT(TYPE)     \
        foAspectIsVoidType(TYPE)            \
        ()                                  \
        (, TYPE* p_originReturnValue)

#define _GrowingAspectCallRETURN(TYPE)      \
        foAspectIsVoidType(TYPE)            \
        ()                                  \
        (, originReturnValue)

#define _GrowingAspectCallRETURNPOINT(TYPE) \
        foAspectIsVoidType(TYPE)            \
        ()                                  \
        (, &originReturnValue)


#define _GrowingAspectRETURN_BLOCK(INDEX,VALUE)     \
        foAspectIsVoidType(TYPE)                    \
        ()                                          \
        (__unused TYPE * p_originReturnValue = &originReturnValue;)

#define _GrowingAspectRETURN_RETURN(TYPE)       \
        foAspectIsVoidType(TYPE)                \
        ()                                      \
        (return  originReturnValue;)


#define _GrowingAspect(OPTION,MACRO,OBJECT,TEMPLATE,RETURNTYPE,...)                                                     \
        ^id{                                                                                                            \
            [GrowingInstance setFreezeAspectMode];                                                                      \
            if ([GrowingInstance aspectMode] == GrowingAspectModeSubClass)                                              \
            {                                                                                                           \
                return                                                                                                  \
                [OBJECT addFoObserverSelector:metamacro_head(__VA_ARGS__)                                               \
                                     template:TEMPLATE                                                                  \
                                         type:OPTION                                                                    \
                                callbackBlock:^RETURNTYPE(id originInstance ,                                           \
                                                          SEL theCmd                                                    \
                                                          _GrowingAspectForeachParam(_GrowingAspectOld , __VA_ARGS__)   \
                                                          _GrowingAspectRETURN(RETURNTYPE)                              \
                                                          , BOOL * p_shouldEarlyReturn)  {                              \
                        ^void(id originInstance ,                                                                       \
                              SEL theCmd                                                                                \
                              _GrowingAspectForeachParam(_GrowingAspectOld , __VA_ARGS__)                               \
                              _GrowingAspectRETURN(RETURNTYPE)                                                          \
                              _GrowingAspectRETURNPOINT(RETURNTYPE)                                                     \
                              , BOOL * p_shouldEarlyReturn)                                                             \
                                                                                                                        \
                        _GrowingAspectGetCode(__VA_ARGS__)                                                              \
                        (originInstance,                                                                                \
                         theCmd                                                                                         \
                         _GrowingAspectForeachParam(_GrowingAspectRunOld ,__VA_ARGS__ )                                 \
                         _GrowingAspectCallRETURN(RETURNTYPE)                                                           \
                         _GrowingAspectCallRETURNPOINT(RETURNTYPE)                                                      \
                         , p_shouldEarlyReturn                                                                          \
                        );                                                                                              \
                        _GrowingAspectRETURN_RETURN(RETURNTYPE)                                                         \
                    }                                                                                                   \
                ];                                                                                                      \
            }                                                                                                           \
            else                                                                                                        \
            {                                                                                                           \
                return                                                                                                  \
                [OBJECT  MACRO (RETURNTYPE ,                                                                            \
                                metamacro_head(__VA_ARGS__)                                                             \
                                _GrowingAspectForeachParam(_GrowingAspectNEW , __VA_ARGS__))  _GrowingAspectGetCode(__VA_ARGS__)];\
            }                                                                                                           \
        }()


#define GrowingAspectAfter(OBJECT,TEMPLATE,RETURNTYPE,...)                                                              \
        _GrowingAspect(FoObjectSELObserverOptionAfter | FoObjectSELObserverOptionAddMethod,foAspectAfterSeletor,        \
                        OBJECT,TEMPLATE,RETURNTYPE,__VA_ARGS__)

#define GrowingAspectBefore(OBJECT,TEMPLATE,RETURNTYPE,...)                                                             \
        _GrowingAspect(FoObjectSELObserverOptionBefore | FoObjectSELObserverOptionAddMethod,foAspectBeforeSeletor,      \
                        OBJECT,TEMPLATE,RETURNTYPE,__VA_ARGS__)

#define GrowingAspectAfterNoAdd(OBJECT,TEMPLATE,RETURNTYPE,...)                                                         \
        _GrowingAspect(FoObjectSELObserverOptionAfter ,foAspectAfterSeletorNoAddMethod,                                            \
                        OBJECT,TEMPLATE,RETURNTYPE,__VA_ARGS__)

#define GrowingAspectBeforeNoAdd(OBJECT,TEMPLATE,RETURNTYPE,...)                                                        \
        _GrowingAspect(FoObjectSELObserverOptionBefore ,foAspectBeforeSeletorNoAddMethod,                                          \
                        OBJECT,TEMPLATE,RETURNTYPE,__VA_ARGS__)

