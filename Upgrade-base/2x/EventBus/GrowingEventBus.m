//
//  GrowingEventBus.m
//  GrowingCoreKit
//
//  Created by apple on 2019/4/20.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import "Upgrade-base/2x/EventBus/GrowingEventBus.h"
#import "Upgrade-base/2x/EventBus/Event/GrowingEBEvent.h"
#import "Upgrade-base/2x/GrowingMediator.h"
#import "Upgrade-base/2x/EventBus/MethodMap/GrowingEventBusMethodMap.h"

#import "GrowingTrackerCore/Thread/GrowingDispatchManager.h"

@implementation GrowingEventBus

+ (void)send:(GrowingEBEvent *)event
{
    if (!event) {
        return;
    }
    
    NSDictionary *methodMap = [GrowingEventBusMethodMap methodMap];
    NSString *eventClassName = NSStringFromClass([event class]);
    
    NSArray *methodArray = methodMap[eventClassName];
    if (methodArray.count == 0) {
        return;
    }
    
    for (NSString *methodString in methodArray) {
        NSArray *array = [methodString componentsSeparatedByString:@"/"];
        if (array.count != 3) {
            continue;
        }
        NSString *className = array[0];
        BOOL isClassMethod = [array[1] isEqualToString:@"1"] ? YES : NO;
        NSString *selString = array[2];
        
        if (isClassMethod) {
            [GrowingDispatchManager dispatchInMainThread:^{
                [[GrowingMediator sharedInstance] performClass:className action:selString params:@{@"0":event}];
            }];
        } else {
            [GrowingDispatchManager dispatchInMainThread:^{
                Class aclass = NSClassFromString(className);
                if (aclass) {
                    id instance = [[aclass alloc] init];
                    [[GrowingMediator sharedInstance] performTarget:instance action:selString params:@{@"0":event}];
                }
            }];
        }
    }
}

@end
