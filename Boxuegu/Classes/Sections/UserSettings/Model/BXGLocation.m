//
//  BXGLocation.m
//  Boxuegu
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGLocation.h"

@implementation BXGLocationCity
@end

@implementation BXGLocationProvince

+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"cityList" : [BXGLocationCity class]};
}

@end

@implementation BXGLocation

@end
