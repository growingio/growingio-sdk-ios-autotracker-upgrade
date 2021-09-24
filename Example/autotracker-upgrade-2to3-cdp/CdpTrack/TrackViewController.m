//
// Created by xiangyang on 2020/4/29.
// Copyright (c) 2020 GrowingIO. All rights reserved.
//

#import "TrackViewController.h"
#import "GIOWKWebViewViewController.h"
#import "Growing.h"
#import <GrowingTouchCoreKit/GrowingTouchBannerView.h>

static NSString *const kGrowingCellId = @"cellId";

static NSString *const kGrowingTrackEvent = @"Track Event";
static NSString *const kGrowingTrackEventAndVar = @"Track Event and Var";
static NSString *const kGrowingTrackPage = @"Track Page";
static NSString *const kGrowingTrackPageAndVar = @"Track Page and Var";
static NSString *const kGrowingGoToWKWebViewVC = @"Go To WKWebView VC";
static NSString *const kGrowingSwitchUser = @"Switch User";

@interface TrackViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray<NSString *> *tableData;
@property(nonatomic, strong)  GrowingTouchBannerView *bannerViews ;
@end

@implementation TrackViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"测试埋点事件";
    self.view.backgroundColor = UIColor.whiteColor;
    self.tableData = @[
            kGrowingTrackEvent,
            kGrowingTrackEventAndVar,
            kGrowingTrackPage,
            kGrowingTrackPageAndVar,
            kGrowingGoToWKWebViewVC,
            kGrowingSwitchUser
    ];
    [self.view addSubview:self.tableView];
    
    [self addBanner];
}
- (void)addBanner {
    //触达banner
    UIImage* placeholderImage = [UIImage imageNamed:@"suggest1"];
    self.bannerViews = [GrowingTouchBannerView bannerKey:@"a54dd678455813a1"
                                             bannerFrame:CGRectMake(0, self.view.bounds.size.height - 220, self.view.bounds.size.width ,220)
                                        placeholderImage:placeholderImage];
    self.bannerViews.bannerViewErrorImage = placeholderImage;
        //  设置图片
    self.bannerViews.currentPageIndicatorImage = [UIImage imageNamed:@"page_select"];
    self.bannerViews.pageIndicatorImage = [UIImage imageNamed:@"page_unselect"];
        self.bannerViews.pageIndicatorSize = CGSizeMake(6,6);
        self.bannerViews.currentPageIndicatorSize = CGSizeMake(16,16);
        self.bannerViews.currentPageIndicatorTintColor = [UIColor redColor];
        self.bannerViews.pageIndicatorTintColor = [UIColor yellowColor];
    [self.bannerViews loadBannerWithDelegate:self];
    
    [self.view addSubview:self.bannerViews];
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:kGrowingCellId];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }

    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGrowingCellId];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.tableData[(NSUInteger) indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSString *action = self.tableData[(NSUInteger) indexPath.row];
    if ([kGrowingTrackEvent isEqualToString:action]) {
        [Growing track:@"TestCustomEvent"];
    } else if ([kGrowingTrackEventAndVar isEqualToString:action]) {
        [Growing track:@"payOrderSuccess" withVariable:@{@"payAmount_var":@99.9}];

    } else if ([kGrowingTrackPage isEqualToString:action]) {
        [Growing trackPage:@"TestPageEvent"];
    } else if ([kGrowingTrackPageAndVar isEqualToString:action]) {
        [Growing trackPage:@"TestVarPageEvent" withVariable:@{
                @"key1": @"value1",
                @"key2": @"value2"
        }];
    } else if ([kGrowingGoToWKWebViewVC isEqualToString:action]) {
        [self.navigationController pushViewController:[[GIOWKWebViewViewController alloc] init] animated:YES];
    } else if ([kGrowingSwitchUser isEqualToString:action]) {
        [Growing setUserId:[NSString stringWithFormat:@"userid_%d",arc4random()%100]];
    }
}
@end
