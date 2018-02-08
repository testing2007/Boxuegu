//
//  BXGUserViewModel.m
//  Boxuegu
//
//  Created by RW on 2017/4/14.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGUserViewModel.h"
#import "BXGUserModel.h"

@interface BXGUserViewModel()
@end

@implementation BXGUserViewModel

#pragma mark Init

+ (instancetype)share{
    
    static BXGUserViewModel *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [BXGUserViewModel new];
    });
    return instance;
}

- (instancetype)init {

    self = [super init];
    if(self) {
    
    }
    return self;
}

#pragma mark - Getter Setter

#pragma mark Function
/**
 使用手机号码注册
 */
-(void)requestPhoneRegistWithUserName:(NSString*)userName passWord:(NSString*)passWord mobile:(NSString*)mobile code:(NSString*)code Finished:(void(^)(id responseObject))finishedBlock Failed:(void(^)(NSError * error))failedBlock; {
    
    [[BXGNetWorkTool sharedTool] requestPhoneRegistWithUserName:userName passWord:passWord mobile:mobile code:code Finished:finishedBlock Failed:failedBlock];
}

/**
 请求 重置密码
 */

-(void)requestResetPassWord:(NSString* _Nullable)passWord mobile:(NSString* _Nullable)mobile Finished:(void(^)(BOOL success,NSString * _Nullable errorMessage))finishedBlock{
    
    [self.networkTool requestResetPasswordWithPhoneNumber:mobile andPassword:passWord andFinished:^(id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject;
        id successResult = dict[@"success"];
        if(successResult != nil && [successResult isKindOfClass:[NSNumber class]]){
        
            if([successResult boolValue]) {
            
                finishedBlock(true,nil);
            }else
            {
            
                id errorMessage = dict[@"errorMessage"];
                
                if(errorMessage && errorMessage != [NSNull null] && [errorMessage isKindOfClass:[NSString class]] && [errorMessage length] > 0){
                    
                    finishedBlock(false,errorMessage);
                    
                }else {
                
                    finishedBlock(true,@"未知错误");
                }
            }
        }
    } Failed:^(NSError * _Nonnull error) {
//#define kBXGToastNoNetworkError @"网络好像有点问题，请检查后重试!"
//#define kBXGToastLodingError @"服务器开了个小差，请稍后重试!"
        finishedBlock(true,kBXGToastNoNetworkError);
    }];

}

//-(void)requestLoginUserName:(NSString*)userName passWord:(NSString*)passWord Finished:(void(^)(id responseObject))finishedBlock Failed:(void(^)(NSString *))failedBlock; {
//
//    // 清除上次用户信息
//    BXGUserDefaults *userInfo = [BXGUserDefaults share];
//
//
//    [[BXGNetWorkTool sharedTool] requestLoginUserName:userName passWord:passWord Finished:^(id responseObject) {
//
//        NSDictionary *dict = responseObject;
//        [userInfo logoutOperation];
//        if([dict[@"success"] boolValue] && dict[@"resultObject"]){
//
//            BXGUserModel *model = [BXGUserModel yy_modelWithDictionary:dict[@"resultObject"]];
//            if(model){
//
//                model.psw = passWord;
//                [BXGUserDefaults share].userModel = model;
//                [BXGNotificationTool postNotificationForUserLogin:true];
//                finishedBlock(model);
//            }else {
//
//                failedBlock(@"未知错误");
//            }
//
//            // 登录成功
//            return;
//        }
//        // 账号或密码错误/未注册
//        RWLog(@"账号或密码错误/未注册");
//
//        id errorMessage = dict[@"errorMessage"];
//
//        if(errorMessage && errorMessage != [NSNull null] && [errorMessage isKindOfClass:[NSString class]] && [errorMessage length] > 0){
//
//            failedBlock(errorMessage);
//            return;
//
//        }
//        failedBlock(@"未知错误");
//    } Failed:^(NSError *error) {
//
//        // 服务器异常
//        failedBlock(kBXGToastLodingError);
//    }];
//}

/**
 请求 发送动态码(用户注册)
 */
-(void)requestRegistCodeWithMobile:(NSString*)mobile Finished:(void(^)(id responseObject))finishedBlock Failed:(void(^)(NSError * _Nonnull error))failedBlock {

    [[BXGNetWorkTool sharedTool]  requestRegistCodeWithMobile:mobile Finished:finishedBlock Failed:finishedBlock];
}

/**
 请求 发送动态码(修改密码)
 */
- (void)requestSendCodeForResetPswWithMobile:(NSString *)mobile Finished:(void(^)(BOOL success,NSString *errorMessage))finishedBlock {
    
    [self.networkTool requestResetPasswordCodeWithMobile:mobile Finished:^(id  _Nullable responseObject) {
        
        if(responseObject){
            
            id value = responseObject[@"success"];
            if(value && value != [NSNull null] && [value isKindOfClass:[NSNumber class]] && [value boolValue] == true){
                
                finishedBlock(true, nil);
                return;
            }else {
                
                id value = responseObject[@"errorMessage"];
                if(value && value != [NSNull null] && [value isKindOfClass:[NSString class]] && [value length] > 0){
                    
                    finishedBlock(false, value);
                    return;
                    
                }else {
                    
                    finishedBlock(false, @"未知错误");
                    return;
                }
            }
        }
        return;
        
    } Failed:^(id error) {
        
        finishedBlock(false, kBXGToastLodingError);
    }];
    
}

- (void)loadAppRequestCodeWithMobile:(NSString * _Nullable)mobile
                          withIsBind:(BOOL)bBind
                            Finished:(void(^_Nullable)(BOOL success,NSString * _Nullable errorMessage))finishedBlock {
    [self.networkTool appRequestCodeWithMobile:mobile
                                    withIsBind:bBind
                                      Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
                                          if(status==200) {
                                              finishedBlock(TRUE, @"成功");
                                          } else {
                                              finishedBlock(FALSE, message);
                                          }
                                      }];
}


/**
 校验验证吗 for regist
 */
- (void)checkVerificationCodeForRegist:(NSString * _Nullable)code mobile:(NSString * _Nullable)mobile andFinished:(void(^_Nullable)(BOOL success))finishedBlock Failed:(void(^_Nullable)(id _Nullable errorMessage))failedBlock; {

    // [[BXGNetWorkTool sharedTool] requestUserExistsWithMobile:mobile andCode:code andFinished:^(id responseObject) {

    
    [[BXGNetWorkTool sharedTool] requestCheckVerificationCodeForRegist:code mobile:mobile andFinished:^(id  _Nullable responseObject) {
        
        id value = responseObject[@"success"];
        if(value && value !=[NSNull null] && [value isKindOfClass:[NSNumber class]] && [value boolValue] == true)
        {
            finishedBlock(true);
            return;
            
        }else {
            
            id value = responseObject[@"errorMessage"];
            if(value && value !=[NSNull null] && [value isKindOfClass:[NSString class]] && [value length] > 0)
            {
                failedBlock(value);
                return;
                
            }
            // 服务器异常
            failedBlock(@"未知错误");
            return;
        }
    } Failed:^(NSError * _Nullable error) {
        // 网路异常
        failedBlock(kBXGToastLodingError);
        return;
    }];
}/**
  校验验证吗 for reset psw
  */
- (void)checkVerificationCodeForResetPsw:(NSString * _Nullable)code mobile:(NSString * _Nullable)mobile andFinished:(void(^_Nullable)(BOOL success))finishedBlock Failed:(void(^_Nullable)(id _Nullable errorMessage))failedBlock; {
    
    // [[BXGNetWorkTool sharedTool] requestUserExistsWithMobile:mobile andCode:code andFinished:^(id responseObject) {
    
    
    [[BXGNetWorkTool sharedTool] requestCheckVerificationCodeForResetPsw:code mobile:mobile andFinished:^(id  _Nullable responseObject) {
        
        id value = responseObject[@"success"];
        if(value && value !=[NSNull null] && [value isKindOfClass:[NSNumber class]] && [value boolValue] == true)
        {
            finishedBlock(true);
            return;
            
        }else {
            
            id value = responseObject[@"errorMessage"];
            if(value && value !=[NSNull null] && [value isKindOfClass:[NSString class]] && [value length] > 0)
            {
                failedBlock(value);
                return;
                
            }
            // 服务器异常
            failedBlock(@"未知错误");
            return;
        }
    } Failed:^(NSError * _Nullable error) {
        // 网路异常
        failedBlock(kBXGToastLodingError);
        return;
    }];
}

- (void)saveLastUserID:(NSString *)userId {
    
    BXGUserDefaults *userInfo = [BXGUserDefaults share];
    userInfo.lastUserID = userId;
}

- (void)saveCourseName:(NSString *)courseName {
    
    BXGUserDefaults *userInfo = [BXGUserDefaults share];
    userInfo.courseName = courseName;
}

- (NSString *)loadLastUserID {

    BXGUserDefaults *userInfo = [BXGUserDefaults share];
    return userInfo.lastUserID;
}

#pragma mark - Request

- (void)requestSendCodeForRegistWithMobile:(NSString *)mobile Finished:(void(^)(BOOL success))finishedBlock Failed:(void(^)(id  _Nonnull errorMessage))failedBlock {
    
    [self.networkTool requestRegistCodeWithMobile:mobile Finished:^(id  _Nullable responseObject) {
        
        if(responseObject){
        
            id value = responseObject[@"success"];
            if(value && value != [NSNull null] && [value isKindOfClass:[NSNumber class]] && [value boolValue] == true){
            
                finishedBlock(true);
                return;
            }else {
            
                id value = responseObject[@"errorMessage"];
                if(value && value != [NSNull null] && [value isKindOfClass:[NSString class]] && [value length] > 0){
                
                    failedBlock(value);
                    return;
                    
                }else {
                
                    failedBlock(@"未知错误");
                    return;
                }
            }
        }
        return;
        
    } Failed:^(id error) {
        
        failedBlock(kBXGToastLodingError);
    }];
    
}




#pragma mark - BXGNotificationDelegate

/**
 截取用户登录登出通知

 @param isLogin 登录: 1 登出 2
 */
- (void)catchUserLoginNotificationWith:(BOOL)isLogin {

    if(!isLogin){
    
        // -- 用户退出登录时候操作 --
        
    }
}

@end
