//
//  GrowSwizzling.m
//
//  Created by Fover0 on 15/8/14.
//

#import <objc/runtime.h>

#import "FoSwizzling.h"
#import <mach-o/getsect.h>
#import "GrowingLogger.h"

void* fo_imp_hook_function(Class clazz,
                    SEL   sel,
                    void  *newFunction)
{
    Method oldMethod = class_getInstanceMethod(clazz, sel);
    BOOL succeed = class_addMethod(clazz,
                                   sel,
                                   (IMP)newFunction,
                                   method_getTypeEncoding(oldMethod));
    if (succeed)
    {
        return nil;
    }
    else
    {
        return method_setImplementation(oldMethod, (IMP)newFunction);
    }
}

BOOL _fo_check_hook_function(SEL sel,NSInteger paramCount)
{
    BOOL succeed = (([NSStringFromSelector(sel) componentsSeparatedByString:@":"].count - 1) == paramCount);
    if (!succeed)
    {
        GIOLogError(@"参数错误");
        assert(0);
    }
    return succeed;
}
