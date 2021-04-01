//
//  GrowingHelperMenu.h
//  Growing
//
//  Created by 陈曦 on 16/2/23.
//  Copyright © 2016年 GrowingIO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GrowingMenuView.h"

@interface GrowingHelperMenu : GrowingMenuView

- (instancetype)initWithHelpView:(UIView*)view helpText:(NSString*)text;

@end
