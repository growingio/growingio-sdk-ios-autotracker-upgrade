//
//  GrowingAlertMenu.h
//  Growing
//
//  Created by 陈曦 on 15/11/7.
//  Copyright © 2015年 GrowingIO. All rights reserved.
//

#import "GrowingMenuView.h"

@interface GrowingAlertMenu : GrowingMenuView

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *text2;

+ (instancetype)alertWithTitle:(NSString*)title
                          text:(NSString*)text
                       buttons:(NSArray<GrowingMenuButton*>*)buttons;

+ (instancetype)alertWithTitle:(NSString *)title
                         text1:(NSString *)text1
                         text2:(NSString *)text2
                       buttons:(NSArray<GrowingMenuButton *> *)buttons;

+ (instancetype)alertOnlyText:(NSString*)text
                      buttons:(NSArray<GrowingMenuButton*>*)buttons;

+ (instancetype)alertWithActionArray:(NSArray*)action
                              config:(void(^)(GrowingAlertMenu*))configBlock;

@end
