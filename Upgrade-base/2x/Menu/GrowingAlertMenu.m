//
//  GrowingAlertMenu.m
//  Growing
//
//  Created by 陈曦 on 15/11/7.
//  Copyright © 2015年 GrowingIO. All rights reserved.
//

#import "GrowingAlertMenu.h"
#import "UIView+GrowingHelperLayout.h"
#import "GrowingUIConfig.h"

@interface GrowingAlertMenu()
@property (nonatomic, retain) NSArray<GrowingMenuButton*> *buttons;

@property (nonatomic, retain) UILabel *txtText;
@property (nonatomic, retain) UILabel *txtText2;
@end

@implementation GrowingAlertMenu

+ (instancetype)alertOnlyText:(NSString *)text buttons:(NSArray<GrowingMenuButton *> *)buttons
{
    return [self alertWithButtons:buttons
                      configBlock:^(GrowingAlertMenu *menu) {
                          menu.text = text;
                          menu.navigationBarHidden = YES;
                      }];
}

+ (instancetype)alertWithTitle:(NSString *)title text:(NSString *)text buttons:(NSArray<GrowingMenuButton *> *)buttons
{
    return [self alertWithButtons:buttons
                      configBlock:^(GrowingAlertMenu *menu) {
                          menu.title = title;
                          menu.text = text;
                      }];
}

+ (instancetype)alertWithTitle:(NSString *)title text1:(NSString *)text1 text2:(NSString *)text2 buttons:(NSArray<GrowingMenuButton *> *)buttons
{
    return [self alertWithButtons:buttons
                      configBlock:^(GrowingAlertMenu *menu) {
                          menu.title = title;
                          menu.text = text1;
                          menu.text2 = text2;
                      }];
}

+ (instancetype)alertWithActionArray:(NSArray *)action
                              config:(void (^)(GrowingAlertMenu *))configBlock
{
    NSMutableArray *btns = [[NSMutableArray alloc] init];
    for (NSInteger i = 1 ; i < action.count ; i += 2)
    {
        GrowingMenuButton *btn = [GrowingMenuButton buttonWithTitle:action[i-1]
                                                              block:action[i]];
        [btns addObject:btn];
    }

    return [self alertWithButtons:btns
                      configBlock:configBlock];
}

+ (instancetype)alertWithButtons:(NSArray<GrowingMenuButton *> *)buttons

                   configBlock:(void(^)(GrowingAlertMenu*))configBlock
{
    GrowingAlertMenu *menu = [[self alloc] init];
    menu.buttons = buttons;
    NSMutableArray *menubuttons = [[NSMutableArray alloc] init];
    __weak GrowingAlertMenu *wself = menu;
    for (GrowingMenuButton *btn in buttons)
    {
        void(^block)(void) = btn.block;
        GrowingMenuButton *newBtn = [GrowingMenuButton buttonWithTitle:btn.title
                                                                  block:^{
                                                                      GrowingAlertMenu *sself = wself;
                                                                      if (!sself)
                                                                      {
                                                                          return ;
                                                                      }
                                                                      if (block)
                                                                      {
                                                                          block();
                                                                      }
                                                                      [sself hide];
                                                                  }];
        [menubuttons addObject:newBtn];
    }
    menu.menuButtons = menubuttons;
    
    if (configBlock)
    {
        configBlock(menu);
    }
    
    [menu show];
    
    return menu;
}

- (instancetype)init
{
    return [self initWithType:GrowingMenuShowTypeAlert];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationView.backgroundColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.titleLabel.textColor = [UIColor blackColor];
    
    if (self.text2) {
        self.txtText =
        [self.view growAddLabelWithFontSize:18
                                      color:[GrowingUIConfig textColor]
                                      lines:1
                                       text:nil
                                      block:^(MASG3ConstraintMaker *make, UILabel *lable) {
                                          make.left.offset(20);
                                          make.right.offset(-20);
                                          make.top.offset(10);
                                          make.height.offset(50);
                                          
                                          lable.textAlignment = NSTextAlignmentLeft;
                                      }];
        if (self.text)
        {
            self.text = self.text;
        }
        self.txtText2 =
        [self.view growAddLabelWithFontSize:18
                                      color:[GrowingUIConfig textColor]
                                      lines:1
                                       text:nil
                                      block:^(MASG3ConstraintMaker *make, UILabel *lable) {
                                          make.left.offset(20);
                                          make.right.offset(-20);
                                          make.top.offset(50);
                                          make.height.offset(50);
                                          
                                          lable.textAlignment = NSTextAlignmentLeft;
                                      }];
        self.text2 = self.text2;
    } else {
        self.txtText =
        [self.view growAddLabelWithFontSize:18
                                      color:[GrowingUIConfig textColor]
                                      lines:0
                                       text:nil
                                      block:^(MASG3ConstraintMaker *make, UILabel *lable) {
                                          make.left.offset(20);
                                          make.right.offset(-20);
                                          make.top.offset(0);
                                          make.height.offset(100);
                                          
                                          lable.textAlignment = NSTextAlignmentLeft;
                                      }];
        if (self.text)
        {
            self.text = self.text;
        }
    }

    self.preferredContentHeight = 110;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.txtText.text = text;
}

- (void)setText2:(NSString *)text2
{
    _text2  = text2;
    self.txtText2.text = text2;
}

@end
