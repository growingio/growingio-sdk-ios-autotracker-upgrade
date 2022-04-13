//
//  GrowingCategory.h
//  Growing
//
//  Created by 陈曦 on 16/12/7.
//  Copyright © 2016年 GrowingIO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "Upgrade-base/2x/HookBase/metamacros.h"

// 嵌套遍历宏 检查混淆
#if DEBUG

    #define GrowingCategoryCheckName(originClass,classNameString) \
               if(![@#originClass isEqualToString:classNameString])\
               {\
                    NSLog(@"%@与%@不匹配",@#originClass,classNameString);\
                    assert(0);\
               }

#else

    #define GrowingCategoryCheckName(originClass,classNameString)

#endif



#define GrowingCategoryBindCheckName(index,var) \
            GrowingCategoryCheckName  var



// 嵌套遍历宏 添加类
#define GrowingCategoryCreateClassArrayItem(originName,fakeName)    \
            {                                                       \
                Class clazz = NSClassFromString(fakeName);          \
                if (clazz)                                          \
                {                                                   \
                    [classes addObject:clazz];                      \
                }                                                   \
            }                                                       \


#define GrowingCategoryCreateClassArray(index,var) \
            GrowingCategoryCreateClassArrayItem var

// 宏主体
#define GrowingCategory(CategoryName , ...)                                         \
            CategoryName : NSObject                                                 \
            @end                                                                    \
            @implementation CategoryName                                            \
            + (void)load                                                            \
            {                                                                       \
                metamacro_foreach(GrowingCategoryBindCheckName, ,__VA_ARGS__ )      \
                unsigned int count = 0;                                             \
                Method *methods = class_copyMethodList(self, &count);               \
                NSMutableArray *classes = [[NSMutableArray alloc] init];            \
                metamacro_foreach(GrowingCategoryCreateClassArray , , __VA_ARGS__)  \
                for (unsigned int i = 0 ; i < count ; i++)                          \
                {                                                                   \
                    Method method = methods[i];                                     \
                    for (Class clazz in classes)                                    \
                    {                                                               \
                        class_addMethod(clazz,                                      \
                                        method_getName(method),                     \
                                        method_getImplementation(method),           \
                                        method_getTypeEncoding(method));            \
                    }                                                               \
                }                                                                   \
                free(methods);                                                      \
            }                                                                       \
