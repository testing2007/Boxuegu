//
//  BXGOrderHelper.m
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderHelper.h"
#import "BXGNetworkParser.h"
#import "BXGHomeCourseModel.h"
#import "BXGOrderPayItemModel.h"
#import "BXGOrderCouponModel.h"
#import "BXGOrderSaveOrderModel.h"
#import "BXGOrderPayResultModel.h"

#define kPageSize 20



@implementation BXGOrderHelper

- (instancetype)init {
    self = [super init];
    if(self){
        _couponListCurrentPage = 0;
        _bHaveMoreCouponListData = YES;
        
        _orderListCurrentPage = 0;
        _bHaveMoreOrderListData = YES;
        
        _couponableCourseListCurrentPage = 0;
        _bHaveMoreCouponableCourseListData = YES;
    }
    return self;
}

- (void)loadOrderSubmitOutlineIsInitial:(NSNumber*)isInitial
                      andOrderCourseIds:(NSString*)orderCourseIds
                      andCourseCouponId:(NSString*)courseCouponId
                         andFinishBlock:(void(^)(BOOL bSuccess, NSError *error, BXGOrderOutlineModel *orderOutlineModel))finishedBlock {
    NSString *userId = self.userModel.user_id;
    NSString *sign = self.userModel.sign;
    [self.networkTool requestOrderSubmitOutlineWithUserId:userId
                                             andIsInitial:isInitial
                                                  andSign:sign
                                        andOrderCourseIds:orderCourseIds
                                        andCourseCouponId:courseCouponId
                                              andFinished:^(id  _Nullable responseObject) {
       [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
            switch (status) {
                case BXGNetworkResultStatusSucceed:{
                    BXGOrderOutlineModel *model = [BXGOrderOutlineModel yy_modelWithDictionary:result];
                    return finishedBlock(YES, nil, model);
                }
                    break;
                case BXGNetworkResultStatusFailed:
                    
                    break;
                case BXGNetworkResultStatusExpired:
                    
                    break;
                case BXGNetworkResultStatusParserError:
                    break;
            }
            return finishedBlock(NO, nil, nil);
        }];
    } andFailed:^(NSError * _Nonnull error) {
        finishedBlock(NO, error, nil);
    }];
}


//typedef NS_ENUM(NSUInteger, BXGOrderStatusType) {
//    BXGSaveOrderStatusTypeNetworkError,
//    BXGSaveOrderStatusTypeOperationError,
//    BXGSaveOrderStatusTypeServerError,
//    BXGSaveOrderStatusTypeFreeCourse,
//    BXGSaveOrderStatusTypePayCourse,
//};


///提交订单：课程选择优惠券接口
- (void)loadOrderSubmitCouponWithCourseId:(NSNumber *)courseId
                             andCouponIds:(NSArray<NSString*>*)couponIds
                             andUseStatus:(NSNumber *)useStatus
                           andFinishBlock:(void(^)(BOOL bSuccess, NSError *error, NSArray<BXGOrderCouponModel*>*))finishedBlock {
//    NSString *userId = self.userModel.user_id;
//    self.networkTool requestOrderSubmitOutlineWithUserId:userId andIsInitial:<#(NSNumber * _Nullable)#> andSign:<#(NSString * _Nullable)#> andOrderCourseIds:<#(NSString * _Nullable)#> andCourseCouponId:<#(NSString * _Nullable)#> andFinished:<#^(id  _Nullable responseObject)finished#> andFailed:<#^(NSError * _Nonnull error)failded#>
//    [self.networkTool requstOrderSubmitCouponWithUserId:userId andCourseId:courseId andCouponIds:couponIds andUseStatus:useStatus andFinished:^(id  _Nullable responseObject) {
//        [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
//            switch (status) {
//                case BXGNetworkResultStatusSucceed:{
//                    if([result isKindOfClass:[NSArray class]]) {
//                        NSMutableArray *arrResult = [NSMutableArray new];
//                        for (NSDictionary *dictItem in result) {
//                            BXGOrderCouponModel *modelItem = [BXGOrderCouponModel yy_modelWithDictionary:dictItem];
//                            [arrResult addObject:modelItem];
//                        }
//                        return finishedBlock(YES, nil, arrResult);
//                    }
//                }
//                    break;
//                case BXGNetworkResultStatusFailed:
//
//                    break;
//                case BXGNetworkResultStatusExpired:
//
//                    break;
//                case BXGNetworkResultStatusParserError:
//                    break;
//            }
//            return finishedBlock(NO, nil, nil);
//        }];
//    } andFailed:^(NSError * _Nonnull error) {
//        finishedBlock(NO, error, nil);
//    }];
}


///我的优惠券列表
- (void)loadMyCouponsWithRefresh:(BOOL)bRefresh
                       andStatus:(NSNumber *)status
                  andFinishBlock:(void(^)(BOOL bSuccess, NSError *error, BXGCouponModel *couponModel))finishedBlock {
    if(bRefresh)
    {
        _couponListCurrentPage = 0;
        _bHaveMoreCouponListData = YES;
        _arrCouponListData = [NSArray new];
    }
    if(!_bHaveMoreCouponListData)
    {
        return finishedBlock(NO, nil, nil);
    }
    _couponListCurrentPage = self.arrCouponListData!=nil ? (self.arrCouponListData.count/kPageSize)+1 : 1;
    
    __weak typeof (self) weakSelf = self;
    NSString *userId = self.userModel.user_id;
//    [self.networkTool requestMyCouponsWithUserId:userId
//                                       andStatus:status
//                                   andPageNumber:[NSNumber numberWithInteger:_couponListCurrentPage]
//                                     andPageSize:[NSNumber numberWithInteger:kPageSize]
//                                     andFinished:^(id  _Nullable responseObject) {
//        [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
//            switch (status) {
//                case BXGNetworkResultStatusSucceed:{
//                    BXGCouponModel *couponModel = [BXGCouponModel yy_modelWithDictionary:result];
//                    if(couponModel && couponModel.items) {
//                        if(couponModel.items.count<kPageSize)
//                        {
//                            _bHaveMoreCouponListData = NO;
//                        }
//                        
//                        NSMutableArray *arrResult = [[NSMutableArray alloc] initWithArray:weakSelf.arrCouponListData];
//                        for(NSDictionary *dictItem in couponModel.items) {
//                            BXGOrderCouponModel *model = [BXGOrderCouponModel yy_modelWithDictionary:dictItem];
//                            [arrResult addObject:model];
//                        }
//                        
//                        weakSelf.arrOrderListData = arrResult;
//                        couponModel.items = [NSArray arrayWithArray:arrResult];
//                        
//                        return finishedBlock(YES, nil, couponModel);
//                    }
//                }
//                    break;
//                case BXGNetworkResultStatusFailed:
//                    break;
//                case BXGNetworkResultStatusExpired:
//                    break;
//                case BXGNetworkResultStatusParserError:
//                    break;
//            }
//            return finishedBlock(NO, nil, nil);
//        }];
//    } andFailed:^(NSError * _Nonnull error) {
//        finishedBlock(NO, error, nil);
//    }];
}

///我的订单：根据订单状态获取订单列表
- (void)loadMyOrdersWithRefresh:(BOOL)bRefresh
                 andOrderStatus:(NSNumber *)orderStatus
                 andFinishBlock:(void (^)(BOOL bSuccess, NSError *error, BXGOrderPayListModel *orderPayListModel))finishedBlock {
    if(bRefresh)
    {
        _orderListCurrentPage = 0;
        _bHaveMoreOrderListData = YES;
        _arrOrderListData = [NSArray new];
    }
    if(!_bHaveMoreOrderListData)
    {
        return finishedBlock(NO, nil, nil);
    }
    _orderListCurrentPage = self.arrOrderListData!=nil ? (self.arrCouponListData.count/kPageSize)+1 : 1;
    
    __weak typeof (self) weakSelf = self;
    NSString *userId = self.userModel.user_id;
    [self.networkTool requestMyOrdersWithUserId:userId
                                 andOrderStatus:orderStatus
                                  andPageNumber:[NSNumber numberWithInteger:_orderListCurrentPage]
                                    andPageSize:[NSNumber numberWithInteger:kPageSize]
                                    andFinished:^(id  _Nullable responseObject) {
                                         [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
                                             switch (status) {
                                                 case BXGNetworkResultStatusSucceed:{
                                                     BXGOrderPayListModel *orderPayListModel = [BXGOrderPayListModel yy_modelWithDictionary:result];
                                                     if(orderPayListModel && orderPayListModel.items) {
                                                         if(orderPayListModel.items.count<kPageSize)
                                                         {
                                                             _bHaveMoreOrderListData = NO;
                                                         }
                                                         
                                                         NSMutableArray *arrResult = [[NSMutableArray alloc] initWithArray:weakSelf.arrOrderListData];
                                                         for(BXGOrderPayItemModel *item in orderPayListModel.items) {
                                                             [arrResult addObject:item];
                                                         }
                                                         
                                                         weakSelf.arrOrderListData = arrResult;
                                                         orderPayListModel.items = [NSArray arrayWithArray:arrResult];
                                                         
                                                         return finishedBlock(YES, nil, orderPayListModel);
                                                     }
                                                 }
                                                     break;
                                                 case BXGNetworkResultStatusFailed:
                                                     break;
                                                 case BXGNetworkResultStatusExpired:
                                                     break;
                                                 case BXGNetworkResultStatusParserError:
                                                     break;
                                             }
                                             return finishedBlock(NO, nil, nil);
                                         }];
                                     } andFailed:^(NSError * _Nonnull error) {
                                         finishedBlock(NO, error, nil);
                                     }];
}


///我的优惠券：根据优惠券id获取优惠券可优惠课程
- (void)loadCouponCoursesWithRefresh:(BOOL)bRefresh
                         andCouponId:(NSNumber *)couponId
                      andFinishBlock:(void (^)(BOOL bSuccess, NSError *error, BXGCouponCourseModel *couponCourseModel))finishedBlock {
    if(bRefresh)
    {
        _couponableCourseListCurrentPage = 0;
        _bHaveMoreCouponableCourseListData = YES;
        _arrCouponableCourseData = [NSArray new];
    }
    if(!_bHaveMoreCouponableCourseListData)
    {
        return finishedBlock(NO, nil, nil);
    }
    _couponableCourseListCurrentPage = self.arrCouponableCourseData!=nil ? (self.arrCouponableCourseData.count/kPageSize)+1 : 1;
    
    __weak typeof (self) weakSelf = self;
    [self.networkTool requestCouponCoursesWithCouponId:couponId
                                         andPageNumber:[NSNumber numberWithInteger:_couponableCourseListCurrentPage]
                                           andPageSize:[NSNumber numberWithInteger:kPageSize]
                                           andFinished:^(id  _Nullable responseObject) {
                                               [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
                                                   switch (status) {
                                                       case BXGNetworkResultStatusSucceed:{
                                                           BXGCouponCourseModel *couponableCourseListModel = [BXGCouponCourseModel yy_modelWithDictionary:result];
                                                           if(couponableCourseListModel && couponableCourseListModel.items) {
                                                               if(couponableCourseListModel.items.count<kPageSize)
                                                               {
                                                                   _bHaveMoreCouponableCourseListData = NO;
                                                               }
                                                               
                                                               NSMutableArray *arrResult = [[NSMutableArray alloc] initWithArray:weakSelf.arrCouponableCourseData];
                                                               for(BXGHomeCourseModel *item in couponableCourseListModel.items) {
                                                                   [arrResult addObject:item];
                                                               }
                                                               
                                                               weakSelf.arrCouponableCourseData = arrResult;
                                                               couponableCourseListModel.items = [NSArray arrayWithArray:arrResult];
                                                               
                                                               return finishedBlock(YES, nil, couponableCourseListModel);
                                                           }
                                                       }
                                                           break;
                                                       case BXGNetworkResultStatusFailed:
                                                           break;
                                                       case BXGNetworkResultStatusExpired:
                                                           break;
                                                       case BXGNetworkResultStatusParserError:
                                                           break;
                                                   }
                                                   return finishedBlock(NO, nil, nil);
                                               }];
                                           } andFailed:^(NSError * _Nonnull error) {
                                               finishedBlock(NO, error, nil);
                                           }];
}

- (void)loadOrderDetailWithOrderId:(NSString *)orderId
                    andFinishBlock:(void (^)(BOOL bSuccess, NSError *error, BXGOrderPayItemModel *orderItemModel))finishedBlock {
    [self.networkTool requestOrderDetailWithOrderId:orderId
                                        andFinished:^(id  _Nullable responseObject) {
                                            [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
                                                switch (status) {
                                                    case BXGNetworkResultStatusSucceed:{
                                                        if([result isKindOfClass:[NSDictionary class]]) {
                                                            BXGOrderPayItemModel *model = [BXGOrderPayItemModel yy_modelWithDictionary:result];
                                                            return finishedBlock(YES, nil, model);
                                                        }
                                                    }
                                                        break;
                                                    case BXGNetworkResultStatusFailed:
                                                        
                                                        break;
                                                    case BXGNetworkResultStatusExpired:
                                                        
                                                        break;
                                                    case BXGNetworkResultStatusParserError:
                                                        break;
                                                }
                                                return finishedBlock(NO, nil, nil);
                                            }];
                                        } andFailed:^(NSError * _Nonnull error) {
                                            finishedBlock(NO, error, nil);
                                        }];
}

- (void)loadCancelOrderWithOrderNo:(NSString *)orderNo
                              andType:(NSString *)type
                       andFinishBlock:(void (^)(BOOL bSuccess, NSError *error))finishedBlock {
    
    [self.networkTool requestCancelOrderWithOrderNo:orderNo
                                            andType:type
                                        andFinished:^(id  _Nullable responseObject) {
                                         [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
                                             switch (status) {
                                                 case BXGNetworkResultStatusSucceed:{
                                                     return finishedBlock(YES, nil);
                                                 }
                                                     break;
                                                 case BXGNetworkResultStatusFailed:
                                                     
                                                     break;
                                                 case BXGNetworkResultStatusExpired:
                                                     
                                                     break;
                                                 case BXGNetworkResultStatusParserError:
                                                     break;
                                             }
                                             return finishedBlock(NO, nil);
                                         }];
                                     } andFailed:^(NSError * _Nonnull error) {
                                         finishedBlock(NO, error);
                                     }];
}

+ (void)loadOrderSearchWithOrderNo:(NSString *)orderNo
                           andType:(NSString *)type
                    andFinishBlock:(void (^)(BOOL bSuccess, BXGOrderPayResultModel *resultModel,NSString *msg))finishedBlock {
    
    [[BXGNetWorkTool sharedTool] requestOrderSearchWithOrderNo:orderNo
                                                       andType:type
                                                   andFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser mainNetworkParser:responseObject andFinished:^(BXGNetworkResultStatus status, NSString *message, id result) {
            switch (status) {
                case BXGNetworkResultStatusSucceed: {
                    if([result isKindOfClass:[NSDictionary class]]) {
                        BXGOrderPayResultModel *model = [BXGOrderPayResultModel yy_modelWithDictionary:result];
                        if(model) {
                         
                            finishedBlock(true, model, message);
                            return;
                        }
                    }
                }
                    break;
                case BXGNetworkResultStatusFailed:
                    
                    break;
                case BXGNetworkResultStatusExpired:
                    
                    break;
                case BXGNetworkResultStatusParserError:
                    
                    break;
            }
            finishedBlock(false, nil, message);
        }];
    } andFailed:^(NSError * _Nonnull error) {
        finishedBlock(false, nil, kBXGToastNoNetworkError);
    }];
}

@end
