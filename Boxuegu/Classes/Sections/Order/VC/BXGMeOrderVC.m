//
//  BXGMeOrderVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMeOrderVC.h"
#import "BXGOrderPayVC.h"
#import "RWTabView.h"
#import "BXGOrderListVC.h"
#import "BXGOrderCouponDetailViewModel.h"

@interface BXGMeOrderVC ()
// <RWTabDelegate>

@property(nonatomic, strong) RWTabView *rwTab;
@property(nonatomic, strong) BXGOrderListVC *waitingPayOrderListVC;
@property(nonatomic, strong) BXGOrderListVC *finishedOrderListVC;
@property(nonatomic, strong) BXGOrderListVC *invalidOrderListVC;
@property(nonatomic, strong) BXGOrderCouponDetailViewModel *viewModel;
@end

@implementation BXGMeOrderVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.rwTab){
        self.rwTab.currentIndex = self.selectedType;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.pageName = @"我的订单";
    _waitingPayOrderListVC = [BXGOrderListVC new];
    _waitingPayOrderListVC.orderPayStatus = OrderPayStatus_WaitingForPay;
    _finishedOrderListVC = [BXGOrderListVC new];
    _finishedOrderListVC.orderPayStatus = OrderPayStatus_Finished;
    _invalidOrderListVC = [BXGOrderListVC new];
    _invalidOrderListVC.orderPayStatus = OrderPayStatus_Invalid;
    [self addChildViewController:_waitingPayOrderListVC];
    [self addChildViewController:_finishedOrderListVC];
    [self addChildViewController:_invalidOrderListVC];
    _waitingPayOrderListVC.view.frame = CGRectZero;
    _finishedOrderListVC.view.frame = CGRectZero;
    _invalidOrderListVC.view.frame = CGRectZero;
    self.rwTab = [[RWTabView alloc]initWithTitles:@[@"待支付", @"已完成", @"已失效"] andDetailViews:@[_waitingPayOrderListVC.view, _finishedOrderListVC.view, _invalidOrderListVC.view]];
    self.rwTab.DidChangedIndex = ^(RWTabView *tab, NSInteger index, NSString *title, UIView *view) {
        switch (index) {
            case 0:
                [[BXGBaiduStatistic share] statisticEventString:kBXGStatMeOrderEventTypeOrderNoPay andLabel:nil];
                break;
            case 1:
                [[BXGBaiduStatistic share] statisticEventString:kBXGStatMeOrderEventTypeOrderDone andLabel:nil];
                break;
            case 2:
                [[BXGBaiduStatistic share] statisticEventString:kBXGStatMeOrderEventTypeOrderExpired andLabel:nil];
                break;
            default:
                break;
        }
    };
    
    [self.view addSubview:_rwTab];
    [self.rwTab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(K_NAVIGATION_BAR_OFFSET);
        make.bottom.left.right.offset(0);
    }];
}
@end
