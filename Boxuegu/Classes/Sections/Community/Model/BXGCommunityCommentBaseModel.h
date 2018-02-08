//
//  BXGCommunityCommentModel.h
//  Boxuegu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGCommunityCommentBaseModel : BXGBaseModel //vo

@property(nonatomic, strong) NSString *createTime; //createTime (string, optional): 创建时间 ,
@property(nonatomic, strong) NSNumber *idx; //id (integer, optional): 评论ID ,
@property(nonatomic, strong) NSString *nickname; //nickname (string, optional): 评论用户昵称 ,
@property(nonatomic, strong) NSNumber *postId; //postId (integer, optional): 评论帖子ID ,
@property(nonatomic, strong) NSString *smallHeadPhoto; //smallHeadPhoto (string, optional): 评论用户头像链接 ,
@property(nonatomic, strong) NSString *userId;//userId (string, optional): 评论的用户ID

@end
