//
// Created by xiangyang on 2020/4/29.
// Copyright (c) 2020 GrowingIO. All rights reserved.
//

#import "TrackViewController.h"
#import "GIOWKWebViewViewController.h"
#import "Growing.h"

static NSString *const kGrowingCellId = @"cellId";

static NSString *const kGrowingTrackEvent = @"Track Event";
static NSString *const kGrowingTrackEventAndVar = @"Track Event and Var";
static NSString *const kGrowingTrackPage = @"Track Page";
static NSString *const kGrowingTrackPageAndVar = @"Track Page and Var";
static NSString *const kGrowingGoToWKWebViewVC = @"Go To WKWebView VC";

@interface TrackViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray<NSString *> *tableData;

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
            kGrowingGoToWKWebViewVC
    ];
    [self.view addSubview:self.tableView];
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
    }
}
@end
