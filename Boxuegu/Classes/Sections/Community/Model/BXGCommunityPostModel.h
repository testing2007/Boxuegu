//
//  BXGCommunityPostModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGCommunityPostModel : BXGBaseModel

@property (nonatomic, strong) NSArray *commentList;
@property (nonatomic, strong) NSNumber *idx;
@property (nonatomic, strong) NSNumber *level;
@property (nonatomic, assign) BOOL isHighlight;
@property (nonatomic, assign) BOOL isStick;
@property (nonatomic, strong) NSArray *imgPathList; // 图片URL数组
@property (nonatomic, strong) NSString *basicName;
@property (nonatomic, strong) NSNumber *praiseSum;
@property (nonatomic, strong) NSNumber *imgPathSum;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSNumber *noticeUserSum;
@property (nonatomic, assign) BOOL isBlack;
@property (nonatomic, strong) NSString *topicName;
@property (nonatomic, strong) NSString *stickTime;
@property (nonatomic, strong) NSArray *noticeUserList;
@property (nonatomic, strong) NSNumber *topicId;
@property (nonatomic, strong) NSString *highlightTime;
@property (nonatomic, strong) NSNumber *basicId;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, assign) BOOL isBanned;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *browseSum;
@property (nonatomic, strong) NSArray *NSArray;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSNumber *collectionSum;

@property (nonatomic, strong) NSNumber *commentSum;
@property (nonatomic, strong) NSString *coverPath;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *smallHeadPhoto;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, assign) BOOL isAlltopic;
@property (nonatomic, assign) BOOL isPraise;

@property (nonatomic, strong) NSArray *userList;
@property (nonatomic, strong) NSArray *praisedUserList; // Null
//praisedUserList = [
//{
//    id = 42560,
//    smallHeadPhoto = https://attachment-center.boxuegu.com/data/attachment/online/2017/04/19/17/e741f806e6af4e78bdcf200016d29537.JPG,
//    userName = bxg_42560400
//}
//                   ],


@end
