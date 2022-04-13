//
//  GrowingMenuView.h
//  Growing
//
//  Created by 陈曦 on 15/11/6.
//  Copyright © 2015年 GrowingIO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Upgrade-base/2x/Menu/GrowingMenu.h"

@class GrowingMenuView;

@interface GrowingMenuButton : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSAttributedString *attrTitle;
@property (nonatomic, assign) BOOL userInteractionEnabled;
@property (nonatomic, copy) void(^block)(void);

@property (nonatomic, retain, readonly) UIView* customView;

+ (instancetype)buttonWithTitle:(NSString*)title
                          block:(void(^)(void))block;
+ (instancetype)buttonWithCustomView:(UIView *)customView;


@end

@interface GrowingMenuView : UIView

@property (nonatomic, assign) BOOL active;

@property (nonatomic, retain) UIView *shadowMaskView;

@property (nonatomic, readonly) CGSize maxSize;

- (instancetype)initWithType:(GrowingMenuShowType)showType;
@property (nonatomic, readonly) GrowingMenuShowType showType;

@property (nonatomic, assign) BOOL alwaysBounceVertical;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) UIColor *navigationBarColor;
@property (nonatomic, retain) UIColor *titleColor;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, assign) BOOL navigationBarHidden;

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIView *navigationView;

// 顶部button
@property (nonatomic, retain) GrowingMenuButton *rightButton;
@property (nonatomic, retain) GrowingMenuButton *leftButton;

// 下面的button
@property (nonatomic, retain) NSArray<GrowingMenuButton*> *menuButtons;

@property (nonatomic, assign) CGFloat preferredContentHeight;

- (void)viewDidLoad;
- (BOOL)isViewLoaded;

- (void)resizeAndLayout; // 可以动画

- (void)show;
- (void)hide;

- (void)showWithFinishBlock:(void(^)(void))block;
- (void)hideWithFinishBlock:(void(^)(void))block;

@end

@interface GrowingMenuPageView : GrowingMenuView

@property (nonatomic, retain) NSNumber *showTime;
@property (nonatomic, retain) NSNumber *createTime;

@end
