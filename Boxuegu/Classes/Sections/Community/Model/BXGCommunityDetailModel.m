//
//  BXGCommunityDetailModel.m
//  Boxuegu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityDetailModel.h"

@implementation BXGCommunityDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"noticeUserList":[BXGCommunityCommentBaseModel class],
             @"userList":[BXGCommunityUserModel class]};
}



@end
