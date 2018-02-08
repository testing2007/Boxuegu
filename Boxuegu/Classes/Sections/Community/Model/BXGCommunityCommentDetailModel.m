//
//  BXGCommunityCommentDetailModel.m
//  Boxuegu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityCommentDetailModel.h"
#import "BXGCommunityCommentReplyModel.h"

@implementation BXGCommunityCommentDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"replyList" : [BXGCommunityCommentReplyModel class]};
}

@end
