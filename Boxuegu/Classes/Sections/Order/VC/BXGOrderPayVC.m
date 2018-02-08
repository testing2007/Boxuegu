//
//  BXGOrderPayVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderPayVC.h"
#import "BXGOrderPayResultVC.h"
#import "BXGOrderBuyCourseCell.h"
#import "BXGOrderHeaderView.h"
#import "BXGOrderPayStyleCell.h"
#import "BXGOrderPriceCell.h"
#import "BXGOrderConfirmBottomView.h"
#import "BXGOrderHelper.h"
#import "BXGOrderPayItemModel.h"
#import "BXGOrderPayItemDetailModel.h"
#import "BXGOrderCancelObject.h"
#import "RWCommonFunction.h"
#import "BXGPayManager.h"

@interface BXGOrderDetailHeaderView : UITableViewHeaderFooterView
@property(nonatomic, weak) UILabel *serialNumberLabel;
@property(nonatomic, weak) UILabel *orderTimeLabel;
@end
@implementation BXGOrderDetailHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self) {
        [self installUI];
    }
    return self;
}

- (void)installUI {
    self.contentView.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    
    UILabel *numId = [UILabel new];
    [numId setTextColor:[UIColor colorWithHex:0x666666]];
    [numId setFont:[UIFont bxg_fontRegularWithSize:15]];
    numId.text = @"订单编号:";
    [self.contentView addSubview:numId];

    UILabel *serialNumberLabel = [UILabel new];
    [serialNumberLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [serialNumberLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.contentView addSubview:serialNumberLabel];
    _serialNumberLabel = serialNumberLabel;

    UILabel *timeId = [UILabel new];
    [timeId setTextColor:[UIColor colorWithHex:0x666666]];
    [timeId setFont:[UIFont bxg_fontRegularWithSize:15]];
    timeId.text = @"订单时间:";
    [self addSubview:timeId];

    UILabel *orderTimeLabel = [UILabel new];
    [orderTimeLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [orderTimeLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.contentView addSubview:orderTimeLabel];
    _orderTimeLabel = orderTimeLabel;

    UILabel *waitingPayLabel = [UILabel new];
    [waitingPayLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [waitingPayLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    waitingPayLabel.text = @"待支付";
    [self.contentView addSubview:waitingPayLabel];

    [numId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(14);
        make.height.equalTo(@15);
    }];
    [serialNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numId.mas_right).offset(1);
        make.top.equalTo(numId.mas_top);
        make.height.equalTo(numId.mas_height);
    }];
    [timeId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numId.mas_left);
        make.top.equalTo(numId.mas_bottom).offset(10);
        make.height.equalTo(numId.mas_height);
    }];
    [orderTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(serialNumberLabel.mas_left);
        make.top.equalTo(timeId.mas_top);
        make.height.equalTo(numId.mas_height);
    }];
    [waitingPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.offset(-15);
    }];
}
@end

static NSString *BXGOrderDetailHeaderViewId = @"BXGOrderDetailHeaderView";
static NSString *BXGOrderHeaderViewId = @"BXGOrderHeaderView";
static NSString *BXGOrderPayStyleCellId = @"BXGOrderPayStyleCell";
static NSString *BXGOrderPriceCellId = @"BXGOrderPriceCell";

@interface BXGOrderPayVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) BXGOrderHelper *orderHelper;
@property(nonatomic, strong) BXGOrderPayItemModel *orderPayItemModel;
@property(nonatomic, weak) UITableView *tableView;
@property(nonatomic, weak) BXGOrderConfirmBottomView *confirmBottomView;
@property(nonatomic, assign) PayStyle payStyle;
@property(nonatomic, strong) BXGOrderCancelObject *orderCancelObj;
@property(nonatomic, strong) BXGPayManager *payManager;
@end

@implementation BXGOrderPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
        
    _payManager = [BXGPayManager new];
    _payManager.delegate = self;

    [self installNavigationBarItem];
    [self installUI];
    
    _payStyle = PayStyle_WeiXin;
    
    [_tableView registerClass:[BXGOrderDetailHeaderView class] forHeaderFooterViewReuseIdentifier:BXGOrderDetailHeaderViewId];
    [_tableView registerClass:[BXGOrderHeaderView class] forHeaderFooterViewReuseIdentifier:BXGOrderHeaderViewId];
    [_tableView registerClass:[BXGOrderBuyCourseCell class] forCellReuseIdentifier:BXGOrderBuyCourseCellId_PriceImportantShow];
    [_tableView registerClass:[BXGOrderPayStyleCell class] forCellReuseIdentifier:BXGOrderPayStyleCellId];
    [_tableView registerClass:[BXGOrderPriceCell class] forCellReuseIdentifier:BXGOrderPriceCellId];
    
    _orderCancelObj = [BXGOrderCancelObject new];
    
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
            _confirmBottomView.payAmountLabel.text = @"实付金额: ";
            CGFloat f = [_orderPayItemModel.actual_pay floatValue];
            _confirmBottomView.amountLabel.text = f>0 ? [NSString stringWithFormat:@"￥%0.2f", f] : @"￥0.00";
            [_confirmBottomView.confirmBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        } else {
            [self.tableView installMaskView:BXGMaskViewTypeLoadFailed];
        }
        [_tableView reloadData];
    }];
}

- (void)installNavigationBarItem
{
    [super installNavigationBar];
    
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

- (void)popCancelMenu {
    [[BXGBaiduStatistic share] statisticEventString:kBXGStatOrderDetailEventTypeCancleOrder andLabel:nil];
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
                                 [[BXGBaiduStatistic share] statisticEventString:kBXGStatOrderDetailEventTypeCancleOrderToastAccept andLabel:nil];
                                 [weakSelf _payOrder];
                             } andCancelPayBlock:^(BOOL bSuccess, NSError *error) {
                                 [[BXGBaiduStatistic share] statisticEventString:kBXGStatOrderDetailEventTypeCancleOrderToastCancle andLabel:nil];
                                 if(bSuccess) {
                                     [[BXGHUDTool share] showHUDWithString:@"订单取消成功"];
                                     [weakSelf.navigationController popViewControllerAnimated:YES];
                                     [BXGNotificationTool postNotificationForOrderCancelOK];
                                 } else {
                                     [[BXGHUDTool share] showHUDWithString:@"订单取消失败"];
                                 }
                             }];
}

- (void)installUI {
    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    tableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    [self.view addSubview:tableView];
    _tableView = tableView;

    Weak(weakSelf)
    BXGOrderConfirmBottomView *confirmBottomView = [BXGOrderConfirmBottomView new];
    confirmBottomView.payAmountLabel.text = @"实付金额: ";
    [confirmBottomView.confirmBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    confirmBottomView.submitOrderBlock = ^{
        [[BXGBaiduStatistic share] statisticEventString:kBXGStatOrderDetailEventTypeAliPay andLabel:nil];
        NSLog(@"点击立即支付");//todo#
        [weakSelf _payOrder];
    };
    [self.view addSubview:confirmBottomView];
    _confirmBottomView = confirmBottomView;

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET+9);
        make.bottom.offset(-kBottomTabbarViewHeight-kBottomHeight);
    }];

    [_confirmBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(-kBottomHeight);
//        make.height.equalTo(@56);
        make.height.offset(kBottomTabbarViewHeight);
    }];
    _confirmBottomView.backgroundColor = [UIColor whiteColor];
    UIView *sp = [UIView new];
    sp.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [_confirmBottomView addSubview:sp];
    [sp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        make.height.offset(kBottomTabbarViewSpHeight);
    }];
}

- (void)_payOrder {
    if(_payManager) {
        [[BXGHUDTool share] showLoadingHUDWithString:@"正在加载"];
        [_payManager loadOrderToPayWithOrderId:_orderPayItemModel.idx
                                    andOrderNo:_orderPayItemModel.order_no
                                       andType:[_orderPayItemModel.pay_type stringValue]
                                   andFinished:^(BXGOrderStatusType status, NSString * _Nullable msg , BXGOrderPayBaseModel* payModel) {
                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kOrderDelayCloseHUDSecond * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                           [[BXGHUDTool share] closeHUD];
                                       });
                                   }];
    }
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
            BXGOrderDetailHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BXGOrderDetailHeaderViewId];
        
            headerView.serialNumberLabel.text = _orderPayItemModel.order_no;
            headerView.orderTimeLabel.text = _orderPayItemModel.create_time;
            retView = headerView;
        }
            break;
        case 1:
        {
            BXGOrderHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BXGOrderHeaderViewId];
            headerView.title.text = @"支付方式";
            headerView.subtitle.text = @"(支付完成后, 我们为您分配班级!)";
            retView = headerView;
        }
            break;
        case 2:
            break;
        default:
            break;
    }
    return retView;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger retRow = 0;
    switch (section) {
        case 0:
        {
            if(_orderPayItemModel && _orderPayItemModel.orderDetail) {
                retRow = _orderPayItemModel.orderDetail.count;
            }
        }
            break;
        case 1:
            retRow = 1;
            break;
        case 2:
            retRow = 3;
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
//                        cell.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", [itemDetailModel.price floatValue]];
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
            BXGOrderPayStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:BXGOrderPayStyleCellId forIndexPath:indexPath];
            NSString *strText = nil;
            if(indexPath.row == 0) {
                strText = @"微信支付";
                [cell.identifyImageView setImage:[UIImage imageNamed:@"微信"]];
                if(_payStyle==PayStyle_WeiXin) {
                    [cell.optionImageView setIsSel:YES];
                }else {
                    [cell.optionImageView setIsSel:NO];
                }
            } /*else if(indexPath.row == 1) {
                strText = @"支付宝支付";
                [cell.identifyImageView setImage:[UIImage imageNamed:@"支付宝"]];
                if(_payStyle==PayStyle_ZhiFuBao) {
                    [cell.optionImageView setIsSel:YES];
                } else {
                    [cell.optionImageView setIsSel:NO];
                }
            }
            //*/
            cell.nameLabel.text = strText;
            retCell = cell;
        }
            break;
        case 2:
        {
            BXGOrderPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:BXGOrderPriceCellId forIndexPath:indexPath];
            if(_orderPayItemModel) {
                BXGOrderPayItemModel *itemModel = _orderPayItemModel;
                if(itemModel) {
                    if(indexPath.row == 0) {
                        cell.nameLabel.text = @"订单金额";
//                        cell.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f", [itemModel.original_cost floatValue]];
                        CGFloat f = [itemModel.original_cost floatValue];
                        cell.priceLabel.text = f>0 ? [NSString stringWithFormat:@"￥%0.2f", f] : @"￥0.00";
                    } else if(indexPath.row == 1) {
                        cell.nameLabel.text = @"优惠券折扣";
//                        cell.priceLabel.text = [NSString stringWithFormat:@"-￥%0.2f", [itemModel.preferenty_money floatValue]];
                        CGFloat f = [itemModel.preferenty_money floatValue];
                        cell.priceLabel.text = f>0 ? [NSString stringWithFormat:@"-￥%0.2f", f] : @"-￥0.00";
                    }
                    else if(indexPath.row == 2) {
                        cell.nameLabel.text = @"满减优惠";
//                        cell.priceLabel.text = [NSString stringWithFormat:@"-￥%0.2f", [itemModel.discount_count floatValue]];
                        CGFloat f = [itemModel.discount_count floatValue];
                        cell.priceLabel.text = f>0 ? [NSString stringWithFormat:@"-￥%0.2f", f] : @"-￥0.00";
                    }
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
            height = 51;
            break;
        case 2:
            height = 51;
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
            height = 64;
            break;
        case 1:
            height = 41;
            break;
        case 2:
            height = 0.01;
            break;
        default:
            NSAssert(NO, @"heightForHeaderInSection");
            break;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1) {
        if(indexPath.row==0) {
            _payStyle = PayStyle_WeiXin;
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatOrderDetailEventTypeWeChatPay andLabel:nil];
        } else if(indexPath.row==1) {
            _payStyle = PayStyle_ZhiFuBao;
        }
    }
    [self.tableView reloadData];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section   // custom view for footer. will be adjusted to default or specified footer height
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 9;
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
