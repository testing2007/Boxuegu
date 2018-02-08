//
//  BXGNetWorkTool+User.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGNetWorkTool+User.h"

@implementation BXGNetWorkTool (User)

#pragma mark - Base

- (void)userRequestType:(RequestType)type andURLString:(NSString * _Nullable)urlString andParameter:(id _Nullable)para andFinished:(BXGNetworkCallbackBlockType _Nullable) callback; {
    // common para
    [self requestType:type andBaseURLString:kUserBaseURL andUrlString:urlString andParameter:para andFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser userNetworkParser:responseObject andFinished:callback];
    } andFailed:^(NSError * _Nonnull error) {
        [BXGNetworkParser userNetworkParser:error andFinished:callback];
    }];
}

#pragma mark - Request
// http://online-test.boxuegu.com/bxg/user/thirdLoginApp 三方登录
- (void)userRequestThirdLoginAppWithThirdType:(NSString * _Nullable)thirdType
                                  AccessToken:(NSString * _Nullable)accessToken
                                       ThirdID:(NSString * _Nullable)thirdId
                                     Finished:(BXGNetworkCallbackBlockType _Nullable) finished {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"thirdType"] = thirdType;
    para[@"access_token"] = accessToken;
    para[@"thirdId"] = thirdId;
    
    // url
    NSString *url = @"/bxg/user/thirdLoginApp";
    
    // request
    [self userRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

// http://online-test.boxuegu.com/bxg/user/bindExistAccount 绑定已有账号
- (void)userRequestBindExistAccountWithThirdType:(NSString * _Nullable)thirdType
                                     AccessToken:(NSString * _Nullable)accessToken
                                          ThirdID:(NSString * _Nullable)thirdId
                                        UserName:(NSString * _Nullable)username
                                        Password:(NSString * _Nullable)password
                                        Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"thirdType"] = thirdType;
    para[@"access_token"] = accessToken;
    para[@"thirdId"] = thirdId;

    para[@"username"] = username;
    para[@"password"] = password;

    // url
    NSString *url = @"/bxg/user/bindExistAccount";
    
    // request
    [self userRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

// http://online-test.boxuegu.com/bxg/user/bindNewAccount 绑定新账号
- (void)userRequestBindNewAccountWithThirdType:(NSString * _Nullable)thirdType
                                       AccessToken:(NSString * _Nullable)accessToken
                                            ThirdID:(NSString * _Nullable)thirdId
                                        Mobile:(NSString * _Nullable)mobile
                                      Password:(NSString * _Nullable)password
                                          Code:(NSString * _Nullable)code
                                      Finished:(BXGNetworkCallbackBlockType _Nullable) finished; {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"thirdType"] = thirdType; // 5: QQ 6:微信 7.微博
    para[@"access_token"] = accessToken;
    para[@"thirdId"] = thirdId; // QQ: appId 微信:openId 微博uid
    
    para[@"type"] = @"1"; //1:注册 2：忘记密码
    para[@"mobile"] = mobile;
    para[@"password"] = password;
    para[@"code"] = code; // 验证码

    // url
    NSString *url = @"/bxg/user/bindNewAccount";
    
    // request
    [self userRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

#pragma mark - 个人设置
///修改头像 /bxg/user/updateHeadPhoto
- (void)userRequestUpdateHeadPhotoByImageData:(NSData* _Nonnull)imageData
                                 andFileType:(NSString* _Nonnull)fileType
                                    Finished:(BXGNetworkCallbackBlockType _Nullable) finished {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"fileType"] = fileType;
    para[@"user_id"] = [BXGUserCenter share].userModel.user_id;
    para[@"sign"] = [BXGUserCenter share].userModel.sign;

    //request
    NSString *url = [kUserBaseURL stringByAppendingPathComponent:@"/bxg/user/updateHeadPhoto"];
    [self POST:url parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd-HH:mm:ss";
        NSString *fileName = [NSString stringWithFormat:@"%@2.png",[formatter stringFromDate:[NSDate date]]];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [BXGNetworkParser userNetworkParser:responseObject andFinished:finished];
        RWLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [BXGNetworkParser userNetworkParser:error andFinished:finished];
    }];
}

- (void)userRequestCheckNickname:(NSString* _Nonnull)nickName
                        Finished:(BXGNetworkCallbackBlockType _Nullable) finished {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"nickName"] = nickName;
    
    //url
    NSString *url = @"/bxg/user/checkNickName";
    
    //request
    [self userRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

- (void)userRequestUpdateUserNickname:(NSString* _Nullable)nickname //昵称
                         andAutograph:(NSString* _Nullable)autograph //签名
                             andSexId:(NSString* _Nullable)sexId //性别 [0女1男2未知]
                        andProvinceId:(NSString* _Nullable)provinceId //省id
                            andCityId:(NSString* _Nullable)cityId //市id
                     andStudyTargetId:(NSString* _Nullable)targetId //学习目标id
                             Finished:(BXGNetworkCallbackBlockType _Nullable)finished {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"nickName"] = nickname;
    para[@"autograph"] = autograph;
    para[@"sex"] = sexId;
    para[@"province"] = provinceId;
    para[@"city"] = cityId;
    para[@"target"] = targetId;
    
    //url
    NSString *url = @"/bxg/user/updateUser";
    
    //request
    [self userRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

- (void)userRequestGetAllProvinceAndCityFinished:(BXGNetworkCallbackBlockType _Nullable)finished {
    // para
    
    //url
    NSString *url = @"/bxg/user/getAllProvinceAndCity";
    
    //request
    [self userRequestType:POST andURLString:url andParameter:nil andFinished:finished];
}

- (void)userRequestBindThirdAccountByThirdAccessToken:(NSString* _Nonnull)thirdAccessToken //调用三方登录返回的凭证
                                         andThirdType:(NSString* _Nonnull)thirdType //5：qq，6：微信，7：微博
                                           andThirdId:(NSString* _Nonnull)thirdId   //（微信需返回openId，微博的uid，qq的appID
                                             Finished:(BXGNetworkCallbackBlockType _Nullable)finished {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"access_token"] = thirdAccessToken;
    para[@"thirdType"] = thirdType;
    para[@"thirdId"] = thirdId;
    
    //url
    NSString *url = @"/bxg/user/thirdLoginForExitUser";
    
    //request
    [self userRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

- (void)userRequestUnbindThirdAccountByUserLoginAccount:(NSString * _Nullable)userLoginAccount
                                               Finished:(BXGNetworkCallbackBlockType _Nullable)finished {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"account"] = userLoginAccount;
    
    //url
    NSString *url = @"/bxg/user/removeBind";
    
    //request
    [self userRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

- (void)userRequestBindUserNameByUserName:(NSString* _Nonnull)userName
                             andLoginType:(NSString* _Nonnull)loginType //绑定类型，目前只有手机，传2即可（1：用户名，2：手机号，3：邮箱）
                                  andCode:(NSString* _Nonnull)code //手机验证码（绑定手机时必填，此处目前只有手机，所以设置必填，未来有扩展的话就是非必填）
//                            andBindStatus:(NSString* _Nullable)bindStatus //1.更换(更换绑定账号时必填，绑定账号操作不用传)
                                 Finished:(BXGNetworkCallbackBlockType _Nullable)finished {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"username"] = userName;
    para[@"loginType"] = loginType;
    para[@"code"] = code;
//    para[@"bindStatus"] = bindStatus;
    
    //url
    NSString *url = @"/bxg/user/bindOtherCount";
    
    //request
    [self userRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

- (void)userRequestCheckIdentityValidByUserName:(NSString* _Nonnull)userName
                                        andCode:(NSString* _Nonnull)code
                                       Finished:(BXGNetworkCallbackBlockType _Nullable)finished {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"username"] = userName;
    para[@"code"] = code;
    
    //url
    NSString *url = @"/bxg/user/identityValid";
    
    //request
    [self userRequestType:POST andURLString:url andParameter:para andFinished:finished];
}

- (void)userRequestRestPWDByUserName:(NSString* _Nonnull)userName
                         andPassword:(NSString* _Nonnull)password
                       andVerifyCode:(NSString* _Nonnull)verifyCode
                            Finished:(BXGNetworkCallbackBlockType _Nullable)finished {
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"password"] = password;
    para[@"code"] = verifyCode;
    para[@"username"] = userName;

    //url
    NSString *url = @"/bxg/user/resetPWD";
    
    //request
    [self userRequestType:POST andURLString:url andParameter:para andFinished:finished];
}


@end
