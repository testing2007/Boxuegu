//
//  BXGCouponModel.m
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCouponModel.h"
#import "BXGOrderCouponModel.h"

@implementation BXGCouponModel

+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"items" : [BXGOrderCouponModel class]};
}

@end
