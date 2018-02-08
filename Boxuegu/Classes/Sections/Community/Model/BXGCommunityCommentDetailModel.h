//
//  BXGCommunityCommentDetailModel.h
//  Boxuegu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@class BXGCommunityCommentModel;
@class BXGCommunityCommentReplyModel;

@interface BXGCommunityCommentDetailModel : BXGBaseModel //page

@property(nonatomic, strong) NSNumber* bannedType; //bannedType (integer, optional): 禁言类型 ,
@property(nonatomic, strong) NSString* content; //content (string, optional): 评论内容 ,
@property(nonatomic, strong) NSString* createTime; //createTime (string, optional): 评论时间 ,
@property(nonatomic, strong) NSNumber* idx; //id (integer, optional): 评论ID ,
@property(nonatomic, strong) NSArray<NSString*>* imgPathList; //imgPathList (Array[string], optional): 评论图片链接集合 ,
@property(nonatomic, strong) NSNumber* imgPathSum; //imgPathSum (integer, optional): 评论图片数 ,
@property(nonatomic, assign) BOOL  isBanned; //isBanned (integer, optional): 禁言状态 ,
@property(nonatomic, assign) BOOL  isBlack; //isBlack (integer, optional): 黑名单状态 ,
@property(nonatomic, assign) BOOL isPraise; //isPraise (integer, optional): 当前用户是否已经点赞：0-否，1-是 ,
@property(nonatomic, strong) NSNumber* postId; //postId (integer, optional): 评论帖子ID ,
@property(nonatomic, strong) NSNumber* praiseSum; //praiseSum (integer, optional): 评论点赞数 ,
@property(nonatomic, strong) NSArray<BXGCommunityCommentReplyModel*>* replyList; //replyList (Array[ReplyVo], optional): 评论回复list ,
@property(nonatomic, strong) NSNumber* replySum; //replySum (integer, optional): 评论回复数 ,
@property(nonatomic, strong) NSString* smallHeadPhoto; //smallHeadPhoto (string, optional): 评论用户头像链接 ,
@property(nonatomic, strong) NSNumber* userId; //userId (string, optional): 评论的用户ID ,
@property(nonatomic, strong) NSString* username; //username (string, optional): 评论用户昵称

@end
