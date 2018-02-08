//
//  BXGUserAccountsModel.m
//  Boxuegu
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGUserAccountsModel.h"

@implementation BXGUserAccountInfoModel
@end

@implementation BXGUserLoginInfoModel
@end

@implementation BXGUserAccountsModel

+(NSDictionary*)modelContainerPropertyGenericClass {
    return @{ @"accounts" : [BXGUserAccountInfoModel class],
              @"usercenter" : [BXGUserLoginInfoModel class] };
}

@end
