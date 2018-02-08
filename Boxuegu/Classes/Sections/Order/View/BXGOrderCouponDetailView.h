//
//  BXGOrderCouponListView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BXGOrderCouponModel;
@class BXGOrderCouponDetailViewModel;
@interface BXGOrderCouponDetailView : UIView
//- (instancetype)initWithCourseId:(NSString *)courseId andCoupons:(NSArray<BXGOrderCouponModel *> *)coupons andCurrentCouponId:(NSString *)couponId andSelectedCoupon:(void(^)(NSString * couponId))selectedBlock;
- (instancetype)initWithViewModel:(BXGOrderCouponDetailViewModel *)viewModel;
@property (nonatomic, copy) void(^didSelectedCoupon)(BXGOrderCouponModel *model);
@property (nonatomic, copy) void(^didSelectedCouponWithSelectedId)(BXGOrderCouponDetailView *coupondView, BXGOrderCouponModel *model, NSString *selectedCouponId);
@property (nonatomic, strong) BXGOrderCouponDetailViewModel *viewModel;
@property (nonatomic, copy) void(^loadfailed)();
@property (nonatomic, assign) BOOL topRefresh;
@property (nonatomic, assign) BOOL bottomAddMore;
- (void)reloadData;
@property (nonatomic, copy) void(^bindSerialNoBlock)(bool success, NSString *msg,NSString *couponId);

@property (nonatomic, copy) NSString *selectedCouponId;
@end
