//
//  BXGCouponCourseModel.h
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

//我的优惠券：根据优惠券id获取优惠券可优惠课程
@class BXGHomeCourseModel;
@interface BXGCouponCourseModel : BXGBaseModel

@property(nonatomic, strong) NSArray<BXGHomeCourseModel*> *items;

@end
