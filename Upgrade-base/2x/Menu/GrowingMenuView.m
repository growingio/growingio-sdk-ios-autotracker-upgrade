//
//  GrowingMenuView.m
//  Growing
//
//  Created by 陈曦 on 15/11/6.
//  Copyright © 2015年 GrowingIO. All rights reserved.
//

#import "Upgrade-base/2x/Menu/GrowingMenuView.h"
#import "Upgrade-base/2x/UIView+GrowingHelperLayout.h"
#import "Upgrade-base/2x/GrowingUIConfig.h"
#import "Upgrade-base/Public/GrowingInstance.h"

#import "GrowingTrackerCore/Helpers/UIControl+GrowingHelper.h"
#import "GrowingTrackerCore/Utils/GrowingTimeUtil.h"

@interface GrowingMenuButton()
@property (nonatomic, weak) GrowingMenuView *hostView;
@property (nonatomic, retain) UIView* customView;
@end

@interface GrowingMenuView()

@property (nonatomic, assign) CGSize maxSize;

@property (nonatomic, retain) UIScrollView *scrollView;
// views
@property (nonatomic, retain) UIView *leftButtonView;
@property (nonatomic, retain) UIView *rightButtonView;

@property (nonatomic, assign) CGFloat menuButtonsHeight;
@property (nonatomic, retain) NSMutableArray<UIButton *> * menuButtonViews;

@property (nonatomic, assign) BOOL buildContentFinish;

- (void)updateButton:(GrowingMenuButton *)button;

@end

@implementation GrowingMenuPageView

- (void)show
{
    self.showTime = @([GrowingTimeUtil currentTimeMillis]);
    if (!self.createTime)
    {
        self.createTime = self.showTime;
    }
    [super show];
}

- (NSString*)growingViewContent
{
    return NSStringFromClass(self.class);
}

@end

@implementation GrowingMenuButton

+ (instancetype)buttonWithCustomView:(UIView *)customView
{
    GrowingMenuButton *btn = [[self alloc] init];
    btn.userInteractionEnabled = YES;
    btn.customView = customView;
    return btn;
}

+ (instancetype)buttonWithTitle:(NSString *)title block:(void (^)(void))block
{
    GrowingMenuButton *btn = [[self alloc] init];
    btn.title = title;
    btn.block = block;
    btn.userInteractionEnabled = YES;
    
    return btn;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    if (self.hostView != nil)
    {
        [self.hostView updateButton:self];
    }
}

- (void)setAttrTitle:(NSAttributedString *)attrTitle
{
    _attrTitle = attrTitle;
    if (self.hostView != nil)
    {
        [self.hostView updateButton:self];
    }
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    _userInteractionEnabled = userInteractionEnabled;
    if (self.hostView != nil)
    {
        [self.hostView updateButton:self];
    }
}

- (void)setBlock:(void (^)(void))block
{
    _block = block;
    if (self.hostView != nil)
    {
        [self.hostView updateButton:self];
    }
}

@end

#define NavigationBarHeight 50

@implementation GrowingMenuView

- (void)setActive:(BOOL)active
{
    if (_active == active)
    {
        return;
    }
    _active = active;
    if (!self.shadowMaskView)
    {
        self.shadowMaskView = [[UIView alloc] initWithFrame:self.bounds];
        self.shadowMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.shadowMaskView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.shadowMaskView];
    }
    [self bringSubviewToFront:self.shadowMaskView];
    if (active)
    {
        self.shadowMaskView.alpha = 0;
    }
    else
    {
        self.shadowMaskView.alpha = 1;
    }
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(99999, 99999);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithType:GrowingMenuShowTypeAlert];
}

- (instancetype)initWithType:(GrowingMenuShowType)showType
{
    CGRect frame = [UIScreen mainScreen].bounds;
    CGSize maxSize = [GrowingMenu maxSizeForType:showType];
    frame.origin.x = (frame.size.width - maxSize.width) / 2;
    frame.origin.y = (frame.size.height - maxSize.height) / 2;
    frame.size = maxSize;
    
    self = [super initWithFrame:frame];
    if (self)
    {
        _showType = showType;
        self.maxSize = maxSize;
        self.backgroundColor = [UIColor whiteColor];
        self.menuButtonViews = [[NSMutableArray alloc] init];
        self.navigationBarColor = [GrowingUIConfig mainColor];
        self.titleColor = [GrowingUIConfig titleColor];
    }
    return self;
}

- (void)setNeedResizeAndLayout
{
    if (!self.isViewLoaded)
    {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(resizeAndLayout)
                                               object:nil];
    [self performSelector:@selector(resizeAndLayout)
               withObject:nil
               afterDelay:0];
}

- (void)resizeAndLayout
{
    CGRect frame = [UIScreen mainScreen].bounds;
    CGSize maxSize = [GrowingMenu maxSizeForType:self.showType];
    frame.origin.x = (frame.size.width - maxSize.width) / 2;
    frame.origin.y = (frame.size.height - maxSize.height) / 2;
    frame.size = maxSize;
    self.maxSize = maxSize;
    
    CGFloat contentViewY = 0;
    CGRect navigationBarFrame = self.navigationView.frame;
    navigationBarFrame.size.width = self.maxSize.width;
    if (self.navigationBarHidden)
    {
        navigationBarFrame.origin.y = - NavigationBarHeight;
    }
    else
    {
        navigationBarFrame.origin.y = 0;
        contentViewY = NavigationBarHeight;
    }
    self.navigationView.frame = navigationBarFrame;
    
    
    CGFloat preferHeight = [self preferredContentHeight];
    CGFloat selfHeight = 0;
    if (self.showType == GrowingMenuShowTypePresent)
    {
        selfHeight = self.maxSize.height;
    }
    else
    {
        selfHeight = MIN(self.maxSize.height,
                         [self preferredContentHeight]
                         + contentViewY
                         + self.menuButtonsHeight);
    }
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.frame = CGRectMake((screenSize.width - self.maxSize.width) / 2,
                            (screenSize.height - selfHeight) / 2,
                            self.maxSize.width,
                            selfHeight);
    
    CGFloat contentHeight = selfHeight - contentViewY - self.menuButtonsHeight;
    
    self.scrollView.frame = CGRectMake(0,
                                 contentViewY,
                                 self.bounds.size.width,
                                 contentHeight);
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, preferHeight);
    
    self.view.frame = CGRectMake(0,0,self.scrollView.contentSize.width,self.scrollView.contentSize.height);
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [self resizeAndLayout];
    
    [self sendSubviewToBack:self.scrollView];
    [self bringSubviewToFront:self.navigationView];
    [self bringSubviewToFront:self.shadowMaskView];
    [super layoutSubviews];
}

- (void)setNavigationBarColor:(UIColor *)navigationBarColor
{
    _navigationBarColor = navigationBarColor;
    self.navigationView.backgroundColor = [navigationBarColor colorWithAlpha:0.9 backgroundColor:[UIColor blackColor]];
}

- (void)loadView
{
    // 导航
    UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width,NavigationBarHeight)];
    navBar.backgroundColor = self.navigationBarColor;
    [self addSubview:navBar];
    self.navigationView = navBar;
    
    
    
    // title
    self.titleLabel =
    [navBar growAddLabelWithFontSize:20
                               color:self.titleColor
                               lines:1
                                text:nil
                               block:^(MASG3ConstraintMaker *make, UILabel *lable) {
                                   make.centerX.masG3_equalTo(navBar.masG3_centerX);
                                   make.centerY.masG3_equalTo(navBar.masG3_centerY);
                               }];
    
    // 按钮
    NSArray<GrowingMenuButton*> *buttons = [self menuButtons];
    
    // 容器
    //fix ios7 crash  fuck!!!!!
    CGFloat buttonHeight = 0;
    if (buttons.count == 0)
    {
        
    }
    else if (buttons.count <= 2)
    {
        buttonHeight = NavigationBarHeight;
    }
    else
    {
        buttonHeight = NavigationBarHeight * buttons.count;
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.alwaysBounceVertical = self.alwaysBounceVertical;
    [self addSubview:self.scrollView];
    
    self.view = [[UIView alloc] initWithFrame:self.bounds];
    [self.scrollView addSubview:self.view];

    // 按钮
    CGFloat addHeight = 0;
    if (buttons.count == 0)
    {
        // do nothing
    }
    else if (buttons.count <= 2)
    {
        CGFloat percent = 1.0f / buttons.count;
        __block UIButton *lastBtn = nil;
        for (int i = 0 ; i < buttons.count; i++)
        {
            GrowingMenuButton *btnObj = buttons[i];
            btnObj.hostView = self;
            UIButton *btn =
            [self growAddButtonWithTitle:btnObj.title
                                   color:i==1?[GrowingUIConfig redColor]:[UIColor grayColor]
                                 onClick:btnObj.block
                                   block:^(MASG3ConstraintMaker *make, UIButton *button) {
                                       if (!lastBtn)
                                       {
                                           make.left.masG3_equalTo(0);
                                       }
                                       else
                                       {
                                           make.left.masG3_equalTo(lastBtn.masG3_right);
                                       }
                                       
                                       if  (i == buttons.count - 1)
                                       {
                                           make.right.masG3_equalTo(self.masG3_right);
                                       }
                                       else
                                       {
                                           make.width.masG3_equalTo(self.masG3_width).multipliedBy(percent);
                                       }
                                       make.bottom.masG3_equalTo(self.masG3_bottom);
                                       make.height.masG3_equalTo(NavigationBarHeight);

                                       button.userInteractionEnabled = btnObj.userInteractionEnabled;
                                       button.enabled = btnObj.userInteractionEnabled;
                                       button.backgroundColor = [UIColor whiteColor];
                                   }];
            [self.menuButtonViews addObject:btn];
            lastBtn = btn;
            
            [btn growAddViewWithColor:[[UIColor grayColor] colorWithAlphaComponent:0.3]
                                block:^(MASG3ConstraintMaker *make, UIView *view) {
                                    make.left.offset(0);
                                    make.width.masG3_equalTo(btn.masG3_width);
                                    make.height.offset(1);
                                    make.top.offset(0);
                                }];
//            btn.growingHelper_onClick = ^{
//                [UIView  animateWithDuration:0.3
//                                  animations:^{
//                                      self.navigationBarHidden = !self.navigationBarHidden;
//                                  }];
//                
//            };
            if (i != 0)
            {
                [btn growAddViewWithColor:[[UIColor grayColor] colorWithAlphaComponent:0.3]
                                    block:^(MASG3ConstraintMaker *make, UIView *view) {
                                        make.left.offset(0);
                                        make.top.offset(0);
                                        make.width.offset(1);
                                        make.height.masG3_equalTo(btn.masG3_height);
                                    }];
            }
        }
        addHeight = NavigationBarHeight;
    }
    else
    {
        for (NSUInteger i = 0 ; i < buttons.count ; i++)
        {
            GrowingMenuButton *btnObj = buttons[i];
            btnObj.hostView = self;
            UIButton *btn =
            [self growAddButtonWithTitle:btnObj.title
                                   color:[UIColor grayColor]
                                 onClick:btnObj.block
                                   block:^(MASG3ConstraintMaker *make, UIButton *button) {
                                       make.left.offset(0);
                                       make.right.offset(0);
                                       make.bottom.offset(-1 * (CGFloat)(buttons.count - 1 - i) * NavigationBarHeight);
                                       make.height.offset(NavigationBarHeight);
                                       if (i == 0)
                                       {
                                           make.top.masG3_equalTo(self.view.masG3_bottom);
                                       }
                                       button.userInteractionEnabled = btnObj.userInteractionEnabled;
                                       button.enabled = btnObj.userInteractionEnabled;
                                   }];
            [btn growAddViewWithColor:[GrowingUIConfig sublineColor]
                                 block:^(MASG3ConstraintMaker *make, UIView *view) {
                                     make.left.offset(0);
                                     make.right.offset(0);
                                     make.top.offset(0);
                                     make.height.offset(1);
                                 }];
            [self.menuButtonViews addObject:btn];
        }
        addHeight = buttons.count * NavigationBarHeight;
    }
    self.menuButtonsHeight = addHeight;

    [self updateTitleButton:YES];
    [self updateTitleButton:NO];
    self.title = self.title;
    [self resizeAndLayout];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    self.titleLabel.text = title;
}

- (void)viewDidLoad
{
    // do nothing
}

- (UIView*)view
{
    if (!_view)
    {
        [self loadView];
        if (_view)
        {
            [self viewDidLoad];
        }
    }
    return _view;
}

- (BOOL)isViewLoaded
{
    return _view != nil;
}

- (void)show
{
    [self showWithFinishBlock:nil];
}

- (void)showWithFinishBlock:(void (^)(void))block
{
//NSString *const UIKeyboardWillShowNotification;
//NSString *const UIKeyboardDidShowNotification;
//NSString *const UIKeyboardWillHideNotification;
//NSString *const UIKeyboardDidHideNotification;
//
//NSString *const UIKeyboardFrameBeginUserInfoKey
//NSString *const UIKeyboardFrameEndUserInfoKey         
//NSString *const UIKeyboardAnimationDurationUserInfoKey
//NSString *const UIKeyboardAnimationCurveUserInfoKey
//NSString *const UIKeyboardIsLocalUserInfoKey
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [GrowingMenu showMenuView:self showType:self.showType complate:block];
    
    
}

- (void)keyboardDidShow:(NSNotification*)noti
{
    CGRect scrollViewRect = [self.scrollView.superview convertRect:self.scrollView.frame toView:self.scrollView.window];
    
    CGRect keyBoardFrame = [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat scrollViewBottom = scrollViewRect.origin.y + scrollViewRect.size.height;
    CGFloat keyBoardTop = keyBoardFrame.origin.y;
    
    if (scrollViewBottom > keyBoardTop)
    {
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.bottom = scrollViewBottom - keyBoardTop;
        self.scrollView.contentInset = inset;
        self.scrollView.scrollIndicatorInsets = inset;
    }
}

- (void)keyboardDidHide
{
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)hide
{
    [self hideWithFinishBlock:nil];
}

- (void)hideWithFinishBlock:(void (^)(void))block
{
    [self keyboardDidHide];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];


    [GrowingMenu hideMenuView:self showType:self.showType complate:block];
}

- (void)updateTitleButton:(BOOL)isLeft
{
    GrowingMenuButton *menuButton = isLeft ? self.leftButton : self.rightButton;
    UIView *btnView = isLeft ? self.leftButtonView : self.rightButtonView;
    
    if (self.isViewLoaded)
    {
        if (menuButton)
        {
            if (!btnView)
            {
                if (menuButton.customView)
                {
                    btnView = menuButton.customView;
                    [self.navigationView growAddSubviewInstance:menuButton.customView
                                           block:^(MASG3ConstraintMaker *make, id obj) {
                                               if (isLeft)
                                               {
                                                   make.left.offset(10);
                                               }
                                               else
                                               {
                                                   make.right.offset(-10);
                                               }
                                               make.width.masG3_equalTo(btnView.frame.size.width);
                                               make.height.masG3_equalTo(btnView.frame.size.height);
                                               make.centerY.masG3_equalTo(self.navigationView.masG3_centerY);
                                           }];
                }
                else
                {
                    btnView =
                    [self.navigationView growAddButtonWithTitle:menuButton.title
                                           color:self.titleColor
                                         onClick:nil
                                           block:^(MASG3ConstraintMaker *make, UIButton *button) {
                                               if (isLeft)
                                               {
                                                   make.left.offset(0);
                                               }
                                               else
                                               {
                                                   make.right.offset(0);
                                               }
                                               make.bottom.masG3_equalTo(self.navigationView.masG3_bottom);
                                               make.top.masG3_equalTo(self.navigationView.masG3_top);
                                               make.width.offset(60);
                                               [button setTitleColor:self.titleColor forState:0];
                                               [button setTitleColor:[GrowingUIConfig titleColorDisabled]
                                                            forState:UIControlStateDisabled];
                                               button.titleLabel.font = [UIFont systemFontOfSize:16];
                                       }];
                }
            }
            if (isLeft)
            {
                self.leftButtonView = btnView;
            }
            else
            {
                self.rightButtonView = btnView;
            }
            if (!menuButton.customView)
            {
                UIButton *button = (id)btnView;
                [button setTitle:menuButton.title forState:0];
                button .growingHelper_onClick = menuButton.block;
                button.enabled = menuButton.userInteractionEnabled;
                button.userInteractionEnabled = menuButton.userInteractionEnabled;
            }
        }
        else
        {
            if (btnView)
            {
                [btnView removeFromSuperview];
                if (isLeft)
                {
                    self.leftButtonView = nil;
                }
                else
                {
                    self.rightButtonView = nil;
                }
            }
        }
    }
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
    if (_navigationBarHidden == navigationBarHidden)
    {
        return;
    }
    _navigationBarHidden = navigationBarHidden;
    [self setNeedResizeAndLayout];
}

- (void)setLeftButton:(GrowingMenuButton *)leftButton
{
    if (_leftButton != nil)
    {
        _leftButton.hostView = nil;
    }
    _leftButton = leftButton;
    _leftButton.hostView = self;
    [self updateTitleButton:YES];
}

- (void)setRightButton:(GrowingMenuButton *)rightButton
{
    if (_rightButton != nil)
    {
        _rightButton.hostView = nil;
    }
    _rightButton = rightButton;
    _rightButton.hostView = self;
    [self updateTitleButton:NO];
}

- (void)setAlwaysBounceVertical:(BOOL)alwaysBounceVertical
{
    _alwaysBounceVertical = alwaysBounceVertical;
    self.scrollView.alwaysBounceVertical = alwaysBounceVertical;
}

- (void)setPreferredContentHeight:(CGFloat)preferredContentHeight
{
    CGFloat diff = _preferredContentHeight - preferredContentHeight ;
    if (ABS(diff) < 0.01)
    {
        return;
    }
    _preferredContentHeight = preferredContentHeight;
    [self setNeedResizeAndLayout];
}

- (void)updateButton:(GrowingMenuButton *)button
{
    if (button.hostView == nil)
    {
        return;
    }
    if (self.leftButton == button || self.rightButton == button)
    {
        [self updateTitleButton:(self.leftButton == button)];
        return;
    }
    for (NSUInteger i = 0; i < self.menuButtons.count; i++)
    {
        if (self.menuButtons[i] == button)
        {
            if (i < self.menuButtonViews.count)
            {
                UIButton * btn = self.menuButtonViews[i];
                [btn setTitle:button.title forState:0];
                btn.userInteractionEnabled = button.userInteractionEnabled;
                
                if ( btn.enabled != button.userInteractionEnabled)
                {
                    btn.enabled = button.userInteractionEnabled;
                    if (btn.enabled)
                    {
                        btn.backgroundColor = [UIColor clearColor];
                        [btn setTitleColor:[UIColor grayColor] forState:0];
                    }
                    else
                    {
                        btn.backgroundColor = [UIColor grayColor];
                        [btn setTitleColor:[UIColor whiteColor] forState:0];
                    }
                }
                btn.growingHelper_onClick = button.block;
            }
            return;
        }
    }
}

@end



