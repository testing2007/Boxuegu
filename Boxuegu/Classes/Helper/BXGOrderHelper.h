//
//  BXGOrderHelper.h
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
#import "BXGOrderOutlineModel.h"
#import "BXGOrderCouponModel.h"
#import "BXGCouponModel.h"
#import "BXGOrderPayListModel.h"
#import "BXGCouponCourseModel.h"
#import "BXGOrderPayResultModel.h"

@interface BXGOrderHelper : BXGBaseViewModel

///提交订单: 订单确认
- (void)loadOrderSubmitOutlineIsInitial:(NSNumber*)isInitial
                      andOrderCourseIds:(NSString*)orderCourseIds
                      andCourseCouponId:(NSString*)courseCouponId
                         andFinishBlock:(void(^)(BOOL bSuccess, NSError *error, BXGOrderOutlineModel *orderOutlineModel))finishedBlock;

///提交订单：课程选择优惠券接口
- (void)loadOrderSubmitCouponWithCourseId:(NSNumber *)courseId
                             andCouponIds:(NSArray<NSString*>*)couponIds
                             andUseStatus:(NSNumber *)useStatus
                           andFinishBlock:(void(^)(BOOL bSuccess, NSError *error, NSArray<BXGOrderCouponModel*>*))finishedBlock;


///我的优惠券列表
- (void)loadMyCouponsWithRefresh:(BOOL)bRefresh
                       andStatus:(NSNumber *)status
                  andFinishBlock:(void(^)(BOOL bSuccess, NSError *error, BXGCouponModel *couponModel))finishedBlock;

///我的订单：根据订单状态获取订单列表
- (void)loadMyOrdersWithRefresh:(BOOL)bRefresh
                 andOrderStatus:(NSNumber *)orderStatus
                 andFinishBlock:(void (^)(BOOL bSuccess, NSError *error, BXGOrderPayListModel *orderPayListModel))finishedBlock;


///我的优惠券：根据优惠券id获取优惠券可优惠课程
- (void)loadCouponCoursesWithRefresh:(BOOL)bRefresh
                         andCouponId:(NSNumber *)couponId
                      andFinishBlock:(void (^)(BOOL bSuccess, NSError *error, BXGCouponCourseModel *couponCourseModel))finishedBlock;

///订单：订单详情
- (void)loadOrderDetailWithOrderId:(NSString *)orderId
                    andFinishBlock:(void (^)(BOOL bSuccess, NSError *error, BXGOrderPayItemModel *orderItemModel))finishedBlock;


/**
 取消订单

 @param orderNo   订单号
 @param NSInteger 0删除订单（暂不支持删除），1取消订单
 */
- (void)loadCancelOrderWithOrderNo:(NSString *)orderNo
                              andType:(NSString *)type
                       andFinishBlock:(void (^)(BOOL bSuccess, NSError *error))finishedBlock;



/**
 查询订单
 
 @param orderId 订单号
 @param type 支付方式：0-微信 1-支付宝 2-网银
 @param finishedBlock 完成回调
 */
+ (void)loadOrderSearchWithOrderNo:(NSString *)orderNo
                           andType:(NSString *)type
                    andFinishBlock:(void (^)(BOOL bSuccess, BXGOrderPayResultModel *resultModel,NSString *msg))finishedBlock;

@property(nonatomic, assign) NSInteger couponListCurrentPage;
@property(nonatomic, assign) BOOL bHaveMoreCouponListData;
@property(nonatomic, strong) NSArray<BXGOrderCouponModel *> *arrCouponListData;

@property(nonatomic, assign) NSInteger orderListCurrentPage;
@property(nonatomic, assign) BOOL bHaveMoreOrderListData;
@property(nonatomic, strong) NSArray<BXGOrderPayItemModel *> *arrOrderListData;

@property(nonatomic, assign) NSInteger couponableCourseListCurrentPage;
@property(nonatomic, assign) BOOL bHaveMoreCouponableCourseListData;
@property(nonatomic, strong) NSArray<BXGHomeCourseModel*> *arrCouponableCourseData;

/**
 订单查询
 
 @param orderId 订单号
 @param type 支付方式：0-微信 1-支付宝 2-网银
 @param finishedBlock 完成回调
 */
+ (void)loadOrderSearchWithOrderId:(NSString *)orderId
                           andType:(NSString *)type
                    andFinishBlock:(void (^)(BOOL bSuccess,  NSString *errorMessage, NSError *error))finishedBlock;

@end
