//
//  BXGStudyViewModel.m
//  Boxuegu
//
//  Created by Renying Wu on 2017/4/12.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudyViewModel.h"
#import "BXGConstrueModel.h"
#import "BXGCourseOutlineChapterModel.h"
#import "BXGProDayPlanModel.h"
#import "BXGUserViewModel.h"
#import "BXGStudyPayCourseModel.h"
#import "BXGCourseDetailViewModel.h"
#import "BXGLearnStatusTable.h"
#import "BXGHistoryModel.h"

@interface BXGStudyViewModel() <BXGNotificationDelegate>
@end

@implementation BXGStudyViewModel

static BXGStudyViewModel* instance;
+ (instancetype)share {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BXGStudyViewModel new];
    });
    
    return instance;
}

#pragma NotificationDelegate

/** 
 截取 退出登录通知
 */
- (void)catchUserLoginNotificationWith:(BOOL)isLogin {
    
    if(!isLogin){
        
        // -- 用户退出登录时候操作 --
    }
}



// 每次回到主界面判断同步未同步数据

#pragma mark - Interface

- (void)loadAppCourseFinished:(void(^_Nullable)(BOOL succeed,
                                                NSArray *procourseModelArray,
                                                NSArray *minicourseModelArray,
                                                NSString *message))finishedBlock {
    // 初始化
    // __weak typeof (self) weakSelf = self;
    NSString *userId;
    NSString *sign;
    
    if(!finishedBlock){
        
        return;
    }
    
    // 安全判断
    if(!self.userModel) {
        
        finishedBlock(false,nil,nil,@"参数错误");
        return;
    }
    
    
    
    // 设置参数
    userId = self.userModel.user_id;
    sign = self.userModel.sign;
    
    // 请求数据
    [self.networkTool requestAppCourceWithUserID:userId andSign:sign andFinished:^(id  _Nullable responseObject) {
        
        NSMutableArray *proModelArray = [NSMutableArray new];
        NSMutableArray *miniModelArray = [NSMutableArray new];

        if([responseObject isKindOfClass:[NSDictionary class]]){
        
            id success = responseObject[@"success"];
            id resultObject = responseObject[@"resultObject"];
            
            if([success isKindOfClass:[NSNumber class]] && [success boolValue]) {
            
                if([resultObject isKindOfClass:[NSArray class]]) {
                
                    for(NSInteger i = 0; i < [resultObject count]; i++){
                    
                        BXGCourseModel *model = [BXGCourseModel yy_modelWithDictionary:resultObject[i]];
                        if(model){
                            
                            if(model.type.integerValue == BXGCourseModelTypeProCourse){
                                // 职业课
                                [proModelArray addObject: model];
                                
                            }
                            
                            if(model.type.integerValue == BXGCourseModelTypeMiniCourse){
                                // 微课
                                [miniModelArray addObject:model];
                            }
                        }
                    }
                    finishedBlock(true,proModelArray,miniModelArray,nil);
                    
                }else {
                
                    // 没有数据
                    finishedBlock(false,nil,nil,@"没有数据");
                }
                
            }else {
            
                // 失败
                finishedBlock(false,nil,nil,@"请求失败");
            }
        }else {
        
            // 失败
            finishedBlock(false,nil,nil,@"请求失败");
        }
    } Failed:^(NSError * _Nullable error) {
        
        // 服务器异常
        finishedBlock(false,nil,nil,@"服务器异常");
    }];
}



#pragma Operation

//- (void)loadAppCourceIsUpdate:(BOOL)isUpdate andFinished:(void(^_Nullable)(BOOL succeed, NSString *message))finishedBlock {
//    
//    __weak typeof (self) weakSelf = self;
//    NSString *userId;
//    NSString *sign;
//    
//    // 安全判断
//    if(!self.userModel) {
//        finishedBlock(false,@"参数错误");
//        return;
//    }
//    
//    userId = self.userModel.user_id;
//    sign = self.userModel.sign;
//
//    [self.networkTool requestAppCourceWithUserID:userId andSign:sign andFinished:^(id  _Nullable responseObject) {
//        
//        NSDictionary *dict = responseObject;
//        NSMutableArray *proModelArray = [NSMutableArray new];
//        NSMutableArray *miniModelArray = [NSMutableArray new];
//        id success = dict[@"success"];
//        id resultObject = dict[@"resultObject"];
//        
//        if(success && success != [NSNull null] && [success boolValue] && resultObject && resultObject != [NSNull null]) {
//            
//            id arr = resultObject;
//            
//            if(arr && arr != [NSNull null] )
//            {
//                for(NSInteger i = 0; i < [arr count]; i++) {
//                    
//                    if([arr[i] isKindOfClass:[NSDictionary class]]) {
//                        
//                        BXGCourseModel *model = [BXGCourseModel yy_modelWithDictionary:arr[i]];
//                        if(model){
//                            
//                            if(model.type.integerValue == BXGCourseModelTypeProCourse){
//                                // 职业课
//                                [proModelArray addObject: model];
//                                
//                            }else {
//                                // 微课
//                                [miniModelArray addObject:model];
//                            }
//                        }
//                        
//                    }else {
//                        
//                        finishedBlock(false, @"解析异常");
//                    }
//                }
//            }
//
//            weakSelf.proCourseModelArray = proModelArray.copy;
//            weakSelf.miniCourseModelArray = miniModelArray.copy;
//        }
//        finishedBlock(true,nil);
//        
//    } Failed:^(NSError * _Nullable error) {
//        
//        finishedBlock(false, kBXGToastLodingError);
//    }];
//}






-(void)requestReLoginFinished:(void(^)(id responseObject))finishedBlock Failed:(void(^)(NSString *))failedBlock; {
    
    if(!self.userModel){
        
        failedBlock(@"未登录");
        return;
    }
    NSString *userName = self.userModel.username;
    NSString *passWord = self.userModel.psw;
    
    [[BXGUserViewModel share] requestLoginUserName:userName passWord:passWord Finished:finishedBlock Failed:failedBlock];
}

-(void)requestReLoginFinished:(void(^)(BOOL success))finishedBlock {
    
    if(!self.userModel){
        
        finishedBlock(false);
        return;
    }
    
    NSString *userName = self.userModel.username;
    NSString *passWord = self.userModel.psw;
    
    [[BXGUserViewModel share] requestLoginUserName:userName passWord:passWord Finished:^(id  _Nullable responseObject) {

        finishedBlock(true);
        
    } Failed:^(NSString * _Nullable message) {
        
        finishedBlock(false);
    }];
}

- (void)requestUpdateOfflineStudyStatusWithFinished:(void(^ _Nullable)(BOOL success))finishedBlock {

    if(!self.userModel){
        
        if(finishedBlock) {
        
            finishedBlock(false);
        }
        
        return;
    }
    BXGLearnStatusTable *table = [BXGLearnStatusTable new];
    NSArray *array = [table searchAllRecord];
    
    if(array.count > 0) {
    
        NSString *sign = self.userModel.sign;
        NSString *userId = self.userModel.user_id;
        NSString *videoData = [array yy_modelToJSONString];
        
        [self.networkTool requestUpdateOfflineStudyStatusWithVideoData:videoData andSign:sign andUserId:userId andFinished:^(id  _Nullable responseObject) {
            
            // 更新成功
            [table deleteAllRecord]; // 删除未同步表数据
            if(finishedBlock) {
                
                finishedBlock(true);
            }
        } Failed:^(NSError * _Nonnull error) {
            
            // 更新失败
            if(finishedBlock) {
                
                finishedBlock(false);
            }
        }];
    }
}

- (void)loadLastLearnHistoryWithFinished:(void(^ _Nullable)(id _Nullable model))finishedBlock {

    if(!self.userModel) {
    
        return finishedBlock(nil);
    }
    
    NSString *sign = self.userModel.sign;
    NSString *userId = self.userModel.user_id;
    
    [self.networkTool requestLastlearnHistoryWithSign:sign andUserId:userId andCourseId:nil andFinished:^(id  _Nullable responseObject) {
    
        if(responseObject) {
        
            BXGHistoryModel *model;
            id success = responseObject[@"success"];
            if([success isKindOfClass:[NSNumber class]] && [success boolValue]) {
            
                id result = responseObject[@"resultObject"];
                if([result isKindOfClass:[NSDictionary class]]) {
                
                    model = [BXGHistoryModel yy_modelWithDictionary:result];
                }
                
            }
            if(finishedBlock) {
                
                finishedBlock(model);
            }
            
        }else {
        
            if(finishedBlock) {
                
                finishedBlock(nil);
            }
        }
        
        
    } Failed:^(NSError * _Nonnull error) {
        
        if(finishedBlock) {
            
            finishedBlock(nil);
        }
    }];
}

@end
