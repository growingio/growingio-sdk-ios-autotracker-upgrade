//
//  UIViewController+MASG3Additions.h
//  Masonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "MASG3Utilities.h"
#import "MASG3ConstraintMaker.h"
#import "MASG3ViewAttribute.h"

#ifdef MASG3_VIEW_CONTROLLER

@interface MASG3_VIEW_CONTROLLER (MASG3Additions)

/**
 *	following properties return a new MASG3ViewAttribute with appropriate UILayoutGuide and NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_topLayoutGuide;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_bottomLayoutGuide;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_topLayoutGuideTop;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_topLayoutGuideBottom;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_bottomLayoutGuideTop;
@property (nonatomic, strong, readonly) MASG3ViewAttribute *masG3_bottomLayoutGuideBottom;


@end

#endif
