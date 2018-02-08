//
//  BXGMicroFilterModel.m
//  Boxuegu
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMicroFilterModel.h"
#import "BXGMicroFilterDirectionModel.h"

@implementation BXGMicroFilterModel

+(NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"direction" : [BXGMicroFilterDirectionModel class]};
}

@end
