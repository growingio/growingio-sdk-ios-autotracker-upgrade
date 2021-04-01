//
//  FoAspectPrivate.h
//
//  Created by Fover0 on 16/5/7.
//

#import <objc/runtime.h>
#import "metamacros.h"

@protocol FoAspectToken;

@interface NSObject(foAspectPrivate)
- (id<FoAspectToken>)_foAspectSelector:(SEL)sel
                          canAddMethod:(BOOL)addMethod
                         isBeforeBlock:(BOOL)isBeforeBlock
                 templateCreateorBlock:(id(^)(Class classObject,
                                              Class superClassObject,
                                              SEL sel,
                                              SEL classSEL,
                                              SEL instanceSEL,
                                              IMP oldIMP,
                                              NSString **outTypeEncoding))templateCreatorBlock
                             userBlock:(id)userBlock;
@end

// block container
@interface foAspectItem : NSObject
{
@public
    NSMapTable<NSString*,id> *beforeBlock ;
    NSMapTable<NSString*,id> *afterBlock  ;
}

@end

// use for template block
BOOL foCheckTemplateCanRunBlock(Class templateClass, id object, SEL classHookedFlag);

#define foAspecttype_void  ,
#define _foAspectIsVoidType(...) metamacro_if_eq(metamacro_argcount(__VA_ARGS__),2)
#define foAspectIsVoidType(TYPE) _foAspectIsVoidType(foAspecttype_ ## TYPE )


#define addBlockWithUUIDMethod1 addBeforeBlockWithUUID
#define addBlockWithUUIDMethod0 addAfterBlockWithUUID


// typeEncoding
#define foAspect_blockParamTypeEncodePlaceHolder(INDEX,VALUE)                                                                   \
        @"%s"

#define foAspect_blockParamTypeEncodeGetTypeParam(TYPE)                                                                         \
        TYPE ,

#define foAspect_blockParamTypeEncodeGetType(...)                                                                               \
        ,@encode(metamacro_head(__VA_ARGS__))

#define foAspect_blockParamTypeEncodeVar(INDEX,VALUE)                                                                           \
        foAspect_blockParamTypeEncodeGetType(foAspect_blockParamTypeEncodeGetTypeParam VALUE)

// returnValue macros
#define foAspect_initReturnValue(TYPE)                                                                                          \
        foAspectIsVoidType(TYPE)                                                                                                \
        ()                                                                                                                      \
        (TYPE originReturnValue; memset(&originReturnValue, 0, sizeof(TYPE));)                                                  \

#define foAspect_setReturnValue(TYPE)                                                                                           \
        foAspectIsVoidType(TYPE)                                                                                                \
        ()                                                                                                                      \
        (originReturnValue = )                                                                                                  \

#define foAspect_returnReturnValue(TYPE)                                                                                        \
        foAspectIsVoidType(TYPE)                                                                                                \
        (return ;)                                                                                                              \
        (return originReturnValue;)                                                                                             \

// common param macros
#define foAspect_foreachParam(paramMacro,...)                                                                                   \
        metamacro_if_eq(1,metamacro_argcount(__VA_ARGS__))                                                                      \
        ()                                                                                                                      \
        (metamacro_foreach(paramMacro,, metamacro_tail(__VA_ARGS__)))                                                           \

// param template block define macros
#define foAspect_templateParamDefineMacro_(TYPE) TYPE                                                                           \

#define foAspect_templateParamDefineMacro(INDEX,VALUE)                                                                          \
        , foAspect_templateParamDefineMacro_ VALUE                                                                              \

// param template block call macros
#define foAspect_templateParamCallMacro_(TYPE)                                                                                  \

#define foAspect_templateParamCallMacro(INDEX,VALUE)                                                                            \
        , foAspect_templateParamCallMacro_ VALUE                                                                                \

// user block returnvalue define macros
// before-blocks
#define foAspect_returnTypeDefineInParams1(TYPE)                                                                                \
        foAspectIsVoidType(TYPE)                                                                                                \
        (, BOOL * p_shouldEarlyReturn)                                                                                          \
        (, BOOL * p_shouldEarlyReturn, TYPE *p_originReturnValue, TYPE originReturnValue)                                       \

// after-blocks
#define foAspect_returnTypeDefineInParams0(TYPE)                                                                                \
        foAspectIsVoidType(TYPE)                                                                                                \
        ()                                                                                                                      \
        (,TYPE *p_originReturnValue , TYPE originReturnValue)                                                                   \

// user block returnvalue call macros
// before-block
#define foAspect_returnTypeCallParams1(TYPE)                                                                                    \
        foAspectIsVoidType(TYPE)                                                                                                \
        (,&shouldEarlyReturn)                                                                                                   \
        (,&shouldEarlyReturn,&originReturnValue,originReturnValue)                                                              \

// after-block
// after-block doesn't need an early-return flag, because origin method is already called, and all after-blocks are not in order
#define foAspect_returnTypeCallParams0(TYPE)                                                                                    \
        foAspectIsVoidType(TYPE)                                                                                                \
        ()                                                                                                                      \
        (,&originReturnValue,originReturnValue)                                                                                 \

// user block param define macros
#define foAspect_blockParamDefinePointVarMacro_(...)                                                                            \
        metamacro_head(__VA_ARGS__)                                                                                             \
        metamacro_concat(metamacro_head(metamacro_tail(__VA_ARGS__)),                                                           \
                         metamacro_head(metamacro_tail(metamacro_tail(__VA_ARGS__)))   )

#define foAspect_blockParamDefinePointTypeMacro_(TYPE)                                                                          \
        TYPE *,p_,

#define foAspect_blockParamDefineVarMacro_(TYPE)                                                                                \
        TYPE

#define foAspect_blockParamDefineMacro1(INDEX,VALUE)                                                                            \
        , foAspect_blockParamDefinePointVarMacro_(foAspect_blockParamDefinePointTypeMacro_ VALUE)                               \
        , foAspect_blockParamDefineVarMacro_ VALUE                                                                              \

#define foAspect_blockParamDefineMacro0(INDEX,VALUE)                                                                            \
        , foAspect_blockParamDefineVarMacro_ VALUE                                                                              \

// user block param call macros
#define foAspect_blockParamCallPointMacro_(TYPE)                                                                                \
        , &

#define foAspect_blockParamCallVarMacro_(TYPE)                                                                                  \
        ,

#define foAspect_blockParamCallMacro1(INDEX,VALUE)                                                                              \
        foAspect_blockParamCallPointMacro_  VALUE foAspect_blockParamCallVarMacro_ VALUE

#define foAspect_blockParamCallMacro0(INDEX,VALUE)                                                                              \
        foAspect_blockParamCallVarMacro_ VALUE


// main macro
#define _foAspectWithSeletor(ADDMETHOD,ISBEFOREBLOCK,RETURNTYPE, ...)                                                           \
    /*this line for handle remove token */                                                                                      \
    _foAspectSelector : metamacro_head(__VA_ARGS__)                                                                             \
         canAddMethod : ADDMETHOD != 0                                                                                          \
        isBeforeBlock : ISBEFOREBLOCK != 0                                                                                      \
templateCreateorBlock : ^id(Class classObject ,                                                                                 \
                            Class superClassObject,                                                                             \
                            SEL sel,                                                                                            \
                            SEL classSEL ,                                                                                      \
                            SEL instanceSEL,                                                                                    \
                            IMP oldIMP,                                                                                         \
                            NSString **outTypeEncoding)                                                                         \
    {                                                                                                                           \
        if (outTypeEncoding)                                                                                                    \
        {                                                                                                                       \
            *outTypeEncoding =                                                                                                  \
            [[NSString alloc] initWithFormat:@"%s"@"%s"@"%s"                                                                    \
                                              foAspect_foreachParam(foAspect_blockParamTypeEncodePlaceHolder,__VA_ARGS__)       \
                                             ,@encode(RETURNTYPE)/* return type */                                              \
                                             ,@encode(id)        /* self */                                                     \
                                             ,@encode(SEL)       /* _cmd */                                                     \
                                              foAspect_foreachParam(foAspect_blockParamTypeEncodeVar , __VA_ARGS__) ];          \
        }                                                                                                                       \
        /* create template block */                                                                                             \
        return ^RETURNTYPE (__unsafe_unretained id originInstance  foAspect_foreachParam(foAspect_templateParamDefineMacro,__VA_ARGS__))    \
        {                                                                                                                       \
            BOOL canRunBlock = foCheckTemplateCanRunBlock(classObject,                                                          \
                                                          originInstance,                                                       \
                                                          classSEL);                                                            \
            foAspectItem *item = nil;                                                                                           \
            if (canRunBlock)                                                                                                    \
            {                                                                                                                   \
                @autoreleasepool {                                                                                              \
                    item = objc_getAssociatedObject(originInstance, instanceSEL);                                               \
                }                                                                                                               \
            }                                                                                                                   \
                                                                                                                                \
            BOOL shouldEarlyReturn = NO;                                                                                        \
            foAspect_initReturnValue(RETURNTYPE)                                                                                \
                                                                                                                                \
            /* call before blocks */                                                                                            \
            typedef void (^beforeBlockType)(id originInstance                                                                   \
                                            foAspect_returnTypeDefineInParams1 (RETURNTYPE)                                     \
                                            foAspect_foreachParam (foAspect_blockParamDefineMacro1  , __VA_ARGS__));            \
            if (item && item->beforeBlock)                                                                                      \
            {                                                                                                                   \
                for (beforeBlockType block in item->beforeBlock.objectEnumerator)                                               \
                {                                                                                                               \
                    block(originInstance                                                                                        \
                          foAspect_returnTypeCallParams1(RETURNTYPE)                                                            \
                          foAspect_foreachParam(foAspect_blockParamCallMacro1,__VA_ARGS__));                                    \
                    if (shouldEarlyReturn)                                                                                      \
                    {                                                                                                           \
                        foAspect_returnReturnValue(RETURNTYPE)                                                                  \
                    }                                                                                                           \
                }                                                                                                               \
            }                                                                                                                   \
                                                                                                                                \
            /* orgin imp init */                                                                                                \
            RETURNTYPE(*calledIMP)(id,SEL foAspect_foreachParam(foAspect_templateParamDefineMacro,__VA_ARGS__)) = nil;          \
                                                                                                                                \
            /* call the old imp at first */                                                                                     \
            if (oldIMP)                                                                                                         \
            {                                                                                                                   \
                calledIMP = (void*)oldIMP;                                                                                      \
            }                                                                                                                   \
                                                                                                                                \
            /*  call the super secondly                                                                                         \
                class_getMethodImplementation_stret is different to class_getMethodImplementation when forwards imp             \
                when class_respondsToSelector returns YES, it can't be forwarded                                                \
                if used aspect, the aspect will set the right forward imp */                                                    \
            else if (class_respondsToSelector(superClassObject, sel))                                                           \
            {                                                                                                                   \
                calledIMP = (void*)class_getMethodImplementation(superClassObject, sel);                                        \
            }/* else nothing */                                                                                                 \
            /* call it ! */                                                                                                     \
            if (calledIMP)                                                                                                      \
            {                                                                                                                   \
                foAspect_setReturnValue(RETURNTYPE)                                                                             \
                calledIMP(originInstance,                                                                                       \
                          sel                                                                                                   \
                          foAspect_foreachParam (foAspect_templateParamCallMacro ,__VA_ARGS__));                                \
            }                                                                                                                   \
            /* call after blocks */                                                                                             \
            typedef void (^afterBlockType)(id originInstance                                                                    \
                                           foAspect_returnTypeDefineInParams0 (RETURNTYPE)                                      \
                                           foAspect_foreachParam (foAspect_blockParamDefineMacro0  , __VA_ARGS__));             \
            if (item && item->afterBlock)                                                                                       \
            {                                                                                                                   \
                for (afterBlockType block in item->afterBlock.objectEnumerator)                                                 \
                {                                                                                                               \
                    block(originInstance                                                                                        \
                          foAspect_returnTypeCallParams0(RETURNTYPE)                                                            \
                          foAspect_foreachParam(foAspect_blockParamCallMacro0,__VA_ARGS__));                                    \
                }                                                                                                               \
            }                                                                                                                   \
            foAspect_returnReturnValue(RETURNTYPE)                                                                              \
        };                                                                                                                      \
    }                                                                                                                           \
            userBlock : ^void(__unsafe_unretained id originInstance                                                             \
                              foAspect_returnTypeDefineInParams ## ISBEFOREBLOCK (RETURNTYPE)                                   \
                              foAspect_foreachParam (foAspect_blockParamDefineMacro ## ISBEFOREBLOCK  , __VA_ARGS__))

#define foAspectAfterSeletorNoAddMethod(RETURNTYPE, ...)  _foAspectWithSeletor(0 , 0 , RETURNTYPE ,  __VA_ARGS__ )
#define foAspectAfterSeletor(RETURNTYPE, ...)             _foAspectWithSeletor(1 , 0 , RETURNTYPE ,  __VA_ARGS__ )
#define foAspectBeforeSeletorNoAddMethod(RETURNTYPE, ...) _foAspectWithSeletor(0 , 1 , RETURNTYPE ,  __VA_ARGS__ )
#define foAspectBeforeSeletor(RETURNTYPE, ...)            _foAspectWithSeletor(1 , 1 , RETURNTYPE ,  __VA_ARGS__ )




