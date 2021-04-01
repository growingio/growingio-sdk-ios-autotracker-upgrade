//
//  UIView+quickLayoutInit.m
//  TravelGuideMdd
//
//  Created by 陈曦 on 14/11/21.
//  Copyright (c) 2014年 mafengwo.com. All rights reserved.
//

#import "UIView+GrowingHelperLayout.h"
#import "UIControl+GrowingHelper.h"
#import "UITextField+GrowingHelper.h"

@interface GrowingUIViewAutoResizeMask()

@property (nonatomic, assign) UIView *view;

@end

@implementation GrowingUIViewAutoResizeMask

- (GrowingUIViewAutoResizeMask*)left
{
    self.view.autoresizingMask |= UIViewAutoresizingFlexibleLeftMargin;
    return self;
}

- (GrowingUIViewAutoResizeMask*)right
{
    self.view.autoresizingMask |= UIViewAutoresizingFlexibleRightMargin;
    return self;
}

- (GrowingUIViewAutoResizeMask*)top
{
    self.view.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
    return self;
}

- (GrowingUIViewAutoResizeMask*)bottom
{
    self.view.autoresizingMask |= UIViewAutoresizingFlexibleBottomMargin;
    return self;
}

- (GrowingUIViewAutoResizeMask*)width
{
    self.view.autoresizingMask |= UIViewAutoresizingFlexibleWidth;
    return self;
}

- (GrowingUIViewAutoResizeMask*)heigh
{
    self.view.autoresizingMask |= UIViewAutoresizingFlexibleHeight;
    return self;
}

- (GrowingUIViewAutoResizeMask*)fullsize
{
    return self.width.heigh;
}

- (id)set
{
    return self.view;
}


@end

@implementation UIView (quickLayoutInit)

// label
- (UILabel*)growAddLabelWithFontSize:(NSInteger)fontSize
                               color:(UIColor*)color
                               lines:(NSInteger)lines
                                text:(NSString *)text
                               block:(void (^)(MASG3ConstraintMaker *, UILabel *))block
{
    return [self growAddSubviewClass:[UILabel class]
                          block:^(MASG3ConstraintMaker *make, UILabel *lbl) {
                                  lbl.font = [UIFont systemFontOfSize:fontSize];
                                          
                                  if (color)
                                  {
                                      lbl.textColor = color;
                                  }
                                  
                                  lbl.numberOfLines = lines;
                                  if (text.length)
                                  {
                                      lbl.text = text;
                                  }
                                  if (block)
                                  {
                                      block(make,lbl);
                                  }
                              }];
}

// textfield
- (UITextField*)growAddTextFieldWithFontSize:(NSInteger)fontSize
                                       color:(UIColor *)color
                                 placeHolder:(NSString *)placeHolder
                                       block:(void (^)(MASG3ConstraintMaker *, UITextField *))block
{
    return [self growAddSubviewClass:[UITextField class]
                          block:^(MASG3ConstraintMaker *make, UITextField *text) {
                            
                                  text.font = [UIFont systemFontOfSize:fontSize];
                                  if (color)
                                  {
                                      text.textColor = color;
                                  }
                                  if (placeHolder.length)
                                  {
                                      text.placeholder = placeHolder;
                                  }
                                  if (block)
                                  {
                                      block(make,text);
                                  }
                              }];
}

// textfield
- (UITextField*)growAddTextFieldWithFontSize:(NSInteger)fontSize
                                       color:(UIColor *)color
                                 placeHolder:(NSString *)placeHolder
                                       inset:(UIEdgeInsets)inset
                                       block:(void (^)(MASG3ConstraintMaker *, UITextField *))block
{
    return [self growAddSubviewClass:[GrowingHelperTextField class]
                               block:^(MASG3ConstraintMaker *make, GrowingHelperTextField *text) {
                                   text.edgeInset = inset;
                                   text.font = [UIFont systemFontOfSize:fontSize];
                                   if (color)
                                   {
                                       text.textColor = color;
                                   }
                                   if (placeHolder.length)
                                   {
                                       text.placeholder = placeHolder;
                                   }
                                   if (block)
                                   {
                                       block(make,text);
                                   }
                               }];
}

// image
- (UIImageView*)growAddImageViewWithImage:(UIImage*)image
                               block:(void (^)(MASG3ConstraintMaker *, UIImageView *))block
{
    return [self growAddSubviewClass:[UIImageView class]
                          block:^(MASG3ConstraintMaker *make, UIImageView *imageView) {
                                  if (image)
                                  {
                                      imageView.image = image;
                                  }
                                  if (block) {
                                      block(make,imageView);
                                  }
                              }];
}

- (UIImageView*)growAddImageViewWithBlock:(void (^)(MASG3ConstraintMaker *, UIImageView *))block
{
    return [self growAddSubviewClass:[UIImageView class]
                               block:block];
}



- (UIImageView*)growAddImageViewWithImageName:(NSString *)imageName
                                   block:(void (^)(MASG3ConstraintMaker *, UIImageView *))block
{
    UIImage *img = nil;
    if (imageName.length)
    {
        img = [UIImage imageNamed:imageName];
    }
    return [self growAddImageViewWithImage:img block:block];
}

// UIControl
- (UIControl*)growAddControlWithBlock:(void (^)(MASG3ConstraintMaker *, UIControl *))block
{
    return [self growAddControlWithOnClick:nil block:block];
}

- (UIControl*)growAddControlWithOnClick:(void(^)(void))onClick
                             block:(void (^)(MASG3ConstraintMaker *, UIControl *))block
{
    return [self growAddSubviewClass:[UIControl class]
                          block:^(MASG3ConstraintMaker *make, UIControl *ctrl) {
                                  ctrl.growingHelper_onClick = onClick;
                                  if (block)
                                  {
                                      block(make, ctrl);
                                  }
                              }];
}

// UIButton
- (UIButton*)growAddButtonWithTitle:(NSString*)title
                              color:(UIColor *)color
                            onClick:(void(^)(void))onClick
                              block:(void (^)(MASG3ConstraintMaker *, UIButton *))block
{
    return [self growAddSubviewClass:[UIButton class]
                          block:^(MASG3ConstraintMaker *make, UIButton *btn) {
                                  if (title)
                                  {
                                      [btn setTitle:title forState:0];
                                  }
                                  if (color)
                                  {
                                      [btn setTitleColor:color forState:0];
                                  }
                                  btn.growingHelper_onClick = onClick;
                                  if (block)
                                  {
                                      block(make,btn);
                                  }
                              }];
}

- (UIButton*)growAddButtonWithAttributedTitle:(NSAttributedString *)title
                                      onClick:(void (^)(void))onClick
                                        block:(void (^)(MASG3ConstraintMaker *, UIButton *))block
{
    return [self growAddSubviewClass:[UIButton class]
                               block:^(MASG3ConstraintMaker *make, UIButton *btn) {
                                   if (title.length)
                                   {
                                       [btn setAttributedTitle:title forState:0];
                                   }
                                   btn.growingHelper_onClick = onClick;
                                   if (block)
                                   {
                                       block(make,btn);
                                   }
                               }];
}

- (UIButton*)growAddButtonWithBlock:(void (^)(MASG3ConstraintMaker *, UIButton *))block
{
    return [self growAddSubviewClass:[UIButton class] block:block];
}

- (UIButton*)growAddButtonWithImage:(UIImage*)image
                            onClick:(void (^)(void))onClick
                              block:(void (^)(MASG3ConstraintMaker *, UIButton *))block
{
    return [self growAddSubviewClass:[UIButton class]
                          block:^(MASG3ConstraintMaker *make, UIButton *btn) {
                              btn.growingHelper_onClick = onClick;
                              [btn setImage:image forState:0];
                              if (block)
                              {
                                  block(make,btn);
                              }
                          }];
}

// UIView
- (UIView*)growAddViewWithColor:(UIColor*)color
                          block:(void (^)(MASG3ConstraintMaker *, UIView *))block
{
    return [self growAddSubviewClass:[UIView class]
                               block:^(MASG3ConstraintMaker *make, UIView *v) {
                                   v.backgroundColor = color;
                                   if (block)
                                   {
                                       block(make,v);
                                   }
                               }];
}

- (id)growAddSubviewClass:(Class)classs
                    block:(void (^)(MASG3ConstraintMaker *, id))block
{
    if (![classs isSubclassOfClass:[UIView class]]
        && classs != [UIView class])
    {
        return nil;
    }
    UIView *view = [[classs alloc] init];
    return [self growAddSubviewInstance:view
                                  block:block];
}

- (id)growAddSubviewInstance:(UIView *)view
                       block:(void(^)(MASG3ConstraintMaker *make,id obj))block
{
    [self addSubview:view];
    
    void(^makeBlock)(MASG3ConstraintMaker*) = ^void(MASG3ConstraintMaker *maker)
    {
        if (block)
        {
            block(maker,view);
        }
    };
    
    if (makeBlock)
    {
        [view masG3_makeConstraints:makeBlock];
    }
    
    return view;
}

- (GrowingUIViewAutoResizeMask*)growingAutoResizeMakeObject
{
    GrowingUIViewAutoResizeMask *mask = [[GrowingUIViewAutoResizeMask alloc] init];
    mask.view = self;
    return mask;
}

@end


