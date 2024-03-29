//
//  GrowingMenu.m
//  Growing
//
//  Created by 陈曦 on 15/11/6.
//  Copyright © 2015年 GrowingIO. All rights reserved.
//

#import "Upgrade-base/2x/Menu/GrowingMenu.h"
#import "Upgrade-base/2x/Menu/GrowingMenuView.h"
#import "Upgrade-base/Public/GrowingInstance.h"
#import "Upgrade-base/2x/Masonry/MasonryGrowing3rd.h"
#import "Upgrade-base/2x/GrowingMediator.h"
#import "Upgrade-base/2x/UIView+GrowingHelperLayout.h"

@interface GrowingMenu()<UIGestureRecognizerDelegate>
@property (nonatomic, retain) NSMutableArray<GrowingMenuView*> *allViews;
@property (nonatomic, retain) NSMutableArray<NSNumber*> *allViewsType;
@property (nonatomic, retain) UIView *shadowMaskView;
@end

@implementation GrowingMenu

static GrowingMenu *showMenu = nil;

+ (void)showMenuView:(GrowingMenuView *)view showType:(GrowingMenuShowType)type complate:(void (^)(void))complate
{
    if (!showMenu)
    {
        showMenu = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
        showMenu.hidden = NO;
    }
    showMenu.frame = [UIScreen mainScreen].bounds;
    [showMenu showMenuView:view type:type complate:complate];
}

+ (void)showMenuView:(GrowingMenuView *)view showType:(GrowingMenuShowType)type
{
    [self showMenuView:view showType:type complate:nil];
}

+ (void)showMenuView:(GrowingMenuView *)view
{
    [self showMenuView:view showType:GrowingMenuShowTypeAlert];
}

+ (CGSize)maxSizeForType:(GrowingMenuShowType)type
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (GrowingMenuShowTypeAlert == type)
    {
        size.width -= 30;
        size.height -= 60;
    }
    return size;
}

- (void)showMenuView:(GrowingMenuView *)view type:(GrowingMenuShowType)type complate:(void (^)(void))complate
{
    if (!view || [self.allViews containsObject:view])
    {
        return;
    }
    [view view];
    
    view.userInteractionEnabled = YES;
    
    GrowingMenuView *lastView = self.allViews.lastObject;
    lastView.userInteractionEnabled = NO;
    
    
    void (^finishBlock)(void) = [complate copy];
    // 显示弹出Window
    if (self.allViews.count == 0)
    {
        [[GrowingMediator sharedInstance] performClass:@"GrowingLocalCircleWindow" action:@"increaseHiddenCount" params:nil];
        // view is the first view to show
        // enable user interaction and dismiss the keyboard if any
        self.userInteractionEnabled = YES;
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        [UIView animateWithDuration:0.1
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.shadowMaskView.alpha = 1;
                         }
                         completion:^(BOOL finished) {
                             if (finishBlock)
                             {
                                 finishBlock();
                             }
                         }];
    }
    
    // 添加view
    [self.allViews addObject:view];
    [self.allViewsType addObject:[NSNumber numberWithInteger:type]];
    
    view.alpha = 0;
    [self addSubview:view];
    [self bringSubviewToFront:view];
    
    // 配置view
    CGRect frame = view.frame;
    
    view.active = YES;
    if (type == GrowingMenuShowTypeAlert)
    {
        view.layer.cornerRadius = 4;
        view.clipsToBounds = YES;
        view.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.3].CGColor;
        view.layer.borderWidth = 1;
        
        // 动画
        [UIView animateWithDuration:0.3
                         animations:^{
                             view.alpha = 1;
                             [self setActive:NO WithoutView:view];
                         } completion:^(BOOL finished) {
                         }];
    }
    else
    {
        view.alpha = 1;
        view.layer.cornerRadius = 0;
        view.clipsToBounds = YES;
        view.layer.borderColor = nil;
        view.layer.borderWidth = 0;

        
        frame.origin.x = 0;
        frame.origin.y = self.bounds.size.height - frame.size.height;
        frame.size.width = self.bounds.size.width;
        
        
        CGRect beginFrame = frame;
        beginFrame.origin.y = self.bounds.size.height;
        view.frame = beginFrame;
        // 动画
        [UIView animateWithDuration:0.3
                         animations:^{
                             view.frame = frame;
                             [self setActive:NO WithoutView:view];
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
}

- (void)setActive:(BOOL)active WithoutView:(UIView*)view
{
    [self.allViews enumerateObjectsUsingBlock:^(GrowingMenuView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != view)
        {
            obj.active = active;
        }
    }];
}

+ (void)hideMenuView:(GrowingMenuView *)view showType:(GrowingMenuShowType)type complate:(void(^)())complate;
{
    [showMenu hideMenuView:view type:type complate:complate];
}

+ (void)hideMenuView:(GrowingMenuView *)view showType:(GrowingMenuShowType)type
{
    [self hideMenuView:view showType:type complate:nil];
}

+ (void)hideMenuView:(GrowingMenuView *)view
{
    [self hideMenuView:view showType:GrowingMenuShowTypeAlert];
}

+ (NSUInteger)showMenuCount
{
    return showMenu.allViews.count;
}

- (GrowingMenuShowType)getShowTypeByIndex:(NSUInteger)index
{
    return [self.allViewsType[index] integerValue];
}

- (void)hideMenuView:(GrowingMenuView *)view type:(GrowingMenuShowType)type complate:(void(^)())complate;
{
    NSUInteger index = [self.allViews indexOfObject:view];
    if (index >= self.allViews.count)
    {
        return;
    }
    self.allViews.lastObject.userInteractionEnabled = YES;
    
    type = [self getShowTypeByIndex:index];
    [self.allViews removeObjectAtIndex:index];
    [self.allViewsType removeObjectAtIndex:index];
    if (self.allViews.count == 0)
    {
        [[GrowingMediator sharedInstance] performClass:@"GrowingLocalCircleWindow" action:@"decreaseHiddenCount" params:nil];
    }
    
    
    
    GrowingMenuView *lastView = self.allViews.lastObject;
    lastView.userInteractionEnabled = YES;
    
    void (^animationBlock)() = nil;
    void (^finishBlock)() = nil;
    switch (type) {
        case GrowingMenuShowTypeAlert:
        {
            animationBlock = ^{
                view.alpha = 0;
                lastView.active = YES;
                [self setActive:NO WithoutView:lastView];
            };
            finishBlock = ^{
                view.alpha = 1;
            };
        }
            break;
            
        case GrowingMenuShowTypePresent:
        {
            animationBlock = ^{
                CGRect frame = view.frame;
                frame.origin.y = self.bounds.size.height;
                view.frame = frame;
                lastView.active = YES;
                [self setActive:NO WithoutView:lastView];
            };
        }
            break;
    }
    
    void(^complateBlock)() = [complate copy];
    [UIView animateWithDuration:0.25
                     animations:^{
                         if (self.allViews.count == 0)
                         {
                             self.shadowMaskView.alpha = 0;
                         }
                         if (animationBlock)
                         {
                             animationBlock();
                         }
                     }
                     completion:^(BOOL finished) {
                         [view removeFromSuperview];
                         if (finishBlock)
                         {
                             finishBlock();
                         }

                         if (self.allViews.count == 0)
                         {
                             self.userInteractionEnabled = NO;
                         }
                         
                         if (complateBlock)
                         {
                             complateBlock();
                         }
                     }];
}

- (void)keyboardWillShow:(NSNotification*)noti
{
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect visiableFrame = self.bounds;
    visiableFrame.size.height = rect.origin.y;
    
    [self.allViews enumerateObjectsUsingBlock:^(GrowingMenuView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self getShowTypeByIndex:idx] == GrowingMenuShowTypeAlert)
        {
            CGRect frame = obj.frame;
            frame.origin.y = visiableFrame.size.height / 2 - frame.size.height / 2;
            frame.origin.y = MAX(frame.origin.y, 0);
            [UIView animateWithDuration:0.25
                             animations:^{
                                 obj.frame = frame;
                             } completion:^(BOOL finished) {
                                 
                             }];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification*)noti
{
    [self.allViews enumerateObjectsUsingBlock:^(GrowingMenuView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self getShowTypeByIndex:idx] == GrowingMenuShowTypeAlert)
        {
            obj.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        }
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.growingViewLevel = 2;
        self.allViews = [[NSMutableArray alloc] init];
        self.allViewsType = [[NSMutableArray alloc] init];
        
        self.shadowMaskView = [[UIView alloc] init];
        [self addSubview:self.shadowMaskView];
        self.shadowMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                    object:nil];
        UIView *gestView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:gestView];
        gestView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.delegate = self;
        [gestView addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.shadowMaskView.frame = self.bounds;
}

- (BOOL)growingNodeDonotCircle
{
    return YES;
}

- (void)tap:(UITapGestureRecognizer*)tap
{
    CGPoint point = [tap locationInView:self.allViews.lastObject];
    if (self.allViews.count
        && self.allViewsType.lastObject.integerValue == GrowingMenuShowTypePresent
        && !CGRectContainsPoint(self.allViews.lastObject.bounds, point))
    {
         [self hideMenuView:self.allViews.lastObject type:GrowingMenuShowTypePresent complate:nil];
    }
   
}




@end
