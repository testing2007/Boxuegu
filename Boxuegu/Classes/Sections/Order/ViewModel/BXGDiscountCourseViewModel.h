//
//  BXGDiscountCourseViewModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
@class BXGHomeCourseModel;
@interface BXGDiscountCourseViewModel : BXGBaseViewModel
- (instancetype)initWithCouponId:(NSString *)couponId;
- (void)loadWithIsRefresh:(BOOL)isRefresh andFinished:(void(^)(NSArray<BXGHomeCourseModel *> *models))finished;
@end
