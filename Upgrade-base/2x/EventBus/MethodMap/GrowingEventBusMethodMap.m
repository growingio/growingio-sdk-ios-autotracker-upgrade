#import "GrowingEventBusMethodMap.h"

@implementation GrowingEventBusMethodMap
+ (NSDictionary *)methodMap
{

   return @{@"GrowingEBMonitorEvent": @[@"GrowingMonitorKit/1/monitorStateUpdatedEvent:"],
            @"GrowingEBManualTrackEvent": @[@"GrowingTouchCoreKitTrackEvent/1/manualTrackEvent:", @"GrowingTouchPopupManager/1/manualTrackEvent:"],
            @"GrowingTouchPopupKitEvent": @[@"GrowingTouchPopupKitEventBus/1/receivedPopupKitEvent:"], @"GrowingEBUserIdEvent": @[@"GrowingPushManager/1/setUserIdEvent:", @"GrowingTouchPopupManager/1/setUserIdEvent:"],
            @"GrowingPushKitEvent": @[@"GrowingPushKitEventBus/1/receivedPushKitEvent:"],
            @"GrowingEBTrackSelfEvent": @[@"GrowingTrackSelfManager/1/trackSelfEvent:"],
            @"GrowingEBVCLifeEvent": @[@"GrowingIMPTrack/1/viewControllerLifeEvent:"],
            @"GrowingTouchCoreStartEvent": @[@"GrowingPushManager/1/trackTouchCoreStartEvent:", @"GrowingTouchPopupManager/1/trackTouchCoreStartEvent:"],
            @"GrowingEBApplicationEvent": @[@"GrowingPushManager/1/trackAppdelegateEvent:", @"GrowingTouchPopupManager/1/applicationEvent:", @"GrowingMobileDebugger/1/didfinishLauching:", @"GrowingInstance/1/didfinishLauching:", @"GrowingIMPTrack/1/applicationEvent:"]};
}

@end
