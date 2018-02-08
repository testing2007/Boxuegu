//
//  BXGOrderPayItemModel.m
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderPayItemModel.h"
#import "BXGOrderPayItemDetailModel.h"

@implementation BXGOrderPayItemModel

+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"orderDetail" : [BXGOrderPayItemDetailModel class]};
}

@end
