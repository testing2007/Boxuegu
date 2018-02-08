//
//  BXGMeViewModel.h
//  Boxuegu
//
//  Created by HM on 2017/4/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGUserModel.h"
#import "BXGBaseViewModel.h"

@interface BXGMeViewModel : BXGBaseViewModel
+ (instancetype)share;
/**
 登出操作
 */
- (void)operationLogout;

/**
 清除缓存操作
 */
- (void)operationClearImageCaches;
- (void)requestFeedBackWithText:(NSString *)text andPhoneNumber:(NSString *)phoneNumber andFinished:(void(^)(id responseObject))completedBlock Failed:(void(^)(NSError* error))failedBlock;
- (void)updateUserInfomationFinished:(void(^)(id responseObject))completedBlock Failed:(void(^)(NSError* error))failedBlock;
- (void)loadCourseHistoryIsUpdate:(BOOL)isUpdate andFinished:(void(^)(BOOL succeed, NSString *message))finishedBlock;

- (void)loadCourseHistoryWithFinished:(void(^)(BOOL succeed, NSArray *historyArray,NSString *message))finishedBlock;


// 获取观看记录
- (void)loadCourseHistoryFormDatabaseIsUpdate:(BOOL)isUpdate andFinished:(void(^)(BOOL succeed, NSString *message))finishedBlock;
// 清空最近观看记录
- (void)clearRecentLearnedWithFinished:(void(^)(BOOL succeed, NSString *message))finishedBlock;



@property (nonatomic, strong) NSArray *historyLearnedModelArray;

- (void)loadCacheSize:(void(^)(double cacheSize))cacheSizeBlock; // 单位 MB

@end
