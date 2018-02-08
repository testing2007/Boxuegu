//
//  BXGPayManager.m
//  Boxuegu
//
//  Created by apple on 2017/11/11.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPayManager.h"
#import "BXGOrderHelper.h"
#import "BXGNetWorkParser.h"
#import "BXGOrderSaveOrderModel.h"
#import "BXGOrderPayBaseModel.h"
#import "BXGOrderPayWechatModel.h"
#import "BXGWechatPayTool.h"

#import "BXGOrderPayResultViewModel.h"
#import "BXGOrderPayResultVC.h"
#import "BXGOrderPayBaseModel.h"
#import "BXGOrderPayFreeModel.h"
#import "BXGOrderPayWechatModel.h"

typedef NS_ENUM(NSUInteger, BXGNoInstallPayAppType) {
    BXGNoInstallPayAppType_WeiXin,
};

@implementation BXGPayManager

- (instancetype)init {
    self = [super init];
    if(self) {
        [BXGNotificationTool addObserverForOrderPayFinishSuccessCallback:self];
        [BXGNotificationTool addObserverForOrderPayFinishFailCallback:self];
    }
    return self;
}

- (void)dealloc {
    [BXGNotificationTool removeObserver:self];
}

- (void)catchOrderPayFinishSuceessCallback {
    [self _catchOrderPay];
}

- (void)catchOrderPayFinishFailCallback {
//    [self _catchOrderPay];
//    if(_delegate) {
//        [_delegate.navigationController dismissViewControllerAnimated:YES completion:nil];
//        [_delegate.mainViewController pushToMeOrderVC];
//        _curPayType = nil;
//        _curOrderSeialNo = nil;
//    }
    if(_curOrderSeialNo && _curPayType && _delegate) {
        [_delegate.navigationController dismissViewControllerAnimated:false completion:nil];
        BXGOrderPayResultViewModel *payVM = [[BXGOrderPayResultViewModel alloc] initWithPayFailedMsg:@"支付取消"];
        BXGOrderPayResultVC *vc = [[BXGOrderPayResultVC alloc] initWithViewModel:payVM];
//        [_delegate.navigationController pushViewController:vc animated:NO];
        [_delegate dismissViewControllerAnimated:true completion:nil];
        [_delegate presentViewController:vc animated:true completion:nil];
        _curPayType = nil;
        _curOrderSeialNo = nil;
    }
}

- (void)_catchOrderPay {
    if(_curOrderSeialNo && _curPayType) {
        BXGOrderPayResultViewModel *payVM = [[BXGOrderPayResultViewModel alloc] initWithOrderNo:_curOrderSeialNo andPayType:_curPayType];
        [self orderFinishPayCallbackWithPayVM:payVM];
    }
}

///保存订单 免费
- (void)loadSaveOrderWithFreeCourseId:(NSString *)courseId
                       andFinishBlock:(void (^)(BXGOrderStatusType status, NSString * msg, BXGOrderPayBaseModel* payModel))finishedBlock {
    __weak typeof(self) weakSelf = self;
    BXGOrderSaveOrderModel *model = [[BXGOrderSaveOrderModel alloc] initWithFreeCourseId:courseId];
    [[BXGNetWorkTool sharedTool] requestOrderSaveOrderWithOrderStr:[model yy_modelToJSONString] andFinished:^(id  _Nullable responseObject) {
        [weakSelf _parsePayAndBInstantPay:NO andResponseObject:responseObject andPayType:model.payType andFinished:^(BXGOrderStatusType status, NSString * _Nullable msg , BXGOrderPayBaseModel* payModel) {
            [weakSelf translatePayUIWithOrderStatusType:status
                                             andMessage:msg
                                            andPayModel:payModel
                                             andPayType:@"0"];
            finishedBlock(status, msg, payModel);
        }];
    } andFailed:^(NSError * _Nonnull error) {
        [weakSelf translatePayUIWithOrderStatusType:BXGSaveOrderStatusTypeNetworkError
                                         andMessage:kBXGToastNoNetworkError
                                        andPayModel:nil
                                         andPayType:nil];
        finishedBlock(BXGSaveOrderStatusTypeNetworkError,kBXGToastNoNetworkError, nil);
    }];
}
/**
 保存订单 需支付
 
 @param dictCourseCoupon  # 课程id-优惠券id映射 例如:{"384":0,"443":0,"536":0},
 @param strTotalAmount # 订单计算优惠后总价（实际应支付价格）
 @param orderFrom  # 订单来源，0直销（本系统），1分销系统，2线下（刷数据），3微信分销，4App，5移动web
 @param payType # 支付类型 0:微信 1:支付宝 2:网银
 @param finishedBlock 回调
 */
- (void)loadSaveOrderCourseCouponDict:(NSDictionary*)dictCourseCoupon
                       andTotalAmount:(NSString*)strTotalAmount
                         andOrderFrom:(NSString*)orderFrom
                           andPayType:(NSString*)payType
                       andFinishBlock:(void (^)(BXGOrderStatusType status, NSString * msg, BXGOrderPayBaseModel* payModel))finishedBlock {
    __weak typeof(self) weakSelf = self;
    BXGOrderSaveOrderModel *model = [[BXGOrderSaveOrderModel alloc] initCourseCouponDict:dictCourseCoupon
                                                                          andTotalAmount:strTotalAmount
                                                                            andOrderFrom:orderFrom
                                                                              andPayType:payType];
    [[BXGNetWorkTool sharedTool] requestOrderSaveOrderWithOrderStr:[model yy_modelToJSONString] andFinished:^(id  _Nullable responseObject) {
        [weakSelf _parsePayAndBInstantPay:NO andResponseObject:responseObject andPayType:payType andFinished:^(BXGOrderStatusType status, NSString * _Nullable msg, BXGOrderPayBaseModel* payModel) {
            [weakSelf translatePayUIWithOrderStatusType:status
                                             andMessage:msg
                                            andPayModel:payModel
                                             andPayType:payType];
            finishedBlock(status, msg, payModel);
        }];
    } andFailed:^(NSError * _Nonnull error) {
        [weakSelf translatePayUIWithOrderStatusType:BXGSaveOrderStatusTypeNetworkError
                                         andMessage:kBXGToastNoNetworkError
                                        andPayModel:nil
                                         andPayType:payType];
        finishedBlock(BXGSaveOrderStatusTypeNetworkError,kBXGToastNoNetworkError, nil);
    }];
}

///立即支付
- (void)loadOrderToPayWithOrderId:(NSString * _Nullable)orderId
andOrderNo:(NSString * _Nullable)orderNo
andType:(NSString * _Nullable)type
andFinished:(void (^_Nullable)(BXGOrderStatusType status, NSString * _Nullable msg, BXGOrderPayBaseModel* payModel))finishedBlock {
    __weak typeof(self) weakSelf = self;
    [[BXGNetWorkTool sharedTool] requestOrderToPayWithOrderId:orderId andOrderNo:orderNo andType:type andFinished:^(id  _Nullable responseObject) {
        [weakSelf _parsePayAndBInstantPay:YES andResponseObject:responseObject andPayType:type andFinished:^(BXGOrderStatusType status, NSString * _Nullable msg, BXGOrderPayBaseModel* payModel) {
            [weakSelf translatePayUIWithOrderStatusType:status
                                             andMessage:msg
                                            andPayModel:payModel
                                             andPayType:type];
            finishedBlock(status, msg, payModel);
        }];
    } andFailed:^(NSError * _Nonnull error) {
        [weakSelf translatePayUIWithOrderStatusType:BXGSaveOrderStatusTypeNetworkError
                                         andMessage:kBXGToastNoNetworkError
                                        andPayModel:nil
                                         andPayType:type];
        finishedBlock(BXGSaveOrderStatusTypeNetworkError,kBXGToastNoNetworkError, nil);
    }];
}

-(BOOL)callWechatPayReq:(PayReq*)payReq {
    BOOL bRet = NO;
    if(payReq){
//        [BXGWechatPayTool callWeixin:payReq];
        if([WXApi isWXAppInstalled]) {
//        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] ||
//           [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
            [WXApi sendReq:payReq];
            bRet = YES;
        } else {
            [self noInstallPayAppType:BXGNoInstallPayAppType_WeiXin];
            bRet = NO;
        }
    }
    return bRet;
}

-(void)noInstallPayAppType:(BXGNoInstallPayAppType)noPayAppInstallType {
    if(noPayAppInstallType == BXGNoInstallPayAppType_WeiXin) {
        [[BXGHUDTool share] showHUDWithString:@"未安装微信,不能完成支付,请安装后再试!"];
    }
}

-(void)orderFinishPayCallbackWithPayVM:(BXGOrderPayResultViewModel*)payVM {
    if(_delegate) {
        [_delegate.navigationController dismissViewControllerAnimated:YES completion:nil];
        BXGOrderPayResultVC *resultVC = [[BXGOrderPayResultVC alloc] initWithViewModel:payVM];
//        [_delegate.navigationController pushViewController:resultVC animated:NO];
        _curPayType = nil;
        _curOrderSeialNo = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate dismissViewControllerAnimated:true completion:nil];
            [_delegate presentViewController:resultVC animated:true completion:nil];
        });
        
    }
}

#pragma mark BXGPay
- (void)translatePayUIWithOrderStatusType:(BXGOrderStatusType)status
                               andMessage:(NSString *)msg
                              andPayModel:(BXGOrderPayBaseModel*)payModel
                               andPayType:(NSString*)payType {
    
    __weak typeof(self) weakSelf = self;
    switch (status) {
        case BXGSaveOrderStatusTypeNetworkError:
        case BXGSaveOrderStatusTypeOperationError:
        case BXGSaveOrderStatusTypeServerError:
        {
            [[BXGHUDTool share] showHUDWithString:msg];
        }
            break;
        case BXGSaveOrderStatusTypeFreeCourse:
        {
            //外部处理
            [[BXGHUDTool share] showHUDWithString:@"报名成功"];
            BXGOrderPayResultViewModel *payVM  = [[BXGOrderPayResultViewModel alloc] initWithOrderNo:payModel.orderSerialNo andPayType:payType];
            BXGOrderPayResultVC *resultVC = [[BXGOrderPayResultVC alloc] initWithViewModel:payVM];
//            [_delegate.navigationController pushViewController:resultVC animated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate dismissViewControllerAnimated:true completion:nil];
                [_delegate presentViewController:resultVC animated:true completion:nil];
            });
        }
            break;
        case BXGSaveOrderStatusTypePayCourse: {
            _curOrderSeialNo = payModel.orderSerialNo;
            _curPayType = payType;

            BXGOrderPayResultViewModel *payVM  = [[BXGOrderPayResultViewModel alloc] initWithOrderNo:payModel.orderSerialNo andPayType:payType];
            NSAssert([payModel isKindOfClass:[BXGOrderPayWechatModel class]], @"payModel is not wechatpay type");
            
            if([weakSelf callWechatPayReq:[((BXGOrderPayWechatModel*)payModel) generateWeChatPayReq]]) {
                BXGAlertController *alertVC = [BXGAlertController confirmWithTitle:nil message:kBXGToastOrderPayDeadline andConfirmTitle:@"支付成功" andCancelTitle:@"支付遇到问题" confirmHandler:^{
                    
                    [[BXGBaiduStatistic share] statisticEventString:kBXGStatOrderToastEventTypePaySucceedBtn andLabel:nil];
                    [weakSelf orderFinishPayCallbackWithPayVM:payVM];
                    
                } cancleHandler:^{
                    
                    [[BXGBaiduStatistic share] statisticEventString:kBXGStatOrderToastEventTypePayFailedBtn andLabel:nil];
                    [weakSelf orderFinishPayCallbackWithPayVM:payVM];
                    
                }];
                [_delegate presentViewController:alertVC animated:true completion:nil];
            }
        }
            break;
        default:
            break;
    }
}

-(void)_parsePayAndBInstantPay:(BOOL)bInstantPay
             andResponseObject:(id)responseObject
                    andPayType:(NSString*)payType
                   andFinished:(void (^_Nullable)(BXGOrderStatusType status, NSString * _Nullable msg, BXGOrderPayBaseModel* payModel))finishedBlock {
    switch (payType.integerValue) {
        case 0: {
            [self _parseWeixinPayAndBInstantPay:bInstantPay andResponseObject:responseObject andFinished:^(BXGOrderStatusType status, NSString * _Nullable msg, BXGOrderPayBaseModel* payModel) {
                finishedBlock(status, msg, payModel);
            }];
        } break;
        default:
            NSAssert(YES, @"the type is not allowed");
            break;
    }
}

-(void)_parseWeixinPayAndBInstantPay:(BOOL)bInstantPay
                   andResponseObject:(id)responseObject
                         andFinished:(void (^_Nullable)(BXGOrderStatusType status, NSString * _Nullable msg, BXGOrderPayBaseModel* payModel))finishedBlock {
    __weak typeof(self) weakSelf = self;
    [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
        switch (status) {
            case BXGNetworkResultStatusSucceed: {
                if(!bInstantPay)
                {
                    if([result isKindOfClass:[NSDictionary class]] && result[@"totalAmount"] != nil /*[NSNull null]*/) {//todo#
                        return [weakSelf _praseTotalAmountWithResult:result andMessage:message andFinished:finishedBlock];
                    }
                }
                
                BXGOrderPayWechatModel *req = [BXGOrderPayWechatModel yy_modelWithDictionary:result];
                if(req && req.partnerid
                   && req.prepayid
                   && req.noncestr
                   && req.timestamp
                   && req.package
                   && req.sign) {
                    // BXGSaveOrderStatusTypePayCourse
                    finishedBlock(BXGSaveOrderStatusTypePayCourse,message, req);
                } else {
                    // BXGSaveOrderStatusTypeServerError
                    finishedBlock(BXGSaveOrderStatusTypeServerError,message, nil);
                }
            }
                break;
            case BXGNetworkResultStatusFailed:{
                // operation error
                finishedBlock(BXGSaveOrderStatusTypeOperationError,message, nil);
            }break;
            case BXGNetworkResultStatusExpired:{
                // network error
                finishedBlock(BXGSaveOrderStatusTypeOperationError, kBXGToastExpireError, nil);
            }break;
            case BXGNetworkResultStatusParserError: {
                // server error
                finishedBlock(BXGSaveOrderStatusTypeServerError,message, nil);
            }break;
        }
    }];
}

-(void)_praseTotalAmountWithResult:(id)result
                        andMessage:(NSString*)message
                       andFinished:(void (^_Nullable)(BXGOrderStatusType status, NSString * _Nullable msg, BXGOrderPayBaseModel* payModel))finishedBlock {
    if([result isKindOfClass:[NSDictionary class]] && result[@"totalAmount"] != nil /*[NSNull null]*/) {
        
        BXGOrderPayBaseModel *payModel = [BXGOrderPayBaseModel yy_modelWithDictionary:result];
        
        id totalAmount = result[@"totalAmount"];
        if([totalAmount integerValue] <= 0) {
            // BXGSaveOrderStatusTypeFreeCourse
            return finishedBlock(BXGSaveOrderStatusTypeFreeCourse,message, payModel);
        } else {
            // server error
            return finishedBlock(BXGSaveOrderStatusTypeServerError,message, payModel);
        }
    }
}

@end
