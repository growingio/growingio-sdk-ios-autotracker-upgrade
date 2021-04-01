//
//  UIView+quickLayoutInit.h
//  TravelGuideMdd
//
//  Created by 陈曦 on 14/11/21.
//  Copyright (c) 2014年 mafengwo.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasonryGrowing3rd.h"

@interface GrowingUIViewAutoResizeMask : NSObject
@property (nonatomic, readonly) GrowingUIViewAutoResizeMask *left;
@property (nonatomic, readonly) GrowingUIViewAutoResizeMask *right;
@property (nonatomic, readonly) GrowingUIViewAutoResizeMask *top;
@property (nonatomic, readonly) GrowingUIViewAutoResizeMask *bottom;
@property (nonatomic, readonly) GrowingUIViewAutoResizeMask *width;
@property (nonatomic, readonly) GrowingUIViewAutoResizeMask *heigh;

@property (nonatomic, readonly) GrowingUIViewAutoResizeMask *fullsize;// w + h

- (id)set;

@end

@interface UIView (quickLayoutInit)

// label
- (UILabel*)growAddLabelWithFontSize:(NSInteger)fontSize
                               color:(UIColor*)color
                               lines:(NSInteger)lines
                                text:(NSString*)text
                               block:(void(^)(MASG3ConstraintMaker *make,UILabel*lable))block;

// textfield
- (UITextField*)growAddTextFieldWithFontSize:(NSInteger)fontSize
                                       color:(UIColor*)color
                                 placeHolder:(NSString*)placeHolder
                                  block:(void(^)(MASG3ConstraintMaker *make, UITextField *textField))block;

- (UITextField*)growAddTextFieldWithFontSize:(NSInteger)fontSize
                                       color:(UIColor *)color
                                 placeHolder:(NSString *)placeHolder
                                       inset:(UIEdgeInsets)inset
                                       block:(void (^)(MASG3ConstraintMaker *, UITextField *))block;
// image
- (UIImageView*)growAddImageViewWithImage:(UIImage*)image
                               block:(void(^)(MASG3ConstraintMaker *make, UIImageView *imageView))block;

- (UIImageView*)growAddImageViewWithImageName:(NSString*)imageName
                                   block:(void(^)(MASG3ConstraintMaker *make, UIImageView *imageView))block;

- (UIImageView*)growAddImageViewWithBlock:(void(^)(MASG3ConstraintMaker *make, UIImageView *imageView))block;

// control
- (UIControl*)growAddControlWithBlock:(void(^)(MASG3ConstraintMaker *make, UIControl *control))block;
- (UIControl*)growAddControlWithOnClick:(void(^)(void))onClick
                                  block:(void(^)(MASG3ConstraintMaker *make, UIControl *control))block;

// button
- (UIButton*)growAddButtonWithTitle:(NSString*)title
                              color:(UIColor*)color
                            onClick:(void(^)(void))onClick
                              block:(void(^)(MASG3ConstraintMaker *make, UIButton *button))block;

- (UIButton*)growAddButtonWithAttributedTitle:(NSAttributedString*)title
                                      onClick:(void(^)(void))onClick
                                        block:(void(^)(MASG3ConstraintMaker *make, UIButton *button))block;

- (UIButton*)growAddButtonWithImage:(UIImage*)image
                            onClick:(void(^)(void))onClick
                              block:(void(^)(MASG3ConstraintMaker *make,UIButton *button))block;

- (UIButton*)growAddButtonWithBlock:(void(^)(MASG3ConstraintMaker *make,UIButton *button))block;


// view
- (UIView*)growAddViewWithColor:(UIColor*)color
                          block:(void(^)(MASG3ConstraintMaker *make,UIView *view))block;

// 通用
- (id)growAddSubviewClass:(Class)classs
                    block:(void(^)(MASG3ConstraintMaker *make,id obj))block;

- (id)growAddSubviewInstance:(UIView *)view
                       block:(void(^)(MASG3ConstraintMaker *make,id obj))block;

- (GrowingUIViewAutoResizeMask*)growingAutoResizeMakeObject;

@end
