//
//  BXGOrderFinishedVC.m
//  Boxuegu
//
//  Created by apple on 2017/10/26.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderFinishedVC.h"
#import "BXGOrderPayResultVC.h"
#import "BXGOrderBuyCourseCell.h"
#import "BXGOrderHeaderView.h"
#import "BXGOrderPayStyleCell.h"
#import "BXGOrderPriceCell.h"
#import "BXGOrderConfirmBottomView.h"
#import "BXGOrderHelper.h"
#import "BXGOrderPayItemModel.h"
#import "BXGOrderPayItemDetailModel.h"
#import "BXGOrderDetailCell.h"
#import "RWCommonFunction.h"
#import "UIView+Pop.h"
#import "BXGOrderCancelObject.h"
#import "BXGOrderFillOrderVC.h"
#import "BXGPayManager.h"

static NSString *BXGOrderHeaderViewId = @"BXGOrderHeaderView";
static NSString *BXGOrderDetailCellId = @"BXGOrderDetailCell";

@interface BXGOrderFinishedVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) BXGOrderHelper *orderHelper;
@property(nonatomic, strong) BXGOrderPayItemModel *orderPayItemModel;
@property(nonatomic, weak) UITableView *tableView;

@property(nonatomic, strong) BXGOrderCancelObject *orderCancelObj;

@property(nonatomic, strong) BXGPayManager *payManager;

@end

@implementation BXGOrderFinishedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";

    switch (self.orderPayStatus) {
        case OrderPayStatus_WaitingForPay:{
            self.pageName = @"未支付-订单详情页";
        }break;
        case OrderPayStatus_Finished:{
            self.pageName = @"已支付-订单详情页";
        }break;
        case OrderPayStatus_Invalid:{
            self.pageName = @"已关闭-订单详情页";
        }break;
    }
    
    _payManager = [BXGPayManager new];
    _payManager.delegate = self;
    
    NSAssert(_orderPayStatus!=OrderPayStatus_WaitingForPay, @"the state couldn't be support for the view");

//    [self installNavigationBarItem];
    [self installUI];
    
    _orderCancelObj = [BXGOrderCancelObject new];

    [_tableView registerClass:[BXGOrderHeaderView class] forHeaderFooterViewReuseIdentifier:BXGOrderHeaderViewId];
    [_tableView registerClass:[BXGOrderBuyCourseCell class] forCellReuseIdentifier:BXGOrderBuyCourseCellId_PriceImportantShow];
    [_tableView registerClass:[BXGOrderDetailCell class] forCellReuseIdentifier:BXGOrderDetailCellId];
    
    _orderHelper = [BXGOrderHelper new];
    [self installPullRefresh];
}

-(void)installPullRefresh
{
    __weak typeof(self) weakSelf = self;
    [_tableView bxg_setHeaderRefreshBlock:^{
        [weakSelf refreshUI];
    }];
    // 马上进入刷新状态
    [self.tableView bxg_beginHeaderRefresh];
}

-(void)refreshUI
{
    _orderPayItemModel = nil;
    [_orderHelper loadOrderDetailWithOrderId:_orderId andFinishBlock:^(BOOL bSuccess, NSError *error, BXGOrderPayItemModel *orderItemModel) {
        [self.tableView bxg_endHeaderRefresh];
        if(bSuccess) {
            _orderPayItemModel = orderItemModel;
        } else {
            [self.tableView installMaskView:BXGMaskViewTypeLoadFailed];
        }
        
        [_tableView reloadData];
    }];
}

/*
- (void)installNavigationBarItem
{
    [super installNavigationBar];
    
    if(_orderPayStatus==OrderPayStatus_Invalid) {
        // 导航栏
        BarElement *cancelOrderBarElement = [BarElement new];
        cancelOrderBarElement.target = self;
        cancelOrderBarElement.sel = @selector(popCancelMenu);
        cancelOrderBarElement.imageName = @"更多";
        cancelOrderBarElement.size = CGSizeMake(RWAutoFontSize(24), RWAutoFontSize(24));
        cancelOrderBarElement.tintColor = [UIColor whiteColor];
        
        BXGBaseNaviController *navi = (BXGBaseNaviController*)self.navigationController;
        NSArray *arrRightBarItems =  [navi createNaviBarItemsWithBarElements:@[cancelOrderBarElement]
                                                             andBarItemSpace:0];
        self.navigationItem.rightBarButtonItems = arrRightBarItems;
    }
}

- (void)_payOrder {
    if(_orderPayItemModel) {
        [[BXGHUDTool share] showLoadingHUDWithString:nil];
        [_payManager loadOrderToPayWithOrderId:_orderPayItemModel.idx
                                    andOrderNo:_orderPayItemModel.order_no
                                       andType:_orderPayItemModel.pay_type.stringValue
                                   andFinished:^(BXGOrderStatusType status, NSString * _Nullable msg, BXGOrderPayBaseModel *payModel) {
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kOrderDelayCloseHUDSecond * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                           [[BXGHUDTool share] closeHUD];
                                       });
                                   }];
    }
}

- (void)popCancelMenu {
    __weak typeof(self) weakSelf = self;
    CGFloat rightOffsetWindow = 13;
    [_orderCancelObj loadCancelMenuViewContraint:^(MASConstraintMaker *make) {
        make.right.offset(-rightOffsetWindow);
        make.top.offset(K_NAVIGATION_BAR_OFFSET-8);
        make.width.equalTo(@150);
        make.height.equalTo(@48);
    }
                                       andOwnerVC:self
                                       andOrderNo:_orderNo
                             andContinuePayBlock:^{
                                 [weakSelf _payOrder];
                             } andCancelPayBlock:^(BOOL bSuccess, NSError *error) {
                                 if(bSuccess) {
                                     [[BXGHUDTool share] showHUDWithString:@"订单取消成功"];
                                     [weakSelf.navigationController popViewControllerAnimated:YES];
                                 } else {
                                     [[BXGHUDTool share] showHUDWithString:@"订单取消失败"];
                                 }
                             }];
}
//*/

- (void)installUI {
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    tableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    [self.view addSubview:tableView];
    _tableView = tableView;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET+9);
        make.bottom.offset(_orderPayStatus==OrderPayStatus_Invalid? -kBottomTabbarViewHeight-kBottomHeight : -kBottomHeight);
    }];
    
    if(_orderPayStatus==OrderPayStatus_Invalid) {
        UIButton *reBuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [reBuyBtn setBackgroundColor:[UIColor colorWithHex:0x38ADFF]];
        [reBuyBtn setTitle:@"重新购买" forState:UIControlStateNormal];
        [reBuyBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
        [reBuyBtn addTarget:self action:@selector(reBuy:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:reBuyBtn];

        [reBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tableView.mas_bottom).offset(0);
            make.left.right.offset(0);
            make.bottom.offset(-kBottomHeight);
            // make.height.equalTo(@56);
            make.height.offset(kBottomTabbarViewHeight);
        }];
        
        UIView *sp = [UIView new];
        sp.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        [reBuyBtn addSubview:sp];
        [sp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.right.offset(0);
            make.height.offset(kBottomTabbarViewSpHeight);
        }];
    }
}

- (void)reBuy:(UIButton*)sender {

    [[BXGBaiduStatistic share] statisticEventString:kBXGStatOrderDetailEventTypeReFillOrder andLabel:nil];
    NSLog(@"点击重新购买");
    if(_orderPayItemModel) {
        BXGOrderFillOrderVC *vc = [BXGOrderFillOrderVC new];
        NSMutableArray *arrCourseId = [NSMutableArray new];
        for(BXGOrderPayItemDetailModel *detailModel in _orderPayItemModel.orderDetail) {
            [arrCourseId addObject:[detailModel.idx stringValue]];
        }
        vc.arrCourseId = [NSArray arrayWithArray:arrCourseId];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger retRow = 0;
    switch (section) {
        case 0:
        {
            if(_orderPayItemModel) {
                BXGOrderPayItemModel *itemModel = _orderPayItemModel;
                if(itemModel && itemModel.orderDetail) {
                    retRow = itemModel.orderDetail.count;
                }
            }
        }
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
            BXGOrderBuyCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:BXGOrderBuyCourseCellId_PriceImportantShow forIndexPath:indexPath];
            if(_orderPayItemModel) {
                BXGOrderPayItemModel *itemModel = _orderPayItemModel;
                if(itemModel && itemModel.orderDetail) {
                    NSArray<BXGOrderPayItemDetailModel*> *arrItemDetailModel = itemModel.orderDetail;
                    if(arrItemDetailModel && indexPath.row<arrItemDetailModel.count) {
                        BXGOrderPayItemDetailModel *itemDetailModel = arrItemDetailModel[indexPath.row];
                        [cell.courseThumbImageView sd_setImageWithURL:[NSURL URLWithString:itemDetailModel.smallimg_path]
                                                     placeholderImage:[UIImage imageNamed:@"默认加载图"]];
                        cell.titleLabel.text = itemDetailModel.grade_name;
//                        cell.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f元", [itemDetailModel.price floatValue]];
                        CGFloat f = [itemDetailModel.price floatValue];
                        cell.priceLabel.text = f>0 ? [NSString stringWithFormat:@"￥%0.2f", f] : @"￥0.00";
                        cell.expireLabel.text = [NSString stringWithFormat:@"有效期至%@", itemModel.expires];
                    }
                }
            }
            retCell = cell;
        }
            break;
            
        case 1:
        {
            BXGOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:BXGOrderDetailCellId forIndexPath:indexPath];
            if(_orderPayItemModel) {
                BXGOrderPayItemModel *itemModel = _orderPayItemModel;
                NSString *strPayType = nil;
                switch([itemModel.pay_type integerValue])
                {
                        //支付类型 0:微信 1:支付宝 2:网银
                    case 0:
                        strPayType = @"微信";
                        break;
                    case 1:
                        strPayType = @"支付宝";
                        break;
                    case 2:
                        strPayType = @"网银";
                        break;
                }
                cell.payStyleLabel.text = strPayType;
                
                CGFloat f = [itemModel.original_cost floatValue];
                cell.amountLabel.text = f>0 ? [NSString stringWithFormat:@"￥%0.2f", f] : @"￥0.00";
                //cell.amountLabel.text = [NSString stringWithFormat:@"￥%0.2f", [itemModel.actual_pay floatValue]];
                f = [itemModel.preferenty_money floatValue];
                cell.discountAmountLabel.text = f>0 ? [NSString stringWithFormat:@"￥%0.2f", f] : @"￥0.00";
                //cell.discountAmountLabel.text = [NSString stringWithFormat:@"￥%0.2f", [itemModel.preferenty_money floatValue]];
                f = [itemModel.discount_count floatValue];
                cell.overAmountLabel.text = f>0 ? [NSString stringWithFormat:@"￥%0.2f", f] : @"￥0.00";
//                cell.overAmountLabel.text = [NSString stringWithFormat:@"￥%0.2f", [itemModel.discount_count floatValue]];
                f = [itemModel.actual_pay floatValue];
                cell.payPriceLabel.text = f>0 ? [NSString stringWithFormat:@"￥%0.2f", f] : @"￥0.00";
//                cell.payPriceLabel.text = [NSString stringWithFormat:@"￥%0.2f", [itemModel.actual_pay floatValue]];
                
                cell.orderTimeLabel.text = itemModel.create_time;
                if(_orderPayStatus == OrderPayStatus_Finished) {
                    cell.payTimeLabel.text = itemModel.pay_time;
                } else if(_orderPayStatus == OrderPayStatus_Invalid) {
                    cell.payTimeLabel.text = @"------";
                }
            }
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
//            height = 30+93;
            height = SCREEN_WIDTH / 3.4;
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
            height = 43;
            break;
        case 1:
            height = 9;
            break;
        default:
            NSAssert(NO, @"heightForHeaderInSection");
            break;
    }
    return height;
}



- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {   // custom view for header. will be adjusted to default or specified header height
    UIView *retView = nil;
    switch (section) {
        case 0:
        {
            BXGOrderHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BXGOrderHeaderViewId];
            if(_orderPayItemModel) {
                headerView.title.text = @"订单编号:";
                headerView.subtitle.text = _orderPayItemModel.order_no;
                NSString *strText = nil;
                switch(_orderPayStatus) {
                    case OrderPayStatus_WaitingForPay:
                        NSAssert(YES, @"couldn't be support");
                        break;
                    case OrderPayStatus_Invalid:
                        strText = @"已失效";
                        break;
                    case OrderPayStatus_Finished:
                        strText = @"已完成";
                        break;
                }
                headerView.rightTitle.text = strText;
            }
            retView = headerView;
        }
            break;
        case 1:
        {
            retView = [[UIView alloc] init];
            retView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
        }
            break;
        default:
            break;
    }
    return retView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section   // custom view for footer. will be adjusted to default or specified footer height
{
    return [UIView new];
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

