//
//  BXGCouponCourseModel.m
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCouponCourseModel.h"
#import "BXGHomeCourseModel.h"

@implementation BXGCouponCourseModel

+(NSDictionary*)modelContainerPeropertyGenericClass {
    return @{@"items" : [BXGHomeCourseModel class]};
}

@end
