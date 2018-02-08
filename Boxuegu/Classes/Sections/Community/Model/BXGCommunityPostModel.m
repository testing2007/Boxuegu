//
//  BXGCommunityPostModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityPostModel.h"
#import "BXGCommunityUserModel.h"

@implementation BXGCommunityPostModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"praisedUserList":[BXGCommunityUserModel class]};
}
@end
