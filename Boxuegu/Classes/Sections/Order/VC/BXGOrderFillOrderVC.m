//
//  BXGOrderFillOrderVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderFillOrderVC.h"
#import "BXGMeCouponVC.h"
#import "BXGOrderPayResultVC.h"
#import "BXGOrderProtocolVC.h"
#import "BXGOrderHeaderView.h"
#import "BXGOrderBuyCourseCell.h"
#import "BXGOrderPayStyleCell.h"
#import "BXGOrderCouponCell.h"
#import "BXGOrderPriceCell.h"
#import "BXGOrderProtocolCell.h"
#import "BXGOrderConfirmBottomView.h"
#import "BXGOrderHelper.h"
#import "BXGOrderOutlineModel.h"
#import "BXGOrderDetailModel.h"
#import "BXGOrderCourseModel.h"
#import "BXGOrderCouponModel.h"
#import "BXGOrderCouponVC.h"
#import "BXGPayProtocolVC.h"

#import "BXGOrderPayVC.h"//for debug
#import "BXGPayManager.h"
#import "BXGOrderPayResultViewModel.h"
#import "BXGOrderPayResultVC.h"
#import "BXGOrderPayBaseModel.h"
#import "BXGOrderPayFreeModel.h"
#import "BXGOrderPayWechatModel.h"
#import "BXGPayManager.h"

@interface BXGOrderFillOrderVC ()<UITableViewDelegate, UITableViewDataSource, BXGPay>

@property(nonatomic, strong) BXGOrderHelper *orderHelper;
@property(nonatomic, strong) BXGOrderOutlineModel *orderOutlineMode;
@property(nonatomic, weak) BXGOrderDetailModel *orderDetailMode;

@property(nonatomic, weak) UITableView *tableView;
@property(nonatomic, weak) BXGOrderConfirmBottomView *confirmBottomView;

@property(nonatomic, assign) PayStyle payStyle;
@property(nonatomic, assign) BOOL bReadProtocol;

@property(nonatomic, strong) BXGPayManager *payManager;

@property(nonatomic, strong) NSMutableDictionary *selCourseAndCouponDict;//课程id <key=string>-优惠券id映射<value=NSString>
@property(nonatomic, strong) NSMutableDictionary *tempSelCourseAndCouponDict;//课程id <key=string>-优惠券id映射<value=NSString>
@property(nonatomic, assign) BOOL bInitial;

@property(nonatomic, strong) NSString *strCourseId;

@end

static NSString *BXGOrderHeaderViewId = @"BXGOrderHeaderView";
static NSString *BXGOrderPayStyleCellId = @"BXGOrderPayStyleCell";
static NSString *BXGOrderCouponCellId = @"BXGOrderCouponCell";
static NSString *BXGOrderPriceCellId = @"BXGOrderPriceCell";
static NSString *BXGOrderProtocolCellId = @"BXGOrderProtocolCell";

@implementation BXGOrderFillOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单确认";
    self.pageName = @"订单确认";
    _bReadProtocol = YES;
    _payStyle = PayStyle_WeiXin;
    _payManager = [BXGPayManager new];
    _payManager.delegate = self;
    
    _selCourseAndCouponDict = [NSMutableDictionary new];
    _tempSelCourseAndCouponDict = [NSMutableDictionary new];
    
    _orderHelper = [BXGOrderHelper new];
    _bInitial = YES;
    
    NSString *strCourseId = [NSString new];
    int index = 0;
    for(NSString *courseId in _arrCourseId) {
        strCourseId = [strCourseId stringByAppendingString:[NSString stringWithFormat:@"%@", courseId]];
        if(index<_arrCourseId.count-1) {
            strCourseId = [strCourseId stringByAppendingString:@","];
        }
        index++;
    }
    _strCourseId = strCourseId;

    [self installUI];
    
    [_tableView registerClass:[BXGOrderHeaderView class] forHeaderFooterViewReuseIdentifier:BXGOrderHeaderViewId];
    [_tableView registerClass:[BXGOrderBuyCourseCell class] forCellReuseIdentifier:BXGOrderBuyCourseCellId_PriceImportantShow];
    [_tableView registerClass:[BXGOrderPayStyleCell class] forCellReuseIdentifier:BXGOrderPayStyleCellId];
    [_tableView registerClass:[BXGOrderCouponCell class] forCellReuseIdentifier:BXGOrderCouponCellId];
    [_tableView registerClass:[BXGOrderPriceCell class] forCellReuseIdentifier:BXGOrderPriceCellId];
    [_tableView registerClass:[BXGOrderProtocolCell class] forCellReuseIdentifier:BXGOrderProtocolCellId];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadNetworkRequestIsInitial:_bInitial andArrCourseId:_strCourseId andDictionary:_tempSelCourseAndCouponDict];
    _bInitial = NO;
}

- (void)loadNetworkRequestIsInitial:(BOOL)bInitial
                     andArrCourseId:(NSString*)courseIds
                      andDictionary:(NSDictionary*)dict {
    __weak typeof(self) weakSelf = self;
    //    NSString *jsonStr = [dict yy_modelToJSONString];
    NSMutableString *str = nil;
    
    if(dict) {
        if(dict.count==0) {
            NSAssert(_strCourseId!=nil, @"course is not to be nil");
            NSArray<NSString*> *arrCourseId = [_strCourseId componentsSeparatedByString:@","];
            if(arrCourseId!=nil) {
                str = [NSMutableString new];
                [str appendString:@"{"];
                int i=0;
                for(NSString *courseIdItem in arrCourseId) {
                    if(i>=1) {
                        [str appendString:@","];
                    }
                    [str appendString:[NSString stringWithFormat:@"%@:-1", courseIdItem]];
                    i++;
                }
                [str appendString:@"}"];
            } else {
                str = [NSMutableString new];
                [str appendString:[NSString stringWithFormat:@"{%@:-1}", _strCourseId]];
            }
            
        } else {
            NSArray * array = [dict allKeys];
            int i=0;
            for (NSString * key in array) {
                NSString *val = dict[key];
                if(str==nil) {
                    str = [NSMutableString new];
                    //                [str stringByAppendingString:@"{"];
                    [str appendString:@"{"];
                }
                if(val) {
                    if(i>=1) {
                        [str appendString:@","];
                    }
                    NSString *strKeyValue = [NSString stringWithFormat:@"%@:%@", key, val];
                    [str appendString:strKeyValue];
                    i++;
                }
            }
            
            if(str) {
                [str appendString:@"}"];
            }
        }
    }
    
    [self.view removeMaskView];
    [[BXGHUDTool share] showLoadingHUDWithString:@"正在加载"];
    [_orderHelper loadOrderSubmitOutlineIsInitial:[NSNumber numberWithBool:!bInitial]
                                andOrderCourseIds:courseIds
                                andCourseCouponId:str //todo#
                                   andFinishBlock:^(BOOL bSuccess, NSError *error, BXGOrderOutlineModel *orderOutlineModel) {
                                       if(bSuccess && orderOutlineModel) {
                                           weakSelf.orderOutlineMode = orderOutlineModel;
                                           CGFloat f = [_orderOutlineMode.total_amount floatValue];
                                           weakSelf.confirmBottomView.amountLabel.text = f>=0 ? [NSString stringWithFormat:@"￥%0.2f", f] : @"￥0.00";
                                           if(orderOutlineModel.detail) {
                                               _orderDetailMode = orderOutlineModel.detail[0];
                                               
                                               if(_orderDetailMode.courses) {
                                                   for(BXGOrderCourseModel *courseItem in _orderDetailMode.courses) {
                                                       NSNumber *couponId = courseItem.currentCoupon;
                                                       if(couponId && couponId.integerValue>0) {
                                                           [weakSelf.tempSelCourseAndCouponDict removeAllObjects];
                                                           [weakSelf.tempSelCourseAndCouponDict setObject:couponId.stringValue forKey:courseItem.idx];
                                                           [weakSelf.selCourseAndCouponDict removeAllObjects];
                                                           [weakSelf.selCourseAndCouponDict setObject:couponId.stringValue forKey:courseItem.idx];
                                                           break;
                                                       } else {
                                                           [weakSelf.tempSelCourseAndCouponDict removeAllObjects];
                                                           [weakSelf.selCourseAndCouponDict removeAllObjects];
                                                       }
                                                   }
                                               }
                                           }
                                           
                                           [weakSelf.tableView reloadData];
                                           [[BXGHUDTool share] closeHUD];
                                           
                                       } else {
                                           [[BXGHUDTool share] closeHUD];
//                                           [[BXGHUDTool share] showHUDWithString:@"兑换优惠券失败,请重新兑换!"];
                                           [weakSelf.view installMaskView:BXGButtonMaskViewTypeLoadFailed
                                                                 andInset:UIEdgeInsetsMake(K_NAVIGATION_BAR_OFFSET, 0, 0, 0)
                                                              buttonBlock:^{
                                               [weakSelf loadNetworkRequestIsInitial:NO andArrCourseId:weakSelf.strCourseId andDictionary:weakSelf.tempSelCourseAndCouponDict];
                                           }];
                                       }
                                   }];
}

- (void)installUI {
    
    __weak typeof(self) weakSelf = self;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    tableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    BXGOrderConfirmBottomView *confirmBottomView = [BXGOrderConfirmBottomView new];
    confirmBottomView.payAmountLabel.text = @"应付金额: ";
    [confirmBottomView.confirmBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    confirmBottomView.submitOrderBlock = ^{
        //todo#
        [[BXGBaiduStatistic share] statisticEventString:kBXGStatFillOrderEventTypeCommitOrder andLabel:nil];
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        for(BXGOrderCourseModel *courseModelItem in _orderDetailMode.courses) {
            NSString *strCouponId = [_selCourseAndCouponDict objectForKey:courseModelItem.idx];
            [dict setObject:strCouponId?:@-1 forKey:courseModelItem.idx];
        }

        NSAssert(dict.count>0, @"course_id shouldn't be empty");
        //*
        NSString *payType = [NSString stringWithFormat:@"%u", _payStyle];
        
        [[BXGHUDTool share] showLoadingHUDWithString:nil];
        [_payManager loadSaveOrderCourseCouponDict:dict
                                                      andTotalAmount:_orderDetailMode.total_amount
                                                        andOrderFrom:@"4"
                                                          andPayType:payType
                                                      andFinishBlock:^(BXGOrderStatusType status, NSString *msg, BXGOrderPayBaseModel *payModel) {
                                                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kOrderDelayCloseHUDSecond * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                [[BXGHUDTool share] closeHUD];
                                                          });
                                                      }
         ];
    };
    [self.view addSubview:confirmBottomView];
    _confirmBottomView = confirmBottomView;
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
//        make.bottom.offset(-56-kBottomHeight);
        make.bottom.offset(-kBottomTabbarViewHeight-kBottomHeight);
    }];
    
    [_confirmBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(-kBottomHeight);
//        make.height.equalTo(@56);
        make.height.offset(kBottomTabbarViewHeight);
    }];
    UIView *sp = [UIView new];
    sp.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [_confirmBottomView addSubview:sp];
    [sp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        make.height.offset(kBottomTabbarViewSpHeight);
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
            headerView.title.text = @"课程信息";
            headerView.subtitle.text = nil;
            retView = headerView;
        }
            break;
        case 1:
        {
            BXGOrderHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BXGOrderHeaderViewId];
            headerView.title.text = @"支付方式";
            headerView.subtitle.text = @"(支付完成后, 我们为您分配班级!)";
            [headerView.subtitle setFont:[UIFont bxg_fontRegularWithSize:12]];
            retView = headerView;
        }
            break;
        case 2:
        case 3:
        case 4:
            break;
        default:
            break;
    }
    return retView;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger retRow = 0;
    switch (section) {
        case 0:
            retRow = 1;
            break;
        case 1:
            retRow = 1;//支付方式
            break;
        case 2:
            retRow = 1;
            break;
        case 3:
            retRow = 2;
            break;
        case 4:
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
            if(_orderDetailMode && _orderDetailMode.courses && indexPath.row<_orderDetailMode.courses.count) {
                BXGOrderCourseModel *orderCourseModel = (BXGOrderCourseModel*)_orderDetailMode.courses[indexPath.row];
                [cell.courseThumbImageView sd_setImageWithURL:[NSURL URLWithString:orderCourseModel.image]
                                             placeholderImage:[UIImage imageNamed:@"默认加载图"]];
                cell.titleLabel.text = orderCourseModel.name;
//                cell.priceLabel.text = orderCourseModel.price;
//                cell.priceLabel.text = [NSString stringWithFormat:@"￥%0.2lld", [orderCourseModel.price longLongValue]];
                CGFloat f = [orderCourseModel.price floatValue];
                cell.priceLabel.text = f>=0 ? [NSString stringWithFormat:@"￥%0.2f", f] : @"￥0.00";

                cell.expireLabel.text = [NSString stringWithFormat:@"有效期至%@", orderCourseModel.expires];
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
            BXGOrderCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:BXGOrderCouponCellId forIndexPath:indexPath];
            
            
            if(_selCourseAndCouponDict && _selCourseAndCouponDict.count>=1) {
                NSString *strValue  = ((NSString*)_selCourseAndCouponDict.allValues[0]);
                if(strValue.integerValue>0){
                    cell.availableNumLabel.text = @"已选一张";
                } else {
                    if(_orderDetailMode && _orderDetailMode.courses && indexPath.row<_orderDetailMode.courses.count) {
                        NSInteger nTotalUseableCoupons = 0;
                        for(BXGOrderCourseModel* courseModel in _orderDetailMode.courses) {
                            nTotalUseableCoupons += courseModel.useableCouponAmount.longValue;
                        }
                        cell.availableNumLabel.text = [NSString stringWithFormat:@"%ld张可用", (long)nTotalUseableCoupons];
                    }
                }
            } else {
                if(_orderDetailMode && _orderDetailMode.courses && indexPath.row<_orderDetailMode.courses.count) {
                    NSInteger nTotalUseableCoupons = 0;
                    for(BXGOrderCourseModel* courseModel in _orderDetailMode.courses) {
                        nTotalUseableCoupons += courseModel.useableCouponAmount.longValue;
                    }
                    cell.availableNumLabel.text = [NSString stringWithFormat:@"%ld张可用", (long)nTotalUseableCoupons];
                }
            }
            retCell = cell;
        }
            break;
        case 3:
        {
            BXGOrderPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:BXGOrderPriceCellId forIndexPath:indexPath];
            NSString *strText = nil;
            if(indexPath.row == 0) {
                strText = @"商品价格";
            } else if(indexPath.row == 1) {
                strText = @"优惠券折扣";
            }
            cell.nameLabel.text = strText;
                if(indexPath.row==0) {
//                    cell.priceLabel.text = [NSString stringWithFormat:@"￥%0.2lld", [orderCourseModel.price longLongValue]];
                    CGFloat f = [_orderOutlineMode.total_price floatValue];
                    cell.priceLabel.text = f>=0 ? [NSString stringWithFormat:@"￥%0.2f", f] : @"￥0.00";
                } else if(indexPath.row==1) {
                    CGFloat f = [_orderOutlineMode.total_discount_amount floatValue];
                    cell.priceLabel.text = f>=0 ? [NSString stringWithFormat:@"-￥%0.2f", f] : @"-￥0.00";
            }
            retCell = cell;
        }
            break;
        case 4:
        {
            BXGOrderProtocolCell *cell = [tableView dequeueReusableCellWithIdentifier:BXGOrderProtocolCellId forIndexPath:indexPath];
            cell.readProtocolBlock = ^{
                BXGPayProtocolVC *vc = [BXGPayProtocolVC new];
                [self.navigationController pushViewController:vc animated:YES];
            };
            [cell.optImageView setIsSel:_bReadProtocol];
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
        {
            height = SCREEN_WIDTH / 3.4;
        }
//            height = 123;
            break;
        case 1:
            height = 51;
            break;
        case 2:
            height = 51;
            break;
        case 3:
            height = 51;
            break;
        case 4:
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
            height = 41;
            break;
        case 1:
            height = 41;
            break;
        case 2:
        case 3:
        case 4:
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
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatFillOrderEventTypeWeChatPay andLabel:nil];
        } else if(indexPath.row==1) {
            _payStyle = PayStyle_ZhiFuBao;
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatFillOrderEventTypeAliPay andLabel:nil];
        }
    } else if(indexPath.section == 2) {
         [[BXGBaiduStatistic share] statisticEventString:kBXGStatFillOrderEventTypeSelectCoupon andLabel:nil];
        if(_orderDetailMode && _orderDetailMode.courses && indexPath.row<_orderDetailMode.courses.count) {
            BXGOrderCourseModel *orderCourseModel = (BXGOrderCourseModel*)_orderDetailMode.courses[0];
            /*
             if(orderCourseModel.useableCouponAmount.longLongValue <= 0) {
                [[BXGHUDTool share] showHUDWithString:@"没有可用的优惠券"];
                return ;
             }
             //*/
            
            NSString *strCouponId = @"-1";
            if(_selCourseAndCouponDict && _selCourseAndCouponDict.count>=1) {
                strCouponId = _selCourseAndCouponDict.allValues[0];
            }
            BXGOrderCouponVC *couponVC = [[BXGOrderCouponVC alloc] initWithCourseId:orderCourseModel.idx
                                                                         andCoupons:orderCourseModel.coupons
                                                                 andCurrentCouponId:strCouponId
                                                                  andSelectedCoupon:^(NSString *couponId) {
                                                                      
                                                                      [_tempSelCourseAndCouponDict removeAllObjects];
                                                                      if(couponId) {
                                                                          [_tempSelCourseAndCouponDict setObject:couponId forKey:orderCourseModel.idx];
                                                                      } else {
                                                                          [_tempSelCourseAndCouponDict setObject:@"-1" forKey:orderCourseModel.idx];
                                                                      }
                                                                      _strCourseId = orderCourseModel.idx;
                                                                      //[_selCourseAndCouponDict removeAllObjects];
                                                                      //[_selCourseAndCouponDict setObject:couponId
                                                                        //                          forKey:orderCourseModel.idx];
                                                                      /*
                                                                      [self loadNetworkRequestIsInitial:NO
                                                                                         andArrCourseId:orderCourseModel.idx
                                                                                          andDictionary:dict];
                                                                       //*/
                                                                  }];
            [self.navigationController pushViewController:couponVC animated:YES];
        }
    } else if(indexPath.section == 4) {
        _bReadProtocol = !_bReadProtocol;
        [_confirmBottomView confirmIsEnable:_bReadProtocol];
    }
    [self.tableView reloadData];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 9;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section   // custom view for footer. will be adjusted to default or specified footer height
{
    return [UIView new];
}


//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(indexPath.section == 4) {
//        _bReadProtocol = NO;
//    }
//    [self.tableView reloadData];
//}

//- (IBAction)onClickCouponBtn:(id)sender {
//    BXGMeCouponVC *vc = [BXGMeCouponVC new];
//    [self.navigationController pushViewController:vc animated:true];
//}
//- (IBAction)onClickCommitOrderBtn:(id)sender {
//    BXGOrderPayResultVC *vc = [BXGOrderPayResultVC new];
//    [self.navigationController pushViewController:vc animated:true];
//}
//- (IBAction)onClickProtocolBtn:(id)sender {
//    BXGOrderProtocolVC *vc = [BXGOrderProtocolVC new];
//    [self.navigationController pushViewController:vc animated:true];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
