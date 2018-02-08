//
//  BXGOrderRepayVC.m
//  Boxuegu
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderRepayVC.h"
#import "BXGOrderHeaderView.h"
#import "BXGOrderBuyCourseCell.h"
#import "BXGOrderDetailCell.h"

static NSString *BXGOrderHeaderViewId = @"BXGOrderHeaderView";
//static NSString *BXGOrderBuyCourseCellId = @"BXGOrderBuyCourseCell";
static NSString *BXGOrderDetailCellId = @"BXGOrderDetailCell";

@interface BXGOrderRepayVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, weak) UITableView *tableView;
@end

@implementation BXGOrderRepayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    
    [self installUI];
    
    [_tableView registerClass:[BXGOrderHeaderView class] forHeaderFooterViewReuseIdentifier:BXGOrderHeaderViewId];
    [_tableView registerClass:[BXGOrderBuyCourseCell class] forCellReuseIdentifier:BXGOrderBuyCourseCellId];
    [_tableView registerClass:[BXGOrderDetailCell class] forCellReuseIdentifier:BXGOrderDetailCellId];
    
    [_tableView reloadData];
}

- (void)installUI {
    //    self.view.backgroundColor = [UIColor colorWithHex:0x]
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    UIButton *repayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    repayBtn.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    [repayBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
    [repayBtn addTarget:self action:@selector(repay:) forControlEvents:UIControlEventTouchUpInside];
    [repayBtn setTitle:@"重新购买" forState:UIControlStateNormal];
    [self.view addSubview:repayBtn];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET+9);
        make.bottom.offset(-56);
    }];
    
    [repayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.equalTo(@50);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {   // custom view for header. will be adjusted to default or specified header height
    UIView *retView = nil;
    switch (section) {
        case 0:
        {
            BXGOrderHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BXGOrderHeaderViewId];
            headerView.title.text = @"订单编号";
            headerView.subtitle.text = @"1343434343";
            headerView.rightTitle.text = @"已失效";
            retView = headerView;
        }
            break;
        case 1:
            break;
        default:
            break;
    }
    return retView;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger retRow = 0;
    switch (section) {
        case 0:
            retRow = 2;
            break;
        case 1:
            retRow = 1;
            break;
        default:
            break;
    }
    return retRow;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *retCell = nil;
    switch (indexPath.section) {
        case 0:
        {
            BXGOrderBuyCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:BXGOrderBuyCourseCellId forIndexPath:indexPath];
            retCell = cell;
        }
            break;
        case 1:
        {
            BXGOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:BXGOrderDetailCellId forIndexPath:indexPath];
            retCell = cell;
        }
            break;
        default:
            NSAssert(NO, @"");
            break;
    }
    return retCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (indexPath.section) {
        case 0:
            height = 118;
            break;
        case 1:
            height = 195;
            break;
        default:
            NSAssert(NO, @"heightForRowAtIndexPath");
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    switch (section) {
        case 0:
            height = 41;
            break;
        case 1:
            break;
        default:
            NSAssert(NO, @"heightForHeaderInSection");
            break;
    }
    return height;
}

- (void)repay:(UIButton*)sender {
    NSLog(@"点击重新购买");
}


@end
