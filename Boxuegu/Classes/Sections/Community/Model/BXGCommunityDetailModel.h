//
//  BXGCommunityDetailModel.h
//  Boxuegu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"
#import "BXGCommunityUserModel.h"
#import "BXGCommunityCommentBaseModel.h"

@interface BXGCommunityDetailModel : BXGBaseModel

@property(nonatomic, strong) NSNumber *basicId; //basicId (integer, optional): 帖子所属基础模块ID ,
@property(nonatomic, strong) NSString *basicName;//basicName (string, optional): 帖子所属模块名称 ,
@property(nonatomic, strong) NSNumber *browseSum;//browseSum (integer, optional): 浏览量 ,
@property(nonatomic, strong) NSNumber *collectionSum;//collectionSum (integer, optional): 收藏数 ,
@property(nonatomic, strong) NSNumber *commentSum;//commentSum (integer, optional): 帖子评论数 ,
@property(nonatomic, strong) NSString *content;//content (string, optional): 帖子内容 ,
@property(nonatomic, strong) NSString *coverPath;//coverPath (string, optional): 封面图链接 ,
@property(nonatomic, strong) NSString *createTime;//createTime (string, optional): 创建时间 ,
@property(nonatomic, strong) NSString *highlightTime;//highlightTime (string, optional): 加热门时间，取消热门置为NULL ,
@property(nonatomic, strong) NSNumber *idx;//id (integer, optional): 帖子ID ,
@property(nonatomic, strong) NSArray *imgPathList;//imgPathList (Array[string], optional): 帖子图片链接集合 ,
@property(nonatomic, strong) NSString *imgPathStr;//imgPathStr (string, optional),
@property(nonatomic, strong) NSString *imgPathSum;//imgPathSum (integer, optional): 帖子图片链接数 ,
@property(nonatomic, assign) BOOL isAlltopic;//isAlltopic (integer, optional): 该帖子是否关联全部话题：0-否，1-是 ,
@property(nonatomic, assign) BOOL isBanned;//isBanned (integer, optional): 是否被禁言：0-否，1-是 ,
@property(nonatomic, assign) BOOL isBlack;//isBlack (integer, optional): 是否被加入黑名单：0-否，1-是 ,
@property(nonatomic, assign) BOOL isHighlight;//isHighlight (integer, optional): 是否热门：0-否，1-是 ,
@property(nonatomic, assign) BOOL isStick;//isStick (integer, optional): 是否置顶：0-不是，1-是 ,
@property(nonatomic, strong) NSString *location;//location (string, optional): 发帖位置 ,
@property(nonatomic, strong) NSArray<BXGCommunityCommentBaseModel*> *noticeUserList;//noticeUserList (Array[帖子评论vo], optional): 发帖提醒人集合 ,
@property(nonatomic, strong) NSNumber *noticeUserSum;//noticeUserSum (integer, optional): 发帖提醒人 ,
@property(nonatomic, strong) NSNumber *praiseSum; //praiseSum (integer, optional): 点赞数 ,
@property(nonatomic, strong) NSString *smallHeadPhoto;//smallHeadPhoto (string, optional): 头像 ,
@property(nonatomic, strong) NSNumber *status; //status (integer, optional): 启禁用：0-禁用，1-启用 ,
@property(nonatomic, strong) NSString *stickTime; //stickTime (string, optional): 置顶时间，取消置顶置为NULL ,
@property(nonatomic, strong) NSString *title; //title (string, optional): 帖子标题 ,
@property(nonatomic, strong) NSNumber *topicId;//topicId (integer, optional): 话题ID ,
@property(nonatomic, strong) NSString *topicName;//topicName (string, optional): 帖子所属话题名称 ,
@property(nonatomic, strong) NSNumber *userId; //userId (string, optional): 发帖用户id ,
@property(nonatomic, strong) NSArray<BXGCommunityUserModel*> *userList; //userList (Array[BasicUser], optional): 点赞用户类表 ,
@property(nonatomic, strong) NSString *userName; //userName (string, optional): 用户名
@property(nonatomic, assign) BOOL isPraise;
@property(nonatomic, assign) BOOL isAttention;



@end
