//
//  BXGMeViewModel.m
//  Boxuegu
//
//  Created by RW on 2017/4/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMeViewModel.h"

#import "BXGProCourseModel.h"
#import "BXGLearnedHistoryModel.h"
#import "BXGDownloader.h"
#import "BXGDatabase.h"

#import "BXGHistoryTable.h"
#import "BXGLearningRecordModel.h"

@implementation BXGMeViewModel

static BXGMeViewModel *instance;
+ (instancetype)share {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BXGMeViewModel new];
    });

    return instance;
}

#pragma mark Getter Setter

// 退出登录
- (void)operationLogout {

    // 清除上次用户信息
    BXGUserDefaults *userInfo = [BXGUserDefaults share];
    [userInfo logoutOperation];
    [BXGNotificationTool postNotificationForUserLogin:false];

}

// 功能-清除缓存
- (void)operationClearImageCaches {
    
    [[SDImageCache sharedImageCache] clearDisk];
}

- (void)loadCacheSize:(void(^)(double cacheSize))cacheSizeBlock{

    [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        cacheSizeBlock(totalSize / (1024 * 1024.0));
    }];
}

- (void)requestFeedBackWithText:(NSString *)text andPhoneNumber:(NSString *)phoneNumber andFinished:(void(^)(id responseObject))completedBlock Failed:(void(^)(NSError* error))failedBlock; {
    
    BXGUserModel *model = [BXGUserDefaults share].userModel;
    [[BXGNetWorkTool sharedTool]requestFeedBackWithUserID:model.user_id andSign:model.sign andPhoneNumber:phoneNumber andText:text andFinished:^(id  _Nullable responseObject) {
        
        completedBlock(responseObject);
        
    } Failed:^(NSError * _Nonnull error) {
        
        failedBlock(error);
    }];
}

- (void)updateUserInfomationFinished:(void(^)(id responseObject))completedBlock Failed:(void(^)(NSError* error))failedBlock; {

    if([BXGUserCenter share].userModel) {
        NSString *userId = [BXGUserDefaults share].userModel.user_id;
        NSString *sign = [BXGUserDefaults share].userModel.sign;
        BOOL __block isModified = false;
        [[BXGNetWorkTool sharedTool] requestUserinfomationWithUserId:userId andSign:sign andFinished:^(id  _Nullable responseObject) {
            if(responseObject) {
                
                id resultObject = responseObject[@"resultObject"];
                
                BXGUserModel *userModel = [BXGUserDefaults share].userModel;
                if(resultObject && resultObject != [NSNull null]){
                    
                    BXGUserModel *newUserModel = [BXGUserModel yy_modelWithDictionary:resultObject];
                    if(![userModel.head_img isEqualToString:newUserModel.head_img]) {
                        
                        userModel.head_img = newUserModel.head_img;
                        isModified = true;
                    }
                    
                    if(![userModel.nickname isEqualToString:newUserModel.nickname]) {
                        
                        userModel.nickname = newUserModel.nickname;
                        isModified = true;
                    }
                    
                    if(![userModel.username isEqualToString:newUserModel.username]) {
                        
                        userModel.username = newUserModel.username;
                        isModified = true;
                    }
                }
                if(isModified){
                    
                    [BXGUserDefaults share].userModel = userModel;
                    completedBlock(userModel);
                }
            }
        } Failed:^(NSError * _Nonnull error) {
            
        }];
    }
}

- (void)loadCourseHistoryIsUpdate:(BOOL)isUpdate andFinished:(void(^)(BOOL succeed, NSString *message))finishedBlock {

    NSString *userId = [BXGUserDefaults share].userModel.user_id;
    NSString *sign = [BXGUserDefaults share].userModel.sign;
    [self.networkTool requestCourseHistoryWithUserID:userId andSign:sign andFinished:^(id  _Nullable responseObject) {
       
        if(responseObject){
        
            id successValue = responseObject[@"success"];
            if([successValue isKindOfClass:[NSNumber class]] && [successValue boolValue]){
            
                NSArray *resultObjectValue = responseObject[@"resultObject"];
                if([resultObjectValue isKindOfClass:[NSArray class]]){
                
                    NSMutableArray *modelArray = [NSMutableArray new];
                    for(NSInteger i = 0; i < resultObjectValue.count; i++){
                    
                        BXGLearnedHistoryModel *model = [BXGLearnedHistoryModel yy_modelWithDictionary:resultObjectValue[i]];
                        if(model){
                        
                            [modelArray addObject:model];
                        }
                        
                    }
                    self.historyLearnedModelArray = modelArray;
                    finishedBlock(true,@"加载成功");

                }else {
                
                    // todo not success
                    finishedBlock(false,@"未知错误 -3");
                    
                }
                
            }else {
            
                
                // todo not success
                finishedBlock(false,@"未知错误 -2");
                
            }
            
        }else {
        
            // todo error
            finishedBlock(false,@"未知错误 -1");
        }
        
    } Failed:^(NSError * _Nullable error) {
        
        finishedBlock(false,kBXGToastNoNetworkError);
    }];
}
- (void)loadCourseHistoryWithFinished:(void(^)(BOOL succeed, NSArray *historyArray,NSString *message))finishedBlock; {

    NSString *userId = [BXGUserDefaults share].userModel.user_id;
    NSString *sign = [BXGUserDefaults share].userModel.sign;
    [self.networkTool requestCourseHistoryWithUserID:userId andSign:sign andFinished:^(id  _Nullable responseObject) {
        
        if(responseObject){
            
            id successValue = responseObject[@"success"];
            if([successValue isKindOfClass:[NSNumber class]] && [successValue boolValue]){
                
                NSArray *resultObjectValue = responseObject[@"resultObject"];
                if([resultObjectValue isKindOfClass:[NSArray class]]){
                    
                    NSMutableArray *modelArray = [NSMutableArray new];
                    for(NSInteger i = 0; i < resultObjectValue.count; i++){
                        
                        BXGLearningRecordModel *model = [BXGLearningRecordModel yy_modelWithDictionary:resultObjectValue[i]];
                        if(model){
                            
                            [modelArray addObject:model];
                        }
                        
                    }
                    self.historyLearnedModelArray = modelArray;
                    finishedBlock(true,modelArray,@"加载成功");
                    
                }else {
                    
                    // todo not success
                    finishedBlock(false,nil,@"未知错误 -3");
                    
                }
                
            }else {
                
                
                // todo not success
                finishedBlock(false,nil,@"未知错误 -2");
                
            }
            
        }else {
            
            // todo error
            finishedBlock(false,nil,@"未知错误 -1");
        }
        
    } Failed:^(NSError * _Nullable error) {
        
        finishedBlock(false,nil,kBXGToastNoNetworkError);
    }];
}



#pragma BXG NotificationDelegate

- (void)catchUserLoginNotificationWith:(BOOL)isLogin {
    
    if(!isLogin){
        
        //程序退出
        [[BXGDownloader shareInstance] cancelAllDownloading];
        [[BXGDatabase shareInstance] close];//关闭数据库
    }
}
- (void)loadCourseHistoryFormDatabaseIsUpdate:(BOOL)isUpdate andFinished:(void(^)(BOOL succeed, NSString *message))finishedBlock; {

    BXGHistoryTable *historyTable = [BXGHistoryTable new];
    NSArray *array = [historyTable searchGroupLastHistory];
    
    if(array){
    
        self.historyLearnedModelArray = array;
        finishedBlock(true, @"成功");
        
    }else {
        
        finishedBlock(false, @"失败");
    }
}

- (void)clearRecentLearnedWithFinished:(void(^)(BOOL succeed, NSString *message))finishedBlock; {

    BXGHistoryTable *historyTable = [BXGHistoryTable new];
    if([historyTable deleteAllRecords]) {
    
        finishedBlock(true, @"成功");
    }else {
        
        finishedBlock(false, @"失败");
    }
}
@end
