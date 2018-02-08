//
//  BXGOrderDetailModel.m
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderDetailModel.h"
#import "BXGOrderCourseModel.h"

@implementation BXGOrderDetailModel

+(NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"courses" : [BXGOrderCourseModel class]};
}

@end
