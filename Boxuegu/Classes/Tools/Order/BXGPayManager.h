//
//  BXGPayManager.h
//  Boxuegu
//
//  Created by apple on 2017/11/11.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGPay.h"

@class BXGOrderPayBaseModel;
@class BXGOrderPayWechatModel;

@interface BXGPayManager : NSObject<BXGNotificationDelegate>

@property (nonatomic, weak) BXGBaseViewController *delegate;
@property (nonatomic, strong) NSString* curOrderSeialNo;
@property (nonatomic, strong) NSString* curPayType;

//+(instancetype)shareInstance;


///保存订单 免费
- (void)loadSaveOrderWithFreeCourseId:(NSString *)courseId
                       andFinishBlock:(void (^)(BXGOrderStatusType status, NSString * msg, BXGOrderPayBaseModel* payModel))finishedBlock;
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
                       andFinishBlock:(void (^)(BXGOrderStatusType status, NSString * msg, BXGOrderPayBaseModel* payModel))finishedBlock;

///立即支付
- (void)loadOrderToPayWithOrderId:(NSString * _Nullable)orderId
                       andOrderNo:(NSString * _Nullable)orderNo
                          andType:(NSString * _Nullable)type
                      andFinished:(void (^_Nullable)(BXGOrderStatusType status, NSString * _Nullable msg, BXGOrderPayBaseModel* payModel))finishedBlock;

-(BOOL)callWechatPayReq:(PayReq*)payReq;

@end
