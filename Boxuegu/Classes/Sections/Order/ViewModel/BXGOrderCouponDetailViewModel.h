//
//  BXGOrderCouponDetailViewModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"

typedef NS_ENUM(NSUInteger, BXGOrderCouponDetailMyCouponType) {

    BXGOrderCouponDetailMyCouponTypeEnable = 0,
    BXGOrderCouponDetailMyCouponTypeCouponUsed = 1,
    BXGOrderCouponDetailMyCouponTypeExpired = 2,
};
typedef NS_ENUM(NSUInteger, BXGOrderCouponDetailCourseCouponType) {
    BXGOrderCouponDetailCourseCouponTypeDisable = 0,
    BXGOrderCouponDetailCourseCouponTypeEnable = 1,
};

typedef NS_ENUM(NSUInteger, BXGOrderCouponDetailType) {
    BXGOrderCouponDetailTypeMyCouponType,
    BXGOrderCouponDetailTypeCourseType,
};
@class BXGOrderCouponModel;
@interface BXGOrderCouponDetailViewModel : BXGBaseViewModel
- (instancetype)initWithType:(BXGOrderCouponDetailCourseCouponType) type andCourseId:(NSString *)courseId andCoupons:(NSString *)couponsId andCurrentCouponId:(NSString *)couponId;
- (void)addCouponId:(NSString *)couponId;
- (instancetype)initWithType:(BXGOrderCouponDetailMyCouponType)type;
@property (nonatomic, strong) NSString *selectedCouponId;
- (void)loadCouponModelsWithRefresh:(BOOL)isRefresh andFinished:(void(^)(NSArray<BXGOrderCouponModel *> *models))finished;
@property (nonatomic, assign) BOOL isNoMoreData;
@property (nonatomic, strong) NSString *courseId;
@end
