//
//  UIViewController+MASG3Additions.m
//  Masonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "Upgrade-base/2x/Masonry/ViewController+MASG3Additions.h"

#ifdef MASG3_VIEW_CONTROLLER

@implementation MASG3_VIEW_CONTROLLER (MASG3Additions)

- (MASG3ViewAttribute *)masG3_topLayoutGuide {
    return [[MASG3ViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (MASG3ViewAttribute *)masG3_topLayoutGuideTop {
    return [[MASG3ViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (MASG3ViewAttribute *)masG3_topLayoutGuideBottom {
    return [[MASG3ViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}

- (MASG3ViewAttribute *)masG3_bottomLayoutGuide {
    return [[MASG3ViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (MASG3ViewAttribute *)masG3_bottomLayoutGuideTop {
    return [[MASG3ViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (MASG3ViewAttribute *)masG3_bottomLayoutGuideBottom {
    return [[MASG3ViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}



@end

#endif
