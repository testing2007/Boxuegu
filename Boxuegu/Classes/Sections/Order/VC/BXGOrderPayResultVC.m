//
//  BXGOrderPayResultVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderPayResultVC.h"
#import "BXGOrderPayResultOrderDetailCell.h"
#import "BXGOrderPayResultOrderHeaderCell.h"
#import "BXGOrderPayResultOrderFailedCell.h"
#define kBXGOrderPayResultOrderDetailCell @"BXGOrderPayResultOrderDetailCell"
#define kBXGOrderPayResultOrderHeaderCell @"BXGOrderPayResultOrderHeaderCell"
#define kBXGOrderPayResultOrderFailedCell @"BXGOrderPayResultOrderFailedCell"

#import "BXGOrderPayResultViewModel.h"

@interface BXGOrderPayResultVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) BXGOrderPayResultViewModel *viewModel;
@property (nonatomic, strong) BXGOrderPayResultModel *resultModel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BXGOrderPayResultVC

#pragma mark - Interface

- (instancetype)initWithViewModel:(BXGOrderPayResultViewModel *)viewModel; {
    self = [super init];
    if(self) {
        _viewModel = viewModel;
    }
    return self;
}

#pragma mark - Data
- (void)preLoadData {
    Weak(weakSelf);
    [weakSelf installUI];
    [self.view installLoadingMaskViewWithInset:UIEdgeInsetsMake(K_NAVIGATION_BAR_OFFSET, 0, 0, 0)];
    
        [self.viewModel loadOrderPayResultWithFinishBlock:^(BOOL bSuccess, BXGOrderPayResultModel *resultModel, NSString *msg) {
            if(bSuccess) {
                [weakSelf.view removeMaskView];
                weakSelf.resultModel = resultModel;
                [weakSelf.tableView reloadData];
                
            } else {
                [weakSelf failedAction:msg];
            }
        }];
}
#pragma mark - UI

- (void)installUI {
    self.title = @"订单支付成功";
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [tableView registerNib:[UINib nibWithNibName:kBXGOrderPayResultOrderDetailCell bundle:nil] forCellReuseIdentifier:kBXGOrderPayResultOrderDetailCell];
    [tableView registerNib:[UINib nibWithNibName:kBXGOrderPayResultOrderHeaderCell bundle:nil] forCellReuseIdentifier:kBXGOrderPayResultOrderHeaderCell];
    [tableView registerNib:[UINib nibWithNibName:kBXGOrderPayResultOrderFailedCell bundle:nil] forCellReuseIdentifier:kBXGOrderPayResultOrderFailedCell];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorColor = [UIColor colorWithHex:0xf5f5f5];
    tableView.allowsSelection = false;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
    }];
    
    tableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
        tableView.estimatedRowHeight = 200;
        tableView.rowHeight = UITableViewAutomaticDimension;
    }
    self.tableView = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageName = @"订单支付结果";
    if(self.viewModel.isFaild) {
        [self failedAction:self.viewModel.faildMsg];
    } else {
        [self preLoadData];
    }
}

- (void)failedAction:(NSString *)msg {
    // toast
    [[BXGHUDTool share] showHUDWithString:msg];
    // 重定向
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:true completion:nil];
        [self.mainViewController pushToMeOrderFailedVC];
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return 88;
    }else {
        return UITableViewAutomaticDimension;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Weak(weakSelf);
    if(indexPath.section == 0){
        BXGOrderPayResultOrderHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kBXGOrderPayResultOrderHeaderCell forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 1){
        BXGOrderPayResultOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kBXGOrderPayResultOrderDetailCell forIndexPath:indexPath];
        cell.resultModel = self.resultModel;
        cell.onClickFirstBtnBlock = ^{
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatOrderResultEventTypeStudyCenter andLabel:nil];
            [self dismissViewControllerAnimated:true completion:nil];
            [weakSelf.mainViewController pushToStudyRootVC];
        };
        cell.onClickSecondBtnBlock = ^{
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatOrderResultEventTypeMeOrder andLabel:nil];
            [self dismissViewControllerAnimated:true completion:nil];
            [weakSelf.mainViewController pushToMeOrderDoneVC];
        };
        return cell;
    }
    BXGOrderPayResultOrderFailedCell *cell = [tableView dequeueReusableCellWithIdentifier:kBXGOrderPayResultOrderFailedCell forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
@end
