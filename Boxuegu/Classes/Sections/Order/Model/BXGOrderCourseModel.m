//
//  BXGOrderCourseModel.m
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderCourseModel.h"
#import "BXGOrderCouponModel.h"

@implementation BXGOrderCourseModel

+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"coupons" : [BXGOrderCouponModel class]};
}

@end
