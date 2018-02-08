//
//  BXGCommunityCommentReplyModel.h
//  Boxuegu
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGCommunityCommentReplyModel : BXGBaseModel

@property(nonatomic, strong) NSNumber *bannedType; //bannedType (integer, optional): 禁言类型 ,
@property(nonatomic, strong) NSNumber *commentId; //commentId (integer, optional): 回复所属评论ID ,
@property(nonatomic, strong) NSString *content; //content (string, optional): 评论内容 ,
@property(nonatomic, strong) NSString *createTime; //createTime (string, optional): 创建时间 ,
@property(nonatomic, strong) NSNumber *idx; //id (integer, optional): 回复ID ,
@property(nonatomic, strong) NSArray<NSString*> *imgPathList; //imgPathList (Array[string], optional): 回复图片链接集合 ,
@property(nonatomic, strong) NSNumber *imgPathSum; //imgPathSum (integer, optional): 回复图片数 ,
@property(nonatomic, assign) BOOL isBanned; //isBanned (integer, optional): 禁言状态 ,
@property(nonatomic, assign) BOOL isBlack; //isBlack (integer, optional): 黑名单状态 ,
@property(nonatomic, strong) NSNumber *postId; //postId (integer, optional): 回复所属帖子ID ,
@property(nonatomic, strong) NSNumber *praiseSum; //praiseSum (integer, optional): 回复点赞数 ,
@property(nonatomic, strong) NSString *replySmallHeadPhoto; //replySmallHeadPhoto (string, optional): 被回复用户头像链接 ,
@property(nonatomic, strong) NSNumber *replySum; //replySum (integer, optional): 评论回复数 ,
@property(nonatomic, strong) NSNumber *replyUserId; //replyUserId (string, optional): 被回复用户ID ,
@property(nonatomic, strong) NSString *replyUsername; //replyUsername (string, optional): 被回复用户昵称 ,
@property(nonatomic, strong) NSString *smallHeadPhoto; //smallHeadPhoto (string, optional): 回复用户头像链接 ,
@property(nonatomic, strong) NSNumber *userId; //userId (string, optional): 回复用户ID ,
@property(nonatomic, strong) NSString *username; //username (string, optional): 回复用户昵称

@end
