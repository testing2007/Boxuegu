//
//  BXGOrderOutlineModel.m
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderOutlineModel.h"
#import "BXGOrderDetailModel.h"

@implementation BXGOrderOutlineModel
+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"detail" : [BXGOrderDetailModel class]};
}
@end
