//
//  FoWeakObjectShell.m
//
//  Created by Fover0 on 15/8/16.
//

#import "Upgrade-base/2x/HookBase/FoWeakObjectShell.h"

@implementation FoWeakObjectShell

+ (FoWeakObjectShell *)weakObject:(id)obj
{
    FoWeakObjectShell * ret = [[FoWeakObjectShell alloc] init];
    ret.obj = obj;
    return ret;
}

@end
