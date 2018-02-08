//
//  BXGNetWorkTool+App.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGNetWorkTool+App.h"
#import "RWDeviceInfo.h"

@implementation BXGNetWorkTool (App)

#pragma mark - App Base Request

- (void)appBaseRequestType:(RequestType)type
              andURLString:(NSString * _Nullable)url
              andParameter:(id _Nullable)para andFinished:(BXGNetworkCallbackBlockType _Nullable) finished {
    
    [self requestType:type andBaseURLString:MainBaseUrlString andUrlString:url andParameter:para andFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser mainNetworkParser:responseObject andFinished:finished];
    } andFailed:^(NSError * _Nonnull error) {
        [BXGNetworkParser mainNetworkParser:error andFinished:finished];
    }];
}

#pragma mark - 版本兼容

-(void)requestType:(RequestType)type baseURLType:(BaseURLType)baseURLType andUrlString:(NSString*) urlString Parameter:(id)para Finished:(void(^)(id responseObject))finishedBlock  Progress:(void(^)(NSProgress* progress))progressBlock  Failed:(void(^)(NSError * _Nonnull error))failedBlock
{
    __weak typeof (self) weakSelf = self;
    
    // self.baseURL = [NSURL URLWithString:baseUrlString];
    
    // 全局字段
    NSMutableDictionary *mPara = [NSMutableDictionary dictionaryWithDictionary:para];
    if([RWDeviceInfo deviceModel]) {
        mPara[@"device"] = [RWDeviceInfo deviceModel];
        mPara[@"os"] = @"ios";
        mPara[@"imei"] = self.imei;
        BXGUserModel *userModel = [BXGUserCenter share].userModel;
        if(userModel){
            mPara[@"user_id"]= userModel.user_id;
            mPara[@"sign"] = userModel.sign;
            mPara[@"userId"] = userModel.itcast_uuid; // 学习圈id
        }
    }
    
    
    void(^success)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)  = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        
        // 判断是否 sign 过期
        if(responseObject){
            
            id errorMessage = responseObject[@"errorMessage"];
            if([errorMessage isKindOfClass:[NSString class]]) {
                
                if([errorMessage isEqualToString:@"1001"]) {
                    
                    if(weakSelf.networkDelegate && [weakSelf.networkDelegate respondsToSelector:@selector(networkServerError)]) {
                        
                        [weakSelf.networkDelegate networkServerError];
                    };
                    finishedBlock(nil);
                    return;
                }
                
            }
        }
        RWNetworkLog(@"\nUrl:\n%@\n,para:\n%@\n,response:\n%@\n", urlString,mPara,responseObject);
        finishedBlock(responseObject);
    };
    
    void(^failure)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        RWNetworkLog(@"\nUrl:\n%@\n,para:\n%@\n,error:\n%@\n", urlString,mPara,error);
        failedBlock(error);
    };
    void(^progress)(NSProgress * _Nonnull Progress) = ^(NSProgress * _Nonnull Progress)
    {
        if (progressBlock != nil) {
            progressBlock(Progress);
            
        }
    };
    
    switch (baseURLType) {
        case BaseURLTypeMain:{
            
            urlString = [MainBaseUrlString stringByAppendingPathComponent:urlString];
            if (type == GET)
            {
                [self GET:urlString parameters:mPara progress:progress success:success failure:failure];
                
            }else if (type == POST)
            {
                [self POST:urlString parameters:mPara progress:progress success:success failure:failure];
            }
            
        }break;
            
        case BaseURLTypeComunity:{
            
            urlString = [CommunityBaseUrlString stringByAppendingPathComponent:urlString];
            
            if (type == GET)
            {
                [self GET:urlString parameters:mPara progress:progress success:success failure:failure];
                
            }else if (type == POST)
            {
                [self POST:urlString parameters:mPara progress:progress success:success failure:failure];
            }
        }break;
    }
}

-(void)requestType:(RequestType)type UrlString:(NSString*) urlString Parameter:(id)para Finished:(void(^)(id responseObject))finishedBlock  Progress:(void(^)(NSProgress* progress))progressBlock  Failed:(void(^)(NSError * _Nonnull error))failedBlock
{
    
    __weak typeof (self) weakSelf = self;
    
    void(^mfinishedBlock)(id responseObject) = ^(id responseObject){
        
        // 判断是否 sign 过期
        if(responseObject){
            
            id errorMessage = responseObject[@"errorMessage"];
            if([errorMessage isKindOfClass:[NSString class]]) {
                
                if([errorMessage isEqualToString:@"1001"]) {
                    
                    if(weakSelf.networkDelegate && [weakSelf.networkDelegate respondsToSelector:@selector(networkServerError)]) {
                        
                        [weakSelf.networkDelegate networkServerError];
                    };
                    finishedBlock(nil);
                    return;
                }
                
            }
        }
        finishedBlock(responseObject);
    };
    
    [self requestType:type baseURLType:BaseURLTypeMain andUrlString:urlString Parameter:para Finished:mfinishedBlock Progress:progressBlock Failed:failedBlock];
    
} 

#pragma mark - App Request

/// 用户: 登录
-(void)appRequestLoginUserName:(NSString * _Nullable)userName
                      Password:(NSString * _Nullable)password
                      Finished:(BXGNetworkCallbackBlockType _Nullable) finished;{
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"username"] = userName;
    para[@"password"] = password;
    
    // url
    NSString *url = @"bxg/user/loginForAPP";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}


/**
 请求执行 "注册手机号注册用户"
 */
- (void)requestPhoneRegistWithUserName:(NSString * _Nullable)userName
                              passWord:(NSString * _Nullable)passWord
                                mobile:(NSString * _Nullable)mobile
                                  code:(NSString * _Nullable)code
                              Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock; {
    
    // 参数安全判断
    if(!userName || !passWord || !mobile || !code || !self.imei){
        
        RWNetworkLog(@"参数异常");
        finishedBlock(nil);
        return;
    }
    
    // 设置参数
    NSDictionary *parameter = @{
                                @"username" : userName,
                                @"password" : passWord,
                                @"mobile" : mobile,
                                @"code" : code,
                                @"imei" : self.imei
                                };
    
    // 发送请求
    [self requestType:POST UrlString:@"/bxg/user/phoneRegistForAPP" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}
- (void)appRequestPhoneRegistWithUserName:(NSString * _Nullable)userName
                              PassWord:(NSString * _Nullable)password
                                Mobile:(NSString * _Nullable)mobile
                                  Code:(NSString * _Nullable)code
                              Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {

    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"username"] = userName;
    para[@"password"] = password;
    para[@"mobile"] = mobile;
    para[@"code"] = code;
    para[@"password"] = password;
    
    // url
    NSString *url = @"/bxg/user/phoneRegistForAPP";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/**
 请求执行 "发送动态码" (注册)
 */
-(void)requestRegistCodeWithMobile:(NSString * _Nullable)mobile
                          Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                            Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    
    // 参数安全判断
    if(!mobile){
        RWNetworkLog(@"参数异常");
        finishedBlock(@"参数异常");
        return;
    }
    
    // 设置参数
    NSDictionary *parameter = @{
                                @"mobile" : mobile,
                                @"vtype" : @"1",
                                };
    
    // 发送请求
    [self requestType:POST UrlString:@"bxg/user/sendCodeForApp" Parameter:parameter Finished:^(id responseObject) {
        
        finishedBlock(responseObject);
        RWNetworkLog(@"%@",responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}

- (void)appRequestRegistCodeWithMobile:(NSString * _Nullable)mobile
                              Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"mobile"] = mobile;
    para[@"vtype"] = @"1";
    // url
    NSString *url = @"bxg/user/sendCodeForApp";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/**
 请求执行 "发送动态码" (重置)
 */
-(void)requestResetPasswordCodeWithMobile:(NSString * _Nullable)mobile
                                 Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                   Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    // 参数安全判断
    if(!mobile){
        RWNetworkLog(@"参数异常");
        finishedBlock(nil);
        return;
    }
    
    // 设置参数
    NSDictionary *parameter = @{
                                @"mobile" : mobile,
                                @"vtype" : @"2",
                                };
    
    // 发送请求
    [self requestType:POST UrlString:@"bxg/user/sendCodeForApp" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}

-(void)appRequestCodeWithMobile:(NSString * _Nullable)mobile
                     withIsBind:(BOOL)bBind
                       Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"mobile"] = mobile;
    if(bBind) {
        para[@"vtype"] = @"1";
        para[@"channel"] = @"bind";
    } else {
        para[@"vtype"] = @"2";
    }
    
    // url
    NSString *url = @"bxg/user/sendCodeForApp";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}


/**
 请求执行 "退出登录操作"
 */
- (void)requestLogoutWithUserID:(NSString * _Nullable)userID
                        andSign:(NSString * _Nullable)sign
                    andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                         Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock; {
    
    //
    RWNetworkLog(@"接口已废弃");
    return;
    // 参数安全判断
    if(!userID || !sign){
        
        RWNetworkLog(@"参数异常");
        finishedBlock(nil);
        return;
    }
    
    // 设置参数
    NSDictionary *parameter = @{
                                @"user_id" : userID,
                                @"sign" : sign,
                                };
    
    // 开始请求
    [self requestType:POST UrlString:@"/bxg/user/logoutForAPP" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
        
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}

- (void)appRequestLogoutWithFinished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    
    RWNetworkLog(@"接口已废弃");
    return;
    
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    
    // url
    NSString *url = @"/bxg/user/logoutForAPP";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

#pragma mark - 意见反馈

/**
 反馈请求
 */
- (void)requestFeedBackWithUserID:(NSString * _Nullable)userID
                          andSign:(NSString * _Nullable)sign
                   andPhoneNumber:(NSString * _Nullable)phoneNumber
                          andText:(NSString * _Nullable)fbText
                      andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                           Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    
    // 参数安全判断
    if(!userID || !sign || !phoneNumber || !fbText){
        
        RWNetworkLog(@"%@",@"参数异常");
        finishedBlock(nil);
        return;
    }
    
    // 设置参数
    NSDictionary *parameter = @{
                                @"user_id" : userID,
                                @"sign" : sign,
                                @"fb_phone" : phoneNumber,
                                @"fb_context" : fbText
                                };
    
    [self requestType:POST UrlString:@"/bxg/fb/addfb" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}

- (void)appRequestFeedBackWithPhoneNumber:(NSString * _Nullable)phoneNumber
                                     Text:(NSString * _Nullable)fbText
                                 Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"fb_phone"] = phoneNumber;
    para[@"fb_context"] = fbText;
    
    // url
    NSString *url = @"/bxg/fb/addfb";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
    
}

/**
 获取我的职业课程
 */
- (void)requestMyVocationalWithUserID:(NSString * _Nullable)userID
                          andCourseId:(NSString * _Nullable)courseId
                              andSign:(NSString * _Nullable)sign
                              andDate:(NSString * _Nullable)date
                              andPage:(NSString * _Nullable)page
                          andPageSize:(NSString * _Nullable) pageSize
                          andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                               Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock; {
    
    NSString *imei= [BXGKeyChain getDeviceIDInKeychain];
    
    // 参数安全判断
    if(!userID || !sign || !date || !page || !courseId || !pageSize){
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    
    NSDictionary *parameter = @{
                                @"user_id" : userID,
                                @"course_id" : courseId,
                                @"sign" : sign,
                                @"date" : date,
                                @"imei" : imei,
                                @"os" : @"ios",
                                @"page" : page,
                                @"pageSize" : pageSize
                                };
    
    [self requestType:POST UrlString:@"/bxg/learnplan/myVocational" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error)
        failedBlock(error);
        
    }];
}

- (void)appRequestMyVocationalWithCourseId:(NSString * _Nullable)courseId
                                      Date:(NSString * _Nullable)date
                                      Page:(NSString * _Nullable)page
                                  PageSize:(NSString * _Nullable) pageSize
                                  Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    
    para[@"course_id"] = courseId;
    para[@"date"] = date;
    para[@"page"] = page;
    para[@"pageSize"] = pageSize;
    
    // url
    NSString *url = @"/bxg/learnplan/myVocational";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/**
 请求获取 "课程大纲详情"
 */
- (void)requestCourceOutlineWithCourseID:(NSString * _Nullable)courseID
                               andUserID:(NSString * _Nullable)userID
                                 andSign:(NSString * _Nullable)sign
                             andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                  Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock; {
    NSString *imei= [BXGKeyChain getDeviceIDInKeychain];
    // 参数安全判断
    if(!courseID || !userID || !sign || !imei){
        
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    
    NSDictionary *parameter = @{
                                @"course_id": courseID,
                                @"user_id" : userID,
                                @"sign" : sign,
                                @"imei" : imei,
                                @"os" : @"ios"
                                
                                };
    
    [self requestType:POST UrlString:@"/bxg/learnplan/detail" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
    
    
}

- (void)appRequestCourceOutlineWithCourseID:(NSString * _Nullable)courseID
                                   Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"course_id"] = courseID;
    
    // url
    NSString *url = @"/bxg/learnplan/detail";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/**
 请求执行 "校验用户是否注册"
 */
- (void)requestUserExistsWithMobile:(NSString * _Nullable)mobile
                            andCode:(NSString * _Nullable)code
                        andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                             Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    // 参数安全判断
    if(!mobile || !code){
        
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    NSDictionary *parameter = @{
                                @"mobile" : mobile,
                                @"code" : code,
                                };
    
    [self requestType:POST UrlString:@"/bxg/user/userExists" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
        
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}

- (void)appRequestUserExistsWithMobile:(NSString * _Nullable)mobile
                                  Code:(NSString * _Nullable)code
                              Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"mobile"] = mobile;
    para[@"code"] = code;
    
    // url
    NSString *url = @"/bxg/user/userExists";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/**
 请求执行 "校验动态码" (注册)
 */
- (void)requestCheckVerificationCodeForRegist:(NSString * _Nullable)code
                                       mobile:(NSString * _Nullable)mobile
                                  andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                       Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock; {
    // 参数安全判断
    if(!mobile || !code){
        
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    NSDictionary *parameter = @{
                                @"mobile" : mobile,
                                @"code" : code,
                                @"type" : @"1"
                                };
    
    [self requestType:POST UrlString:@"/bxg/user/checkVerificationCode" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
        
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}

- (void)appRequestCheckVerificationCodeForRegist:(NSString * _Nullable)code
                                          Mobile:(NSString * _Nullable)mobile
                                        Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"mobile"] = mobile;
    para[@"code"] = code;
    para[@"type"] = @"1";
    
    // url
    NSString *url = @"/bxg/user/checkVerificationCode";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/**
 请求执行 "校验动态码" (重置密码)
 */
- (void)requestCheckVerificationCodeForResetPsw:(NSString * _Nullable)code
                                         mobile:(NSString * _Nullable)mobile
                                    andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                         Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock; {
    // 参数安全判断
    if(!mobile || !code){
        
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    NSDictionary *parameter = @{
                                @"mobile" : mobile,
                                @"code" : code,
                                @"type" : @"2"
                                };
    
    [self requestType:POST UrlString:@"/bxg/user/checkVerificationCode" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
        
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}

- (void)appRequestCheckVerificationCodeForResetPsw:(NSString * _Nullable)code
                                            Mobile:(NSString * _Nullable)mobile
                                          Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"mobile"] = mobile;
    para[@"code"] = code;
    para[@"type"] = @"2";
    
    // url
    NSString *url = @"/bxg/user/checkVerificationCode";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/**
 请求获取 "用户信息"
 */
-(void)requestUserinfomationWithUserId:(NSString * _Nullable)userId
                               andSign:(NSString * _Nullable)sign
                           andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    // 1.安全判断
    if(!userId || !sign) {
        
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    
    // 2.设置参数
    NSDictionary *parameter = @{
                                @"user_id" : userId,
                                @"sign" : sign,
                                @"imei" : self.imei,
                                @"os" : @"ios",
                                };
    
    // 3.请求数据
    [self requestType:POST UrlString:@"/bxg/user/userInfo" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}

- (void)appRequestUserinfomationWithFinished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    
    // url
    NSString *url = @"/bxg/user/userInfo";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}



/**
 请求执行 "重置密码操作"
 */
- (void)requestResetPasswordWithPhoneNumber:(NSString * _Nullable)phoneNumber
                                andPassword:(NSString * _Nullable)psw
                                andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                     Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    
    // 1.安全判断
    if((!phoneNumber) || (!psw)){
        
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    
    // 2.设置参数
    NSDictionary *parameter = @{
                                @"mobile" : phoneNumber,
                                @"password" : psw,
                                };
    // 3.请求数据
    [self requestType:POST UrlString:@"/bxg/user/resetPassword" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
    
}

- (void)appRequestResetPasswordWithPhoneNumber:(NSString * _Nullable)phoneNumber
                                   Password:(NSString * _Nullable)psw
                                   Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"mobile"] = phoneNumber;
    para[@"password"] = psw;
    
    // url
    NSString *url = @"/bxg/user/resetPassword";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}


#pragma mark - 1.1.1 请求首页课程

/**
 请求获取 "所有已购买的微课,职业课课程详情"
 */
- (void)requestAppCourceWithUserID:(NSString * _Nullable)userID
                           andSign:(NSString * _Nullable)sign
                       andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                            Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock; {
    NSString *imei= [BXGKeyChain getDeviceIDInKeychain];
    
    // 参数安全判断
    if(!userID || !sign){
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    NSDictionary *parameter = @{
                                @"user_id" : userID,
                                @"sign" : sign,
                                @"imei" : imei,
                                @"os" : @"ios",
                                };
    
    [self requestType:POST UrlString:@"/bxg/indexCourse/myCourse" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}

- (void)appRequestAppCourceWithFinished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    
    // url
    NSString *url = @"/bxg/indexCourse/myCourse";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

#pragma mark - 学习中心
/**
 请求获取 "所有免费微课课程"
 备注:is_free 1:免费 0:收费,course_type 1:微课 0:就业课
 */
- (void)requestFreeMicroCoursesWithSign:(NSString * _Nullable)sign
                               Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                 Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    
    NSString *imei= [BXGKeyChain getDeviceIDInKeychain];
    
    // 参数安全判断
    if(!sign){
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    
    
    NSDictionary *parameter = @{
                                @"imei" : imei,
                                @"os" : @"ios",
                                @"is_free" : @"1",
                                @"course_type" : @"1",
                                @"sign" : sign,
                                };
    
    [self requestType:POST UrlString:@"/bxg/appCourse/getFreeMicroCourses" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
    
}

- (void)appRequestFreeMicroCoursesWithFinished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"is_free"] = @"1";
    para[@"course_type"] = @"1";

    // url
    NSString *url = @"/bxg/appCourse/getFreeMicroCourses";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/**
 请求获取 "课程学习进度"
 */
- (void)requestCourseProgessWithUserId:(NSString * _Nullable)userId
                           andCourseId:(NSString * _Nullable)courseId
                               andSign:(NSString * _Nullable)sign
                              Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    
    if(!userId || !sign || !userId){
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    
    NSDictionary *parameter = @{
                                @"user_id" :userId,
                                @"sign" : sign,
                                @"course_id" : courseId,
                                };
    
    [self requestType:POST UrlString:@"/bxg/learnplan/courseProgress" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
    
}

- (void)appRequestCourseProgessWithCourseId:(NSString * _Nullable)courseId
                                    andSign:(NSString * _Nullable)sign
                                   Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"course_id"] = courseId;
    // url
    NSString *url = @"/bxg/learnplan/courseProgress";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/**
 请求获取课程"月"计划
 */
- (void)requestCalendarCourseMonthPlanWithUserId:(NSString * _Nullable)userId
                                     andCourseId:(NSString * _Nullable)courseId
                                         andSign:(NSString * _Nullable)sign
                                   andDateString:(NSString * _Nullable)dateString
                                        Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                          Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    
    if(!userId || !sign || !userId || !dateString){
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    
    NSDictionary *parameter = @{
                                @"user_id" :userId,
                                @"sign" : sign,
                                @"course_id" : courseId,
                                @"date" : dateString,
                                };
    
    [self requestType:POST UrlString:@"/bxg/learnplan/getMonthPlan" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}
- (void)appRequestCalendarCourseMonthPlanWithCourseId:(NSString * _Nullable)courseId
                                           DateString:(NSString * _Nullable)dateString
                                             Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"course_id"] = courseId,
    para[@"date"] = dateString;
    
    // url
    NSString *url = @"/bxg/learnplan/getMonthPlan";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}
/**
 请求串讲信息
 */
- (void)requestConstrueWithPlanID:(NSString * _Nullable)planID
                        andUserID:(NSString * _Nullable)userID
                          andSign:(NSString * _Nullable)sign
                      andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                           Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock; {
    
    NSString *imei= [BXGKeyChain getDeviceIDInKeychain];
    if(!planID || !userID || !sign || !imei){
        
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    
    NSDictionary *parameter = @{
                                @"plan_id": planID,
                                @"user_id" : userID,
                                @"sign" : sign,
                                @"imei" : imei,
                                @"os" : @"ios"
                                
                                };
    
    [self requestType:POST UrlString:@"/bxg/learnplan/construe" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}

- (void)appRequestConstrueWithPlanID:(NSString * _Nullable)planID
                            Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"plan_id"] = planID;
    
    // url
    NSString *url = @"/bxg/learnplan/construe";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/**
 请求微课课程信息
 */
- (void)requestMiniCourceWithUserID:(NSString * _Nullable)userID
                            andSign:(NSString * _Nullable)sign
                            andPage:(NSString * _Nullable)page
                        andPageSize:(NSString * _Nullable)pageSize
                        andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                             Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock; {
    
    NSString *imei= [BXGKeyChain getDeviceIDInKeychain];
    
    // 参数安全判断
    if(!userID || !sign ||!page || !pageSize){
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    NSDictionary *parameter = @{
                                @"user_id" : userID,
                                @"sign" : sign,
                                @"imei" : imei,
                                @"os" : @"ios",
                                @"page" : page,
                                @"pageSize" : pageSize
                                };
    
    [self requestType:POST UrlString:@"/bxg/appCourse/myMiCourse" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}

- (void)appRequestMiniCourceWithPage:(NSString * _Nullable)page
                            PageSize:(NSString * _Nullable)pageSize
                            Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"page"] = page;
    para[@"pageSize"] = pageSize;
    
    // url
    NSString *url = @"/bxg/appCourse/myMiCourse";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/**
 请求所有课程信息
 */
- (void)requestAllCourceWithUserID:(NSString * _Nullable)userID
                           andSign:(NSString * _Nullable)sign
                           andPage:(NSString * _Nullable)page
                       andPageSize:(NSString * _Nullable)pageSize
                       andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                            Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock; {
    
    NSString *imei= [BXGKeyChain getDeviceIDInKeychain];
    
    // 参数安全判断
    if(!userID || !sign ||!page || !pageSize){
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    NSDictionary *parameter = @{
                                @"user_id" : userID,
                                @"sign" : sign,
                                @"imei" : imei,
                                @"os" : @"ios",
                                @"page" : page,
                                @"pageSize" : pageSize
                                };
    
    [self requestType:POST UrlString:@"/bxg/appCourse/myMiCourse" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}

- (void)appRequestAllCourceWithPage:(NSString * _Nullable)page
                           PageSize:(NSString * _Nullable)pageSize
                           Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"page"] = page;
    para[@"pageSize"] = pageSize;
    
    
    // url
    NSString *url = @"/bxg/appCourse/myMiCourse";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

#pragma mark 请求已购买的课程

/**
 请求已购买的课程
 */
- (void)requestPayCourseWithUserId:(NSString * _Nullable)userId
                           andSign:(NSString * _Nullable)sign
                       andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                            Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    
    // 1.安全判断
    if((!userId) || (!sign)) {
        
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    
    // 2.设置参数
    NSDictionary *parameter = @{
                                @"user_id" : userId,
                                @"sign" : sign,
                                @"imei" : self.imei,
                                @"os" : @"ios",
                                };
    // 3.请求数据
    [self requestType:POST UrlString:@"/bxg/appCourse/payCourse" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}

- (void)appRequestPayCourseWithFinished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    
    // url
    NSString *url = @"/bxg/appCourse/payCourse";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/**
 请求更新视频学习状态
 
 studyStatus:学习状态  0：未学习，1：已学习，2：学习中
 */
- (void)requestUpdateStudyStateWithUserId:(NSString * _Nullable)userId
                              andCourseId:(NSString * _Nullable)courseId
                               andVideoId:(NSString *_Nullable)videoId
                                  andSign:(NSString * _Nullable)sign
                                 andState:(NSString * _Nullable)state
                              andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                   Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    
    // 1.安全判断
    if((!userId) || (!sign) || !courseId || !videoId || !state) {
        
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    
    // 2.设置参数
    NSDictionary *parameter = @{
                                @"user_id" : userId,
                                @"course_id" : courseId,
                                @"video_id" : videoId,
                                @"sign" : sign,
                                @"imei" : self.imei,
                                @"studyStatus" : state,
                                @"os" : @"ios",
                                };
    //    NSMutableDictionary *parameter = [NSMutableDictionary new];
    //    [parameter setObject:userId forKey:@"user_id"];
    //    [parameter setObject:courseId forKey:@"course_id"];
    //    [parameter setObject:videoId forKey:@"video_id"];
    //    [parameter setObject:sign forKey:@"sign"];
    //    [parameter setObject:self.imei forKey:@"imei"];
    //    [parameter setObject:state forKey:@"studyStatus"];
    //    [parameter setObject:@"ios" forKey:@"os"];
    //    [parameter setObject:userId forKey:@"os"];
    // 3.请求数据
    [self requestType:POST UrlString:@"/bxg/video/updateStudyStatus" Parameter:parameter Finished:^(id responseObject) {
        
        RWLog(@"%@,%@",parameter,responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWLog(@"%@",error);
        failedBlock(error);
    }];
}

- (void)appRequestUpdateStudyStateWithCourseId:(NSString * _Nullable)courseId
                                       VideoId:(NSString *_Nullable)videoId
                                         State:(NSString * _Nullable)state
                                      Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"course_id"] = courseId;
    para[@"video_id"] = videoId;
    para[@"studyStatus"] = state;
    
    // url
    NSString *url = @"/bxg/video/updateStudyStatus";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

#pragma mark - 观看记录模块

/**
 请求获取 "所有课程已观看记录"
 */
- (void)requestCourseHistoryWithUserID:(NSString * _Nullable)userID
                               andSign:(NSString * _Nullable)sign
                           andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                Failed:(void(^ _Nullable)(NSError * _Nullable error))failedBlock; {
    
    NSString *imei= [BXGKeyChain getDeviceIDInKeychain];
    
    // 参数安全判断
    if(!userID || !sign){
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    NSDictionary *parameter = @{
                                @"user_id" : userID,
                                @"sign" : sign,
                                @"imei" : imei,
                                @"os" : @"ios",
                                };
    
    [self requestType:POST UrlString:@"/bxg/history/courseHistory" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}

- (void)appRequestCourseHistoryWithFinished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    
    // url
    NSString *url = @"/bxg/history/courseHistory";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

//#pragma mark - 购买模块
//
///**
// 请求执行 "购买免费微课" 1.0.1
// */
//- (void)requestBuyFreeMicroCourse:(NSString * _Nullable)courseId
//                        andUserId:(NSString * _Nullable)userId
//                          andSign:(NSString * _Nullable)sign
//                         Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
//                           Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
//    
//    // 参数安全判断
//    if(!sign || !courseId || !userId){
//        RWNetworkLog(@"%@",@"参数错误");
//        finishedBlock(nil);
//        return;
//    }
//    
//    NSString *imei= [BXGKeyChain getDeviceIDInKeychain];
//    
//    NSDictionary *parameter = @{
//                                @"imei" : imei,
//                                @"os" : @"ios",
//                                @"sign" : sign,
//                                @"course_id" :courseId,
//                                @"user_id" :userId,
//                                };
//    
//    [self requestType:POST UrlString:@"/bxg/appCourse/addFreeMicroCourses" Parameter:parameter Finished:^(id responseObject) {
//        
//        RWNetworkLog(@"%@",responseObject);
//        finishedBlock(responseObject);
//    } Progress:nil Failed:^(NSError * _Nonnull error) {
//        
//        RWNetworkLog(@"%@",error);
//        failedBlock(error);
//    }];
//    
//}

#pragma mark - 我的消息模块

/**
 请求获取 "统计用户未读消息总数"
 */
- (void)requestMyMessageCountWithUserId:(NSString * _Nullable)userId
                                andSign:(NSString * _Nullable)sign
                               Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                 Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    
    // 参数安全判断
    if(!sign || !userId){
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    
    NSDictionary *parameter = @{
                                @"user_id" :userId,
                                @"sign" : sign,
                                };
    
    [self requestType:POST UrlString:@"/bxg/message/myMessageCount" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}



/**
 请求执行 "更新消息状态"
 */
- (void)requestUpdateMessageStatus:(NSString * _Nullable)userId
                           andSign:(NSString * _Nullable)sign
                           andType:(NSString * _Nullable)type
                          Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                            Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;{
    if(!sign || !userId){
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    
    NSDictionary *parameter;
    if(!type){
        
        parameter = @{
                      @"user_id" :userId,
                      @"sign" : sign,
                      };
    }else {
        
        
        parameter = @{
                      @"user_id" :userId,
                      @"sign" : sign,
                      @"type" : type,
                      };
    }
    
    [self requestType:POST UrlString:@"/bxg/message/updateMessageStatus" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}

- (void)appRequestUpdateMessageStatusType:(NSString * _Nullable)type
                                 Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"type"] = type;
    
    // url
    NSString *url = @"/bxg/message/updateMessageStatus";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/**
 请求执行 "清空课程消息"
 */
- (void)requestDeleteMessage:(NSString * _Nullable)userId
                     andSign:(NSString * _Nullable)sign
                     andType:(NSString * _Nullable)type
                    Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                      Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    
    if(!sign || !userId){
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    
    NSDictionary *parameter;
    if(!type){
        
        parameter = @{
                      @"user_id" :userId,
                      @"sign" : sign,
                      };
    }else {
        
        
        parameter = @{
                      @"user_id" :userId,
                      @"sign" : sign,
                      @"type" : type,
                      };
    }
    
    [self requestType:POST UrlString:@"/bxg/message/deleteMessage" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}

- (void)appRequestDeleteMessageType:(NSString * _Nullable)type
                           Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"type"] = type;
    
    
    // url
    NSString *url = @"/bxg/message/deleteMessage";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/**
 请求获取 "根据消息类型查询消息列表"
 */
- (void)requestMessageList:(NSString * _Nullable)userId
                   andSign:(NSString * _Nullable)sign
                   andType:(NSString * _Nullable)type
                  Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                    Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    
    if(!sign || !userId){
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    
    NSDictionary *parameter;
    if(!type){
        
        parameter = @{
                      @"user_id" :userId,
                      @"sign" : sign,
                      };
    }else {
        
        parameter = @{
                      @"user_id" :userId,
                      @"sign" : sign,
                      @"type" : type,
                      };
    }
    
    [self requestType:POST UrlString:@"/bxg/message/messageList" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}
- (void)appRequestMessageListType:(NSString * _Nullable)type
                         Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                         Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"type"] = type;
    
    
    // url
    NSString *url = @"/bxg/message/messageList";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

#pragma mark - 1.2.1

/**
 请求获取 "课程大纲-章节"
 */
- (void)requestCourseChapterList:(NSString * _Nullable)courseId
                       andUserId:(NSString * _Nullable)userId
                         andSign:(NSString * _Nullable)sign
                        Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                          Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    
    if(!sign || !courseId || !userId){
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    
    NSDictionary *parameter = @{
                                @"course_id" :courseId,
                                @"user_id" :userId,
                                @"sign" : sign,
                                };
    
    [self requestType:POST UrlString:@"bxg/course/getCourseChapter" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}

- (void)appRequestCourseChapterList:(NSString * _Nullable)courseId
                           Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"course_id"] = courseId;
    
    // url
    NSString *url = @"bxg/course/getCourseChapter";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/**
 请求获取 "课程大纲-点视频"
 */
- (void)requestCourseSectionAndVideoList:(NSString * _Nullable)courseId
                               andUserId:(NSString * _Nullable)userId
                            andSectionId:(NSString * _Nullable)sectionId
                                 andSign:(NSString * _Nullable)sign
                                Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                  Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;{
    
    if(!sign || !courseId || !userId || !sectionId){
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    
    NSDictionary *parameter = @{
                                @"course_id" :courseId,
                                @"user_id" :userId,
                                @"sign" : sign,
                                @"chapter_id" : sectionId,
                                };
    
    [self requestType:POST UrlString:@"bxg/course/getCoursePointAndVideo" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}

- (void)appRequestCourseSectionAndVideoList:(NSString * _Nullable)courseId
                               SectionId:(NSString * _Nullable)sectionId
                                Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"course_id"] = courseId;
    para[@"chapter_id"] = sectionId;
    
    
    // url
    NSString *url = @"bxg/course/getCoursePointAndVideo";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/**
 请求获取 "课程大纲-评论列表"
 */
- (void)requestStudentCriticizeListWithCourseId:(NSString * _Nullable)courseId
// andVideoId:(NSString * _Nullable)videoId
                                        andPage:(NSString * _Nullable)page
                                    andPageSize:(NSString * _Nullable)pageSize
                                        andSign:(NSString * _Nullable)sign
                                       Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                         Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    if(!courseId || !page || !pageSize){
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    
    NSDictionary *parameter = @{
                                @"course_id" :courseId,
                                @"page" :page,
                                @"pageSize" : pageSize,
                                //                                @"sign" : sign,
                                };
    
    [self requestType:POST UrlString:@"bxg/course/getStudentCriticize" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
}
- (void)appRequestStudentCriticizeListWithCourseId:(NSString * _Nullable)courseId
                                              Page:(NSString * _Nullable)page
                                          PageSize:(NSString * _Nullable)pageSize
                                          Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"course_id"] = courseId;
    para[@"page"] = page;
    para[@"pageSize"] = pageSize;
    
    // url
    NSString *url = @"bxg/course/getStudentCriticize";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/**
 请求获取 "课程大纲-评论列表"
 */

//bxg\video/saveCriticize
//

//签名






- (void)requestCommitStudentCriticizeWithUserId:(NSString * _Nullable)userId
                                       CourseId:(NSString * _Nullable)courseId
                                        PointId:(NSString * _Nullable)pointId
                                     andVideoId:(NSString * _Nullable)videoId
                                   andStarLevel:(NSNumber * _Nullable)starLevel
                                     andContent:(NSString * _Nullable)content
                                        andSign:(NSString * _Nullable)sign
                                       Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                         Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    if(!userId || !courseId || !videoId || !starLevel || !content || !sign || !pointId){
        RWNetworkLog(@"%@",@"参数错误");
        finishedBlock(nil);
        return;
    }
    
    NSDictionary *parameter = @{
                                @"user_id": userId,
                                @"course_id": courseId,
                                @"chapter_id": pointId,
                                @"video_id": videoId,
                                @"star_level": starLevel,
                                @"content": content,
                                @"sign": sign
                                };
    
    [self requestType:POST UrlString:@"bxg/video/saveCriticize" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@",responseObject);
        finishedBlock(responseObject);
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@",error);
        failedBlock(error);
    }];
    
}

- (void)appRequestCommitStudentCriticizeWithCourseId:(NSString * _Nullable)courseId
                                          andVideoId:(NSString * _Nullable)videoId
                                        andStarLevel:(NSNumber * _Nullable)starLevel
                                          andContent:(NSString * _Nullable)content
                                            Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    
}

- (void)requestCourseHistoryWithUserId:(NSString * _Nullable)userId
                           andCourseId:(NSString * _Nullable)courseId
                               andSign:(NSString * _Nullable)sign
                              Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    
    if(userId) {
        
        [parameter setValue:userId forKey:@"user_id"];
    }
    
    if(courseId) {
        
        [parameter setValue:courseId forKey:@"course_id"];
    }
    
    if(sign) {
        
        [parameter setValue:sign forKey:@"sign"];
    }
    
    [self requestType:POST UrlString:@"bxg/history/courseHistory" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

// 1.3.1
- (void)requestUpdateOfflineStudyStatusWithVideoData:(NSString * _Nullable)videoData
                                             andSign:(NSString * _Nullable)sign
                                           andUserId:(NSString * _Nullable)userId
                                         andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                              Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;{
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    if(videoData) {
        [parameter setValue:videoData forKey:@"videoData"];
    }
    
    if(sign) {
        
        [parameter setValue:sign forKey:@"sign"];
    }
    
    if(userId) {
        
        [parameter setValue:userId forKey:@"user_id"];
    }
    [self requestType:POST UrlString:@"bxg/video/updateOffOlineStudyStatus" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

-(void)requestCourseNotesWithUserId:(NSString* _Nullable)userId
                            andSign:(NSString* _Nullable)sign
                           Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                             Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    if(userId) {
        [parameter setValue:userId forKey:@"user_id"];
    }
    
    if(sign) {
        
        [parameter setValue:sign forKey:@"sign"];
    }
    
    [self requestType:POST UrlString:@"bxg/notes/getMyAllNotes" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

- (void)requestLastlearnHistoryWithSign:(NSString * _Nullable)sign
                              andUserId:(NSString * _Nullable)userId
                            andCourseId:(NSString * _Nullable)courseId // 可选
                            andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                 Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;{
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    if(courseId) {
        [parameter setValue:courseId forKey:@"course_id"];
    }
    
    if(sign) {
        
        [parameter setValue:sign forKey:@"sign"];
    }
    
    if(userId) {
        
        [parameter setValue:userId forKey:@"user_id"];
    }
    [self requestType:POST UrlString:@"bxg/history/getLastlearnHistory" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

-(void)requestCourseNoteDetailWithUserId:(NSString* _Nullable)userId
                                 andPage:(NSString* _Nullable)page
                             andPageSize:(NSString* _Nullable)pageSize
                             andCourseId:(NSString* _Nullable)courseId
                                 andType:(NSString* _Nullable)type
                                 andSign:(NSString* _Nullable)sign
                                Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                  Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    if(userId) {
        
        [parameter setValue:userId forKey:@"user_id"];
    }
    
    if(courseId) {
        
        [parameter setValue:courseId forKey:@"course_id"];
    }
    
    if(type) {
        
        [parameter setValue:type forKey:@"type"];
    }
    
    if(sign) {
        
        [parameter setValue:sign forKey:@"sign"];
    }
    if(page) {
        [parameter setValue:page forKey:@"page"];
    }
    if(pageSize) {
        [parameter setValue:pageSize forKey:@"pageSize"];
    }
    
    [self requestType:POST UrlString:@"bxg/notes/getMyNotes" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

-(void)requestUpdatePraiseNoteUserId:(NSString* _Nullable)userId
                         andUserName:(NSString* _Nullable)userName
                           andNoteId:(NSString* _Nullable)noteId
                             andSign:(NSString* _Nullable)sign
                            Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                              Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    if(userId) {
        
        [parameter setValue:userId forKey:@"user_id"];
    }
    if(userName) {
        [parameter setValue:userName forKey:@"user_name"];
    }
    if(noteId) {
        
        [parameter setValue:noteId forKey:@"note_id"];
    }
    
    if(sign) {
        
        [parameter setValue:sign forKey:@"sign"];
    }
    
    [self requestType:POST UrlString:@"bxg/notes/updatePraise" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

-(void)requestUpdateCollectNoteUserId:(NSString* _Nullable)userId
                          andUserName:(NSString* _Nullable)userName
                            andNoteId:(NSString* _Nullable)noteId
                              andSign:(NSString* _Nullable)sign
                             Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                               Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    if(userId) {
        
        [parameter setValue:userId forKey:@"user_id"];
    }
    if(userName) {
        [parameter setValue:userName forKey:@"user_name"];
    }
    if(noteId) {
        
        [parameter setValue:noteId forKey:@"note_id"];
    }
    
    if(sign) {
        
        [parameter setValue:sign forKey:@"sign"];
    }
    
    [self requestType:POST UrlString:@"bxg/notes/updateCollect" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

-(void)requestDeleteNoteUserId:(NSString* _Nullable)userId
                   andUserName:(NSString* _Nullable)userName
                     andNoteId:(NSString* _Nullable)noteId
                       andSign:(NSString* _Nullable)sign
                      Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                        Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock
{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    if(userId) {
        
        [parameter setValue:userId forKey:@"user_id"];
    }
    if(userName) {
        [parameter setValue:userName forKey:@"user_name"];
    }
    if(noteId) {
        
        [parameter setValue:noteId forKey:@"note_id"];
    }
    
    if(sign) {
        
        [parameter setValue:sign forKey:@"sign"];
    }
    
    [self requestType:POST UrlString:@"bxg/notes/deleteNote" Parameter:parameter Finished:^(id responseObject) {
        
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}



/// 分类：加载分类页所有学科 /bxg/courseCategory/getCategorySubject
- (void)requestCourseCategorySubjectWithFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                          Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    
    [self requestType:POST UrlString:@"/bxg/courseCategory/getCategorySubject" Parameter:nil Finished:^(id responseObject) {
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}
/// 分类：根据学科Id加载分类信息 /bxg/courseCategory/getCourseCategoryInfoBySubjectId
- (void)requestCourseCategoryInfoWithSubjectId:(NSString * _Nullable)subjectId andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                        Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock; {
    NSMutableDictionary *para = [NSMutableDictionary new];
    if(subjectId) {
        [para setObject:subjectId forKey:@"subjectId"];
    }
    [self requestType:POST UrlString:@"/bxg/courseCategory/getCourseCategoryInfoBySubjectId" Parameter:para Finished:^(id responseObject) {
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

/// 首页：获取课程列表（就业课、精品微课、免费微课）/bxg/index/getCourse
- (void)requestCourseListInfoFinish:(void (^ _Nullable)(id _Nullable responseObject))finishedBlock
                             Failed:(void (^ _Nullable)(NSError *_Nonnull error))failedBlock {
    [self requestType:POST UrlString:@"/bxg/index/getCourse" Parameter:nil Finished:^(id responseObject) {
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

/// 就业课：更多就业课 /bxg/index/getMoreCareerCourse
- (void)requestMoreCareerCourseFinish:(void (^ _Nullable)(id _Nullable responseObject))finishedBlock
                               Failed:(void (^ _Nullable)(NSError *_Nonnull error))failedBlock {
    [self requestType:POST UrlString:@"/bxg/index/getMoreCareerCourse" Parameter:nil Finished:^(id responseObject) {
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}
/// 课程信息：课程大纲 /bxg/course/getCourseOutline
- (void)requestCourseInfoOutlineWithCourseId:(NSString *_Nullable)courseId
                                 andFinished:(void (^ _Nullable)(id _Nullable responseObject))finishedBlock
                                      Failed:(void (^ _Nullable)(NSError *_Nonnull error))failedBlock; {
    NSMutableDictionary *para = [NSMutableDictionary new];
    if(courseId) {
        [para setObject:courseId forKey:@"course_id"];
    }
    [self requestType:POST UrlString:@"/bxg/course/getCourseOutline" Parameter:para Finished:^(id responseObject) {
        RWNetworkLog(@"%@", responseObject);
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        RWNetworkLog(@"%@", error);
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

/// 微课筛选页：获取所有微课的筛选条件 /bxg/index/getChoiceList
/// course_type    number    是    课程类型(1:微课 0：就业课)
/// is_free    number    是    是否免费(1:免费 0：精品)
- (void)requestFilterCourseInfoWithCourseType:(NSNumber *  _Nullable)courseType
                                 andMicroType:(NSNumber * _Nullable)microType
                                  andFinished:(void (^ _Nullable)(id _Nullable responseObject))finishedBlock
                                       Failed:(void (^ _Nullable)(NSError *_Nonnull error))failedBlock {
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"course_type"] = courseType;
    para[@"is_free"] = microType;
    [self requestType:POST UrlString:@"/bxg/index/getChoiceList" Parameter:para Finished:finishedBlock Progress:nil Failed:failedBlock];
}

/// 微课筛选页：根据筛选条件获取微课 /bxg/index/getMicroCourseByChoice
- (void)requestFilterCourseInfoWithDirectionId:(NSNumber * _Nullable)directionId
                                  andSubjectId:(NSNumber * _Nullable)subjectId
                                      andTagId:(NSNumber * _Nullable)tagId
                                  andOrderType:(NSNumber * _Nullable)orderType
                                andCourseLevel:(NSNumber * _Nullable)courseLevel
                                andContentType:(NSNumber * _Nullable)contentType
                                        isFree:(NSNumber * _Nullable)bFree
                                        pageNo:(NSNumber * _Nullable)pageNo
                                      pageSize:(NSNumber * _Nullable)pageSize
                                   andFinished:(void (^ _Nullable)(id _Nullable responseObject))finishedBlock
                                        Failed:(void (^ _Nullable)(NSError *_Nonnull error))failedBlock {
    if(!bFree) {
        finishedBlock(nil);
        return ;
    }
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    if(directionId) {
        [para setObject:directionId forKey:@"directionId"];
    }
    if(subjectId) {
        [para setObject:subjectId forKey:@"subjectId"];
    }
    if(tagId) {
        [para setObject:tagId forKey:@"tagId"];
    }
    if(orderType) {
        [para setObject:orderType forKey:@"orderType"];
    }
    if(courseLevel){
        [para setObject:courseLevel forKey:@"courseLevel"];
    }
    if(contentType) {
        [para setObject:contentType forKey:@"contentType"];
    }
    [para setObject:bFree forKey:@"isFree"];
    if(pageNo) {
        [para setObject:pageNo forKey:@"pageNo"];
    }
    if(pageSize) {
        [para setObject:pageSize forKey:@"pageSize"];
    }
    
    [self requestType:POST UrlString:@"/bxg/index/getMicroCourseByChoice" Parameter:para Finished:^(id responseObject) {
        if(finishedBlock){
            finishedBlock(responseObject);
        }
    } Progress:nil Failed:^(NSError * _Nonnull error) {
        if(failedBlock){
            failedBlock(error);
        }
    }];
}

/// 课程信息页：授课讲师 bxg/index/getCourseLecturer para: course_id
- (void)requestCourseCourseLecturerWithCourseId:(NSString *_Nullable)courseId
                                    andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded; {
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"course_id"] = courseId;
    [self requestType:POST UrlString:@"/bxg/course/getCourseLecturer" Parameter:(id)para Finished:finished Progress:nil Failed:failded];
}

///// 课程: 课程播放: 试学大纲 bxg/course/getCourseTryOutLine para: course_id
//- (void)requestCourseTryOutlineWithCourseId:(NSString * _Nullable)courseId
//                                andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded;
///提交订单: 订单确认
// /bxg/order/doConfirm/:user_id/:isInitial?sign=c72cc70554fb4af395e48ba64e3b5a58
//参数名    类型    必需    描述    示例 e.g.
//:userId    string    是    用户id    2c9081915d34625c015d348e6467000d
//:isInitial    number    是    初次调用isInitial=0；非初次调用：isInitial=1    0
//ids    array    是    订单的课程id数组    443
//courseCoupon    string    是    课程id-优惠券id映射    {200: 0, 384: 0, 443: 0, 536: 0}
- (void)requestOrderSubmitOutlineWithUserId:(NSString *_Nullable)userId
                               andIsInitial:(NSNumber *_Nullable)isInitial
                                    andSign:(NSString *_Nullable)sign
                          andOrderCourseIds:(NSString* _Nullable)orderCourseIds
                          andCourseCouponId:(NSString* _Nullable)courseCouponId
                                andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded {
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"isInitial"] = isInitial;
    para[@"ids"] = orderCourseIds;
    para[@"courseCoupon"] = courseCouponId;
    
    NSString *strUrl = [NSString stringWithFormat:@"/bxg/order/doConfirm/%@/%@?sign=%@", userId, isInitial.stringValue, sign];
    [self requestType:POST UrlString:strUrl Parameter:para Finished:finished Progress:nil Failed:failded];
}


/**
 提交订单：课程选择优惠券接口 /bxg/coupon/getCouponsByUserIdAndCouponIds
 
 @param userId string    是    用户id    2c9081915d34625c015d348e6467000d
 @param courseId number    是    使用优惠券的课程id    536
 @param couponIds array    是    优惠券id集合(array)    1022570
 @param useStatus number    是    该用户优惠券相对于此课程可使用状态，=1 可使用，=0 不可使用   1
 */
- (void)requstOrderSubmitCouponWithUserId:(NSString *_Nullable)userId
                              andCourseId:(NSString *_Nullable)courseId
                             andCouponIds:(NSString *_Nullable)couponIds
                             andUseStatus:(NSNumber *_Nullable)useStatus
                            andPageNumber:(NSNumber *_Nullable)pageNumber
                              andPageSize:(NSNumber *_Nullable)pageSize
                                  andSign:(NSString *_Nullable)sign
                              andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded; {
    if(!couponIds || couponIds.length <= 0){
        couponIds = @"-1"; // 空值后台需要传 -1
    }
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"user_id"] = userId;
    para[@"courseId"] = courseId;
    para[@"couponIds"] = couponIds;
    para[@"useStatus"] = useStatus;
    para[@"sign"] = sign;
    [self requestType:POST UrlString:@"/bxg/coupon/getCouponsByUserIdAndCouponIds" Parameter:para Finished:finished Progress:nil Failed:failded];
}


///我的优惠券列表
// /bxg/coupon/getMyCoupons
//参数名    类型    必需    描述    示例 e.g.
//user_id    string    是    用户id
//status    number    是    优惠券状态(可使用:0已使用:1已过期:2)
//pageNumber    number    是    当前页数
//pageSize    number    是    每页数

- (void)requestMyCouponsWithUserId:(NSString *_Nullable)userId
                         andStatus:(NSNumber *_Nullable)status
                     andPageNumber:(NSNumber *_Nullable)pageNumber
                       andPageSize:(NSNumber *_Nullable)pageSize
                           andSign:(NSString *_Nullable)sign
                       andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded {
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"user_id"] = userId;
    para[@"status"] = status;
    para[@"pageNumber"] = pageNumber;
    para[@"pageSize"] = pageSize;
    para[@"sign"] = sign;
    [self requestType:POST UrlString:@"/bxg/coupon/getMyCoupons" Parameter:para Finished:finished Progress:nil Failed:failded];
}

///我的订单：根据订单状态获取订单列表
// /bxg/order/getMyOrder
//参数名    类型    必需    描述    示例 e.g.
//userId    string    是    用户id    2c9081915d34625c015d348e6467000d
//orderStatus    number    是    订单支付状态 0:未支付 1:已支付 2:已关闭    0
//pageNumber    number    是    页数    1
//pageSize    number    是    每页数    20
- (void)requestMyOrdersWithUserId:(NSString *_Nullable)userId
                   andOrderStatus:(NSNumber *_Nullable)orderStatus
                    andPageNumber:(NSNumber *_Nullable)pageNumber
                      andPageSize:(NSNumber *_Nullable)pageSize
                      andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded {
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"user_id"] = userId;
    para[@"orderStatus"] = orderStatus;
    para[@"pageNumber"] = pageNumber;
    para[@"pageSize"] = pageSize;
    [self requestType:POST UrlString:@"/bxg/order/getMyOrder" Parameter:para Finished:finished Progress:nil Failed:failded];
}

///我的优惠券：根据优惠券id获取优惠券可优惠课程
// /bxg/coupon/getCouponCourses
//参数名    类型    必需    描述    示例 e.g.
//couponId    number    是    优惠券id
//pageNumber    number    是    当前页数
//pageSize    number    是    每页数
- (void)requestCouponCoursesWithCouponId:(NSString *_Nullable)couponId
                           andPageNumber:(NSNumber *_Nullable)pageNumber
                             andPageSize:(NSNumber *_Nullable)pageSize
                             andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded {
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"couponId"] = couponId;
    para[@"pageNumber"] = pageNumber;
    para[@"pageSize"] = pageSize;
    [self requestType:POST UrlString:@"/bxg/coupon/getCouponCourses" Parameter:para Finished:finished Progress:nil Failed:failded];
}

///我的优惠券：绑定优惠券
// /bxg/coupon/bindCouponToUser
//参数名    类型    必需    描述    示例 e.g.
//userId    string    是    用户id
//serialNo    string    是    优惠券码    LmLdzjs5Q4F2
//失败success为false，errorMessage返回具体报错信息。
//{
//    "success": true,
//    "errorMessage": null,
//    "resultObject": "优惠码兑换成功！"
//}
- (void)requestBindCouponWithSerialNo:(NSString *_Nullable)serialNo
                          andCourseId:(NSString *_Nullable)courseId
                          andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded;{
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"serialNo"] = serialNo;
    para[@"course_id"] = courseId;
    [self requestType:POST UrlString:@"/bxg/coupon/bindCouponToUser" Parameter:para Finished:finished Progress:nil Failed:failded];
}
/// 课程播放: 试学大纲
- (void)requestCourseTryOutlineWithCourseId:(NSString * _Nullable)courseId
                                andFinished:BXGNetworkFinishedBlockType finished
andFailed:BXGNetworkFailedBlockType failded {
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"course_id"] = courseId;
    [self requestType:POST UrlString:@"/bxg/course/getCourseTryOutLine" Parameter:para Finished:finished Progress:nil Failed:failded];
}
/// 课程: 是否已购买课程 bxg/course/isApply para: course_id,user_id
- (void)requestCourseIsApplyWithCourseId:(NSString * _Nullable)courseId
                               andUserId:(NSString * _Nullable)userId
                             andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded; {
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"course_id"] = courseId;
    para[@"user_id"] = userId;
    [self requestType:POST UrlString:@"/bxg/course/isApply" Parameter:para Finished:finished Progress:nil Failed:failded];
}

- (void)requestOrderDetailWithOrderId:(NSString *_Nullable)orderId
                          andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded {
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"orderId"] = orderId;
    [self requestType:POST UrlString:@"/bxg/order/orderDetail" Parameter:para Finished:finished Progress:nil Failed:failded];
}

- (void)requestCancelOrderWithOrderNo:(NSString *_Nullable)orderId
                              andType:(NSString *_Nullable)type
                          andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded {
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"orderNo"] = orderId;
    para[@"type"] = type;
    [self requestType:POST UrlString:@"/bxg/order/updateOrderStatus" Parameter:para Finished:finished Progress:nil Failed:failded];
}

/// 课程详情页：报名之前检测课程下是否有视频的接口 /bxg/video/existVideosByCourseId
- (void)requestExistVideosByCourseIdWithCourseId:(NSString * _Nullable)courseId
                                     andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failded ; {
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"courseId"] = courseId;
    [self requestType:POST UrlString:@"/bxg/video/existVideosByCourseId" Parameter:para Finished:finished Progress:nil Failed:failded];
}


/**
 支付：保存订单（接口调用详见文档-详细说明）（非免费课程逻辑未完成）/bxg/order/saveOrder
 
 @param orderJson
 {"courseCoupon":{"384":0,"443":0,"536":0},"totalAmount":"1493.00","orderFrom":4,"payType":0}
 */
- (void)requestOrderSaveOrderWithOrderStr:(id _Nullable)orderJson andFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failed; {
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"orderStr"] = orderJson;
    [self requestType:POST UrlString:@"/bxg/order/saveOrder" Parameter:para Finished:finished Progress:nil Failed:failed];
}

/**
 用户：获取当前用户咨询报名信息 /bxg/onlineUser/getApplyInfo
 */
- (void)requestGetApplyInfoWithFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failed; {
    [self requestType:POST UrlString:@"/bxg/onlineUser/getApplyInfo" Parameter:nil Finished:finished Progress:nil Failed:failed];
}

/// 课程详情页: 课程详情信息 /bxg/course/getCourseByCourseId
- (void)requestCourseDetailWithCourseId:(NSString * _Nullable)courseId Finished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failed; {
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"course_id"] = courseId;
    [self requestType:POST UrlString:@"/bxg/course/getCourseByCourseId" Parameter:para Finished:finished Progress:nil Failed:failed];
}

- (void)requestOrderSearchWithOrderNo:(NSString * _Nullable)orderNo
                              andType:(NSString * _Nullable)type
                          andFinished:BXGNetworkFinishedBlockType finished
andFailed:BXGNetworkFailedBlockType failed {
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"order_no"] = orderNo;
    para[@"payType"] = type;
    para[@"payTerminal"] = @(2); // 支付终端，0官网，1微信，2App，3移动web
    [self requestType:POST UrlString:@"/bxg/order/queryOrder"
            Parameter:para
             Finished:finished
             Progress:nil
               Failed:failed];
    
}
///
- (void)requestOrderToPayWithOrderId:(NSString * _Nullable)orderId
                          andOrderNo:(NSString * _Nullable)orderNo
                             andType:(NSString* _Nullable)type
                         andFinished:BXGNetworkFinishedBlockType finished
andFailed:BXGNetworkFailedBlockType failed {
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"orderId"] = orderId;
    para[@"orderNo"] = orderNo;
    para[@"payType"] = type;
    para[@"payTerminal"] = @(2); // 支付终端，0官网，1微信，2App，3移动web
    [self requestType:POST UrlString:@"/bxg/order/topay"
            Parameter:para
             Finished:finished
             Progress:nil
               Failed:failed];
}



#pragma mark - 消息中心
/*
 消息中心 info
 
 // 统计用户未读消息总数 /bxg/message/myMessageCount 周期调用一次
 // 更新消息状态 /bxg/message/updateMessageStatus 打开详情调用
 // 根据消息类型查询消息列表 bxg/message/messageList 打开详情页 需要加分页
 // 清空课程消息 bxg/message/deleteMessage 功能未实现
 // 根据课程类型查找未读消息的总数+最后创建的消息 /bxg/message/getLastMessageByType 二级页面
 */

- (void)appRequestMyMessageCountWithFinished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    
    // url
    NSString *url = @"/bxg/message/myMessageCount";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}
- (void)appRequestUpdateMessageStatusByType:(NSString * _Nullable)type
                                   Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"type"] = type;
    
    // url
    NSString *url = @"/bxg/message/updateMessageStatus";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}
- (void)appRequestDeleteMessageByType:(NSString * _Nullable)type
                             Finished:(BXGNetworkCallbackBlockType _Nullable) finished;{
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"type"] = type;
    
    // url
    NSString *url = @"/bxg/message/deleteMessage";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}
- (void)appRequestMessageListByType:(NSString * _Nullable)type
                         PageNumber:(NSString *_Nullable)pageNumber
                           PageSize:(NSString *_Nullable)pageSize
                           Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"type"] = type;
    para[@"page"] = pageNumber;
    para[@"pageSize"] = pageSize;
    
    // url
    NSString *url = @"/bxg/message/messageList";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}
- (void)appRequestGetLastMessageByType:(NSString * _Nullable)type
                              Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"type"] = type;
    
    // url
    NSString *url = @"/bxg/message/getLastMessageByType";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

- (void)appRequestSearchCourseListByKeyword:(NSString *_Nullable)keyword
                                 PageNumber:(NSString *_Nullable)pageNumber
                                   PageSize:(NSString *_Nullable)pageSize
                                   Finished:(BXGNetworkCallbackBlockType _Nullable) finished {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"keyword"] = keyword;
    para[@"page"] = pageNumber;
    para[@"pageSize"] = pageSize;
    
    // url
    NSString *url = @"/bxg/search/courseSearch";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

- (void)appRequestSearchHotKeywordWithFinished:(BXGNetworkCallbackBlockType _Nullable) finished {
    // para
    
    // url
    NSString *url = @"/bxg/search/searchHotWord";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:nil andFinished:finished];
}

#pragma mark - 个人设置

- (void)appRequestUserBaseSettingInfoWithFinished:(BXGNetworkCallbackBlockType _Nullable)finished {
    // para
    
    // url
    NSString *url = @"/bxg/onlineUser/getBaseUserInfo";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:nil andFinished:finished];
}

- (void)appRequestUserThirdBindInfoWithFinished:(BXGNetworkCallbackBlockType _Nullable)finished {
    // para
    
    // url
    NSString *url = @"/bxg/onlineUser/getCurrAccountInfo";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:nil andFinished:finished];
}

#pragma mark - 直播

/// 直播: 月计划显示列表
- (void)appRequestConstruePlanByMonthWithMenuId:(NSString * _Nullable)menuId
                                       Finished:(BXGNetworkCallbackBlockType _Nullable)finished {
    
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"menuId"] = menuId;
    
    // url
    NSString *url = @"/bxg/appConstruePlan/getConstruePlanByMonth";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/// 直播: 日计划显示列表
- (void)appRequestConstruePlanByDayWithMenuId:(NSString * _Nullable)menuId
                                          Day:(NSString * _Nullable)day
                                     Finished:(BXGNetworkCallbackBlockType _Nullable)finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"menuId"] = menuId;
    para[@"day"] = day;
    
    // url
    NSString *url = @"/bxg/appConstruePlan/getConstruePlanByDay";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/// 直播: 课程简介 /bxg/appConstruePlan/getConstruePlanById
- (void)appRequestConstrueIntroduceWithPlanId:(NSString * _Nullable)planId
                                     Finished:(BXGNetworkCallbackBlockType _Nullable)finished {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"planId"] = planId;
    
    // url
    NSString *url = @"/bxg/appConstruePlan/getConstruePlanById";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

/// 直播: 回放列表 /bxg/appConstruePlan/getCallBackPlanById
- (void)appRequestConstrueReplayListWithPlanId:(NSString * _Nullable)planId
                                      Finished:(BXGNetworkCallbackBlockType _Nullable)finished {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"planId"] = planId;
    
    // url
    NSString *url = @"/bxg/appConstruePlan/getCallBackPlanById";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
    
}

/// 直播: 获取直播状态 /bxg/appConstruePlan/checkPlanStatusById
- (void)appRequestConstrueCheckStatusWithPlanId:(NSString * _Nullable)planId
                                       Finished:(BXGNetworkCallbackBlockType _Nullable)finished {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"planId"] = planId;
    
    // url
    NSString *url = @"/bxg/appConstruePlan/checkPlanStatusById";
    
    // request
    [self appBaseRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

@end
