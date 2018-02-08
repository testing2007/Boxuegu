//
//  BXGPraisePersonDetailModel.m
//  Boxuegu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPraisePersonDetailModel.h"
#import "BXGCommunityUserModel.h"

@implementation BXGPraisePersonDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"items" : [BXGCommunityUserModel class]};
}


@end
