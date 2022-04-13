//
//  GrowingHelperMenu.m
//  Growing
//
//  Created by 陈曦 on 16/2/23.
//  Copyright © 2016年 GrowingIO. All rights reserved.
//

#import "Upgrade-base/2x/Menu/GrowingHelperMenu.h"

@interface GrowingHelperMenu()
@property (nonatomic, retain) UIView *helperView;
@property (nonatomic, retain) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) CGRect viewFrame;
@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, copy) NSString *helpText;
@end



@implementation GrowingHelperMenu

- (instancetype)initWithHelpView:(UIView *)view helpText:(NSString *)text
{
    self = [super initWithType:GrowingMenuShowTypePresent];
    if (self)
    {
        self.helperView = view;
        self.viewFrame = self.helperView.frame;
        self.navigationBarHidden = YES;
        self.helpText = text;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    

    
    
    // 创建一个shapeLayer
    CAShapeLayer *layer = [CAShapeLayer layer];
    self.shapeLayer = layer;

    layer.strokeColor   = [UIColor whiteColor].CGColor;   // 边缘线的颜色
    layer.fillColor     = [UIColor clearColor].CGColor;   // 闭环填充的颜色
    layer.lineCap       = kCALineCapRound;               // 边缘线的类型
    
    layer.lineWidth     = 4.0f;                           // 线条宽度
    layer.strokeStart   = 0.0f;
    layer.strokeEnd     = 1.0f;
    
    [self.view.layer addSublayer:layer];
    
    UILabel *textLable = [[UILabel alloc] init];
    self.textLabel = textLable;
    textLable.font = [UIFont systemFontOfSize:16];
    textLable.textColor = [UIColor whiteColor];
    textLable.text = self.helpText;
    [textLable sizeToFit];
    [self.view addSubview:textLable];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    BOOL isUP = (self.viewFrame.origin.y + self.viewFrame.size.height / 2) > self.bounds.size.height * 0.7;
    
    CGFloat textCenterY = 0;
    if (isUP)
    {
        textCenterY = self.viewFrame.origin.y - 50 ;
    }
    else
    {
        textCenterY = self.viewFrame.origin.y + self.viewFrame.size.height + 50;
    }
    
    CGRect textFrame = self.textLabel.frame;
    textFrame.origin.x = self.viewFrame.origin.x + self.viewFrame.size.width / 2 - textFrame.size.width / 2;
    if (textFrame.origin.x + textFrame.size.width > self.bounds.size.width - 10)
    {
        textFrame.origin.x = self.bounds.size.width - textFrame.size.width - 10;
    }
    if (textFrame.origin.x < 10)
    {
        textFrame.origin.x = 10;
    }
    textFrame.origin.y = textCenterY - textFrame.size.height / 2;
    
    
    self.textLabel.frame = textFrame;
    
    
    self.shapeLayer.frame = self.view.bounds;
    
    CGFloat beginAndEndX = self.viewFrame.size.width / 2 + self.viewFrame.origin.x;
    CGFloat beginY = 0;
    CGFloat endY = 0;
    CGFloat changeHeight = 10;
    if (isUP)
    {
        changeHeight = -10;
        endY = self.viewFrame.origin.y - 5;
        beginY = textFrame.size.height + textFrame.origin.y + 5;
    }
    else
    {
        endY = self.viewFrame.origin.y + self.viewFrame.size.height + 5;
        beginY = textFrame.origin.y - 5;
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, beginAndEndX, beginY);
    CGPathAddLineToPoint(path, nil, beginAndEndX, endY);
    CGPathMoveToPoint(path, nil, beginAndEndX - 10, endY + changeHeight);
    CGPathAddLineToPoint(path, nil, beginAndEndX, endY);
    CGPathMoveToPoint(path, nil, beginAndEndX + 10, endY + changeHeight);
    CGPathAddLineToPoint(path, nil, beginAndEndX, endY);
    
    
    self.shapeLayer.path          = path;                    // 从贝塞尔曲线获取到形状
    CGPathRelease(path);
}

//- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIWindow *window = self.helperView.window;
//    CGPoint windowPoint = [[[event allTouches] anyObject] locationInView:window];
//    UIView *view = [window hitTest:windowPoint withEvent:event];
//    while (view)
//    {
//        if (view == self.helperView)
//        {
//            return view;
//        }
//        view = view.superview;
//    }
//    return self;
//}




@end
