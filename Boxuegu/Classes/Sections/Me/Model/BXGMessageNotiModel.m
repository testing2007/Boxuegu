//
//  BXGMessageNotiModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMessageNotiModel.h"
#import "BXGMessageModel.h"

@implementation BXGMessageNotiModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"lastMessage":[BXGMessageModel class]};
}
@end
