//
//  BXGUserInfoTool.h
//  Boxuegu
//
//  Created by RW on 2017/4/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGUserModel.h"
#import "BXGStudyPayCourseModel.h"
#import "BXGCourseOutlineVideoModel.h"




@interface BXGUserDefaults : NSObject

+(instancetype)share;

/// 是否登录
@property (nonatomic, assign) BOOL isLogin; // 废弃

/// 用户信息模型
@property (nonatomic, strong) BXGUserModel *userModel;

/// 当前选择的课程模型
@property (nonatomic, strong) BXGStudyPayCourseModel *currentPayCourseModel; // 废弃

/// 当前选择的课程Id
@property (nonatomic, strong) NSString *currentPayCourseId; // 废弃

/// 上次获取动态码时间 (未使用)
@property (nonatomic, strong) NSDate *lastGetVCodeDate; // 废弃

// 保存历史搜索记录, 最多十条
@property (nonatomic, strong) NSMutableArray<NSString*> *arrHistorySearchRecord;


#pragma mark - "我的" 设置

/// 允许使用3G/4G网络观看视频
@property (nonatomic, assign) BOOL isAllowCellularWatch;

/// 允许使用3G/4G网络下载视频
@property (nonatomic, assign) BOOL isAllowCellularDownload;

/// 允许推送消息
@property (nonatomic, assign) BOOL isAllowPushNotification;


#pragma mark - "学习圈" 发帖按钮位置
@property (nonatomic, strong) NSValue *communityPostBtnCenterPoint;

#pragma mark - 将要移除或被替换
// 退出登录
- (void)logoutOperation;

@property (nonatomic, strong) NSString *courseName; // 要被NSArray代替

#pragma mark - 需要转移到 Cache
@property (nonatomic, strong) NSString *lastUserID;

- (void)clearLastVideoModel;

// 上次登录社交平台
@property (nonatomic) BXGSocialPlatformType lastLoginSocialPlatform;
@end
