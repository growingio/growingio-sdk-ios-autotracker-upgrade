//
// Created by xiangyang on 2020/4/30.
// Copyright (c) 2020 GrowingIO. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "GIOWKWebViewViewController.h"
#import "Growing.h"

static NSString *const kLoadUrl = @"https://release-messages.growingio.cn/push/cdp/webcircel.html";

@implementation GIOWKWebViewViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    [Growing bridgeForWKWebView:webView];
    NSURL *url = [NSURL URLWithString:kLoadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}
@end
