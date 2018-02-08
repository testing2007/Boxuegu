//
//  BXGOrderPayListModel.m
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderPayListModel.h"
#import "BXGOrderPayItemModel.h"

@implementation BXGOrderPayListModel

+ (NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"items" : [BXGOrderPayItemModel class]};
}

@end
