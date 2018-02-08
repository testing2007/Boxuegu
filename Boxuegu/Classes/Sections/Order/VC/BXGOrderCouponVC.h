//
//  BXGOrderCouponVC.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseRootVC.h"

@class BXGOrderCouponModel;
@interface BXGOrderCouponVC : BXGBaseRootVC
- (instancetype)initWithCourseId:(NSString *)courseId andCoupons:(NSArray<BXGOrderCouponModel *> *)coupons andCurrentCouponId:(NSString *)couponId andSelectedCoupon:(void(^)(NSString * couponId))selectedBlock;
@end
