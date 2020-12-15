//
// Created by xiangyang on 2020/4/29.
// Copyright (c) 2020 GrowingIO. All rights reserved.
//

#import "TrackViewController.h"
#import "GIOWKWebViewViewController.h"
#import "Growing.h"

static NSString *const kCellId = @"cellId";

static NSString *const kTrackEvent = @"Track Event";
static NSString *const kTrackEventAndVar = @"Track Event and Var";
static NSString *const kTrackPage = @"Track Page";
static NSString *const kTrackPageAndVar = @"Track Page and Var";
static NSString *const kGoToWKWebViewVC = @"Go To WKWebView VC";

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
            kTrackEvent,
            kTrackEventAndVar,
            kTrackPage,
            kTrackPageAndVar,
            kGoToWKWebViewVC
    ];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:kCellId];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.tableData[(NSUInteger) indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSString *action = self.tableData[(NSUInteger) indexPath.row];
    if ([kTrackEvent isEqualToString:action]) {
        [Growing track:@"TestCustomEvent"];
    } else if ([kTrackEventAndVar isEqualToString:action]) {
        [Growing track:@"payOrderSuccess" withVariable:@{@"payAmount_var":@99.9}];

    } else if ([kTrackPage isEqualToString:action]) {
        [Growing trackPage:@"TestPageEvent"];
    } else if ([kTrackPageAndVar isEqualToString:action]) {
        [Growing trackPage:@"TestVarPageEvent" withVariable:@{
                @"key1": @"value1",
                @"key2": @"value2"
        }];
    } else if ([kGoToWKWebViewVC isEqualToString:action]) {
        [self.navigationController pushViewController:[[GIOWKWebViewViewController alloc] init] animated:YES];
    }
}
@end
