//
//  BXGOrderListVC.m
//  Boxuegu
//
//  Created by apple on 2017/10/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderListVC.h"
#import "BXGOrderHelper.h"
#import "BXGOrderHeaderView.h"
#import "BXGOrderBuyCourseCell.h"
#import "BXGOrderFooterView.h"
#import "BXGOrderHelper.h"
#import "BXGOrderPayListModel.h"
#import "BXGOrderPayItemModel.h"
#import "BXGOrderPayItemDetailModel.h"
#import "BXGOrderFinishedVC.h"
#import "BXGOrderPayVC.h"
#import "BXGMainTabBarController.h"
#import "BXGOrderFloatTipView.h"
#import "BXGOrderFillOrderVC.h"
#import "BXGPayManager.h"
#

@interface BXGOrderListVC ()<UITableViewDelegate, UITableViewDataSource, BXGNotificationDelegate>

@property(nonatomic, strong) BXGOrderHelper *orderHelper;
@property(nonatomic, weak) UITableView *tableView;
@property(nonatomic, strong) NSArray<BXGOrderPayItemModel*> *arrOrderPayItemModel;
@property(nonatomic, strong) BXGOrderFloatTipView *tipView;
@property(nonatomic, assign) BOOL bCloseTip;
@property(nonatomic, strong) BXGPayManager *payManager;

@end

static NSString *BXGOrderHeaderViewId = @"BXGOrderHeaderView";
static NSString *BXGOrderFooterViewId = @"BXGOrderFooterView";

@implementation BXGOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self installUI];
    
    _payManager = [BXGPayManager new];
    _payManager.delegate = self;
    _orderHelper = [BXGOrderHelper new];
    
    [_tableView registerClass:[BXGOrderHeaderView class] forHeaderFooterViewReuseIdentifier:BXGOrderHeaderViewId];
    [_tableView registerClass:[BXGOrderFooterView class] forHeaderFooterViewReuseIdentifier:BXGOrderFooterViewId];
    [_tableView registerClass:[BXGOrderBuyCourseCell class] forCellReuseIdentifier:BXGOrderBuyCourseCellId];

    [self installPullRefresh];
    
    [BXGNotificationTool addObserverForOrderCancelOK:self];

}

- (void)catchOrderCancelOK {
    [self.tableView bxg_beginHeaderRefresh];
}

- (void)dealloc {
    [BXGNotificationTool removeObserver:self];
}

- (void)installUI {
    Weak(weakSelf);
    

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    //    tableView.tableFooterView = [UIView new];
    [tableView setBackgroundColor:[UIColor colorWithHex:0xF5F5F5]];
    tableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    self.tipView = [BXGOrderFloatTipView new];
    self.tipView.closeTipViewBlock = ^{
        weakSelf.bCloseTip = YES;
    };
    [self.view addSubview:self.tipView];
    //已失效/已完成订单列表页不显示tipView
    if(_orderPayStatus == OrderPayStatus_Invalid || _orderPayStatus == OrderPayStatus_Finished) {
        self.tipView.hidden = YES;
    }
    
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        make.height.offset(0);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.tipView.mas_bottom).offset(0);
        make.top.offset(0);
        make.left.right.bottom.offset(0);
    }];
}

-(void)installPullRefresh
{
    __weak typeof(self) weakSelf = self;
    
    [weakSelf.tableView bxg_setHeaderRefreshBlock:^{
        [weakSelf refreshUI:YES];
    }];
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [weakSelf.tableView bxg_setFootterRefreshBlock:^{
        [weakSelf refreshUI:NO];
    }];
    
    [self.tableView bxg_beginHeaderRefresh];
    [self.tableView bxg_endFootterRefreshNoMoreData];
}

-(void)refreshUI:(BOOL)bRefresh
{
    __weak typeof(self) weakSelf = self;
    [_orderHelper loadMyOrdersWithRefresh:bRefresh andOrderStatus:[NSNumber numberWithInteger:_orderPayStatus] andFinishBlock:^(BOOL bSuccess, NSError *error, BXGOrderPayListModel *orderPayListModel) {
        if(bSuccess && orderPayListModel)
        {
            weakSelf.arrOrderPayItemModel = orderPayListModel.items;
            [weakSelf.tableView removeMaskView];
            [weakSelf.tableView reloadData];

            if(weakSelf.arrOrderPayItemModel.count>0) {
                if(!weakSelf.bCloseTip) {
                    if(weakSelf.orderPayStatus==OrderPayStatus_WaitingForPay || weakSelf.orderPayStatus==OrderPayStatus_Invalid) {
                        [weakSelf.tipView loadContent:kBXGToastOrderPayDeadline];
                        [weakSelf.tipView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.offset(38);
                        }];
                    }
                }
            }
            
            if(weakSelf.arrOrderPayItemModel.count == 0)
            {
                [weakSelf.tableView installMaskView:BXGButtonMaskViewTypeNoOrder buttonBlock:^{
                    [[BXGBaiduStatistic share] statisticEventString:kBXGStatMeOrderEventTypeRecommendCourse andLabel:nil];
                    [weakSelf.mainViewController pushToHomeRootVC];
                }];
            }
        }
        else
        {
            [weakSelf.tableView installMaskView:BXGButtonMaskViewTypeLoadFailed buttonBlock:^{
                [[BXGBaiduStatistic share] statisticEventString:kBXGStatMeOrderEventTypeRecommendCourse andLabel:nil];
//                [weakSelf.mainViewController pushToHomeRootVC];
                [weakSelf refreshUI:YES];
            }];
            NSLog(@"fail to get note detail data");
        }
        [weakSelf.tableView bxg_endHeaderRefresh];
        if(weakSelf.orderHelper.bHaveMoreOrderListData)
        {
            [weakSelf.tableView bxg_endFootterRefresh];
        }
        else
        {
            [weakSelf.tableView bxg_endFootterRefreshNoMoreData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger nCount = 0;
    if(_arrOrderPayItemModel) {
        nCount = _arrOrderPayItemModel.count;
    }
    return nCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger nCount = 0;
    if(_arrOrderPayItemModel && section<_arrOrderPayItemModel.count) {
        BXGOrderPayItemModel *orderPayItemModel = _arrOrderPayItemModel[section];
        if(orderPayItemModel) {
            NSArray<BXGOrderPayItemDetailModel*> *arrItemDetailModel = (NSArray<BXGOrderPayItemDetailModel*> *)orderPayItemModel.orderDetail;
            nCount = arrItemDetailModel ? arrItemDetailModel.count : 0;
        }
    }
    return nCount;

}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BXGOrderBuyCourseCell *cell = (BXGOrderBuyCourseCell*)[tableView dequeueReusableCellWithIdentifier:BXGOrderBuyCourseCellId forIndexPath:indexPath];

    if(_arrOrderPayItemModel && indexPath.section<_arrOrderPayItemModel.count) {
        BXGOrderPayItemModel *orderPayItemModel = _arrOrderPayItemModel[indexPath.section];
        if(orderPayItemModel) {
            NSArray<BXGOrderPayItemDetailModel*> *arrItemDetailModel = (NSArray<BXGOrderPayItemDetailModel*> *)orderPayItemModel.orderDetail;
            if(arrItemDetailModel) {
                if(indexPath.row<arrItemDetailModel.count) {
                    BXGOrderPayItemDetailModel *itemDetailModel = arrItemDetailModel[indexPath.row];
                    [cell.courseThumbImageView sd_setImageWithURL:[NSURL URLWithString:itemDetailModel.smallimg_path]
                                                 placeholderImage:[UIImage imageNamed:@"默认加载图"]];
                    cell.titleLabel.text = itemDetailModel.grade_name;
                    cell.priceLabel.text = [NSString stringWithFormat:@"订单金额:￥%0.2lf", [itemDetailModel.price floatValue]];
                    
                    cell.expireLabel.text = [NSString stringWithFormat:@"有效期至%@", orderPayItemModel.expires];
                }
            }
        }
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
// custom view for header. will be adjusted to default or specified header height
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BXGOrderHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BXGOrderHeaderViewId];
    headerView.title.text = @"订单编号:";
    if(_arrOrderPayItemModel && section<_arrOrderPayItemModel.count) {
        BXGOrderPayItemModel *orderPayItemModel = _arrOrderPayItemModel[section];
        headerView.subtitle.text = orderPayItemModel.order_no; //@"17061615396TR5Ycq6LY";
        NSString *stringStatus = nil;
        if(OrderPayStatus_WaitingForPay == _orderPayStatus) {
            stringStatus = @"待支付";
        } else if(OrderPayStatus_Finished == _orderPayStatus) {
            stringStatus = @"已完成";
        } else if(OrderPayStatus_Invalid == _orderPayStatus) {
            stringStatus = @"已失效";
        }
        headerView.rightTitle.text = stringStatus;
    }
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    Weak(weakSelf);
    BXGOrderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BXGOrderFooterViewId];
    if(_arrOrderPayItemModel && section<_arrOrderPayItemModel.count) {
        BXGOrderPayItemModel *orderPayItemModel = _arrOrderPayItemModel[section];
        CGFloat f = [orderPayItemModel.actual_pay floatValue];
        footerView.leftTitle.text = f>0 ? [NSString stringWithFormat:@"实付金额:￥%0.2f", f] : @"实付金额:￥0.00";

        if(OrderPayStatus_WaitingForPay == _orderPayStatus) {
            [footerView.rightBtn setHidden:NO];
            [footerView setRightBtnEnable:YES];
            [footerView.rightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            footerView.rightBtnBlock = ^{
                NSLog(@"点击立即支付");//todo# 调用第三方支付接口,进行支付操作.

                [[BXGBaiduStatistic share] statisticEventString:kBXGStatMeOrderEventTypeToPay andLabel:nil];
                
                [[BXGHUDTool share] showLoadingHUDWithString:@"正在加载"];
                [_payManager loadOrderToPayWithOrderId:orderPayItemModel.idx
                                            andOrderNo:orderPayItemModel.order_no
                                               andType:orderPayItemModel.pay_type.stringValue
                                           andFinished:^(BXGOrderStatusType status, NSString * _Nullable msg , BXGOrderPayBaseModel* payModel) {
                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kOrderDelayCloseHUDSecond * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                   [[BXGHUDTool share] closeHUD];
                                               });
                                           }];
            };
        } else if(OrderPayStatus_Finished == _orderPayStatus) {
            [footerView.rightBtn setHidden:YES];
        } else if(OrderPayStatus_Invalid == _orderPayStatus) {
            BXGOrderPayItemModel *orderPayItemModel = _arrOrderPayItemModel[section];
            [footerView.rightBtn setHidden:NO];
            [footerView.rightBtn setTitle:@"重新支付" forState:UIControlStateNormal];
            if(orderPayItemModel.orderDetail) {
                if(orderPayItemModel.orderDetail.count>1) {
                    [footerView setRightBtnEnable:NO]; //已失效的多课程订单，重新支付按钮置灰
                } else {
                    [footerView setRightBtnEnable:YES];
                    footerView.rightBtnBlock = ^{
                        NSLog(@"点击重新支付");//进入订单确认页面
                        
                        [[BXGBaiduStatistic share] statisticEventString:kBXGStatMeOrderEventTypeReFillOrder andLabel:nil];
                        
                        BXGOrderFillOrderVC *vc = [BXGOrderFillOrderVC new];
                        NSMutableArray *arrCourseId = [NSMutableArray new];
                        for(BXGOrderPayItemDetailModel *detailModel in orderPayItemModel.orderDetail) {
                            [arrCourseId addObject:[detailModel.idx stringValue]];
                        }
                        vc.arrCourseId = [NSArray arrayWithArray:arrCourseId];
                        [self.navigationController pushViewController:vc animated:YES];
                    };
                }
            }
        }
    }
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 93+15*2;
    return SCREEN_WIDTH / 3.4;
//    return 15*2+(self.tableView.bounds.size.width) / 3.4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 43;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = 49+9;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *orderId = nil;
    NSString *orderNo = nil;
    BXGOrderPayItemModel *orderPayItemModel = nil;
    if(_arrOrderPayItemModel && indexPath.section<_arrOrderPayItemModel.count) {
        orderPayItemModel = _arrOrderPayItemModel[indexPath.section];
        orderId = orderPayItemModel.idx;
        orderNo = orderPayItemModel.order_no;
    }
    
    if(_orderPayStatus == OrderPayStatus_Finished || _orderPayStatus == OrderPayStatus_Invalid) {
        
        if(_orderPayStatus==OrderPayStatus_Invalid) {
            if(orderPayItemModel && orderPayItemModel.orderDetail.count>1) {
                [[BXGHUDTool share] showHUDWithString:kBXGToastOrderMultiCoursePay];
                return ;//已失效的多课程订单, 不可点击(列表和详情页)
            }
        }
        
        BXGOrderFinishedVC *finishedVC = [BXGOrderFinishedVC new];
        finishedVC.orderNo = orderNo;
        finishedVC.orderId = orderId;
        finishedVC.orderPayStatus = _orderPayStatus;
        [self.navigationController pushViewController:finishedVC animated:YES];
    } else {
        BXGOrderPayVC *payVC = [BXGOrderPayVC new];
        payVC.orderId = orderId;
        payVC.orderNo = orderNo;
        [self.navigationController pushViewController:payVC animated:YES];
    }
}

@end
