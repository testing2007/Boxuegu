//
//  BXGCommunityCommentModel.h
//  Boxuegu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGCommunityCommentModel : BXGBaseModel

@property(nonatomic, strong) NSString *content; //content (string, optional): 评论内容 ,
@property(nonatomic, strong) NSString *createPerson; //createPerson (string, optional): 创建人id ,
@property(nonatomic, strong) NSString *createTime; //createTime (string, optional): 创建时间 ,
@property(nonatomic, strong) NSNumber *idx; //id (integer, optional): 帖子评论ID ,
@property(nonatomic, assign) BOOL isDelete; //isDelete (integer, optional): 逻辑删除:0-未删除，1-已删除 ,
@property(nonatomic, strong) NSNumber *postId; //postId (integer, optional): 评论所属帖子ID ,
@property(nonatomic, strong) NSNumber *replySum;//replySum (integer, optional): 评论回复数 ,
@property(nonatomic, strong) NSNumber *status; //status (integer, optional): 启用1，禁用0 ,
@property(nonatomic, strong) NSString *updatePerson; //updatePerson (string, optional): 更新人id ,
@property(nonatomic, strong) NSString *updateTime;//updateTime (string, optional): 更新时间 ,
@property(nonatomic, strong) NSString *userId;//userId (string, optional): 评论的用户ID

@end
