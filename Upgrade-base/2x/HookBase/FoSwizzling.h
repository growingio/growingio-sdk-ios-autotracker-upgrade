//
//  FoSwizzling.h
//
//  Created by Fover0 on 15/8/14.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "Upgrade-base/2x/HookBase/metamacros.h"

//#ifdef DEBUG
//    #define fo_check_hook_function(theSEL,COUNT) _fo_check_hook_function(theSEL,COUNT)
//#else
    #define fo_check_hook_function(theSEL,COUNT)
//#endif

// 调用原始函数 
#define FoHookOrgin(...)                                                                                    \
            __fo_hook_function                                                                            \
            ?__fo_hook_function(self,_cmd,##__VA_ARGS__)                                                  \
            :((typeof(__fo_hook_function))(class_getMethodImplementation(__foHookSuperClass,__foHookSel)))(self,_cmd,##__VA_ARGS__)                                                                        \
// -----------------------------------------------------------------------------------------------

#define FoHookSuper(...)                                                                                    \
            ((typeof(__fo_hook_function))(class_getMethodImplementation(__foHookSuperClass,__foHookSel)))(self,_cmd,##__VA_ARGS__)                                                                         \
//-----------------------------------------------------------------------------------------------

// 生成真实调用函数
#define __FoHookInstance(theCFunctionName,                                                                      \
                         theSelfType,                                                                           \
                         theClass,                                                                              \
                         theSuperClass,                                                                         \
                         theSEL,                                                                                \
                         theSectionName,                                                                        \
                         theRetType,...)                                                                        \
    static theRetType (metamacro_concat_(*old , theCFunctionName))(theSelfType self,SEL _cmd,##__VA_ARGS__);    \
    static theRetType metamacro_concat_(new ,theCFunctionName)    (theSelfType self,SEL _cmd,##__VA_ARGS__);    \
    @interface NSNull(metamacro_concat_(fosetup__ ,theCFunctionName)) @end                                      \
    @implementation NSNull(metamacro_concat_(fosetup__ ,theCFunctionName))                                      \
    + (void)load                                                                                                \
    {                                                                                                           \
        fo_check_hook_function(theSEL, metamacro_argcount(1,##__VA_ARGS__) -1);                                 \
        metamacro_concat_(old , theCFunctionName) = fo_imp_hook_function(theClass,                              \
                                                     theSEL,                                                    \
                                                     metamacro_concat_(new ,theCFunctionName));                 \
    }                                                                                                           \
    @end                                                                                                        \
    static theRetType metamacro_concat_(new ,theCFunctionName) (theSelfType self,SEL _cmd,##__VA_ARGS__)        \
    {                                                                                                           \
        __unused Class __foHookSuperClass = theSuperClass;                                                      \
        __unused SEL   __foHookSel  = theSEL;                                                                   \
        __unused theRetType (*__fo_hook_function)(theSelfType self,SEL _cmd,##__VA_ARGS__)                      \
                    = metamacro_concat_(old , theCFunctionName);
//-----------------------------------------------------------------------------------------------

#define FoHookInstance(theClass,theSEL,theRetType,...)                                                          \
        __FoHookInstance(metamacro_concat(__fo_function , __COUNTER__) ,                                        \
                         theClass*,                                                                             \
                         objc_getClass(#theClass),                                                              \
                         class_getSuperclass(objc_getClass(#theClass)),                                         \
                         theSEL,                                                                                \
                         __foHookInit,                                                                          \
                         theRetType,                                                                            \
                         ##__VA_ARGS__)                                                                         \

#define FoHookInstanceWithName(functionName,theClass,theSEL,theRetType,...)                                     \
        __FoHookInstance(functionName,                                                                          \
                         theClass*,                                                                             \
                         objc_getClass(#theClass),                                                              \
                         class_getSuperclass(objc_getClass(#theClass)),                                         \
                         theSEL,                                                                                \
                         __foHookInit,                                                                          \
                         theRetType,                                                                            \
                         ##__VA_ARGS__)                                                                         \
//-----------------------------------------------------------------------------------------------

#define FoHookInstancePlus(theClassName,selfType,theSEL,theRetType,...)                                         \
        __FoHookInstance(metamacro_concat(__fo_function , __COUNTER__) ,                                        \
                        selfType,                                                                               \
                        objc_getClass(theClassName),                                                            \
                        class_getSuperclass(objc_getClass(theClassName)),                                       \
                        theSEL,                                                                                 \
                        __foHookInit,                                                                           \
                        theRetType,                                                                             \
                        ##__VA_ARGS__)                                                                          \
//-----------------------------------------------------------------------------------------------

#define FoHookClass(theClass,theSEL,theRetType,...)                                                             \
        __FoHookInstance(metamacro_concat(__fo_function , __COUNTER__),                                         \
                         Class ,                                                                                \
                         object_getClass(objc_getClass(#theClass)),                                             \
                         object_getClass(class_getSuperclass(objc_getClass(#theClass))),                         \
                         theSEL,                                                                                \
                         __foHookInit,                                                                          \
                         theRetType,                                                                            \
                         ##__VA_ARGS__)                                                                         \
//-----------------------------------------------------------------------------------------------

#define FoHookEnd }

void* fo_imp_hook_function(Class clazz,
                    SEL   sel,
                    void  *newFunction);

BOOL _fo_check_hook_function(SEL sel,NSInteger paramCount);




