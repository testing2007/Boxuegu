//
//  BXGNetWorkTool+User.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGNetWorkTool.h"

@interface BXGNetWorkTool (User)
- (void)userRequestThirdLoginAppWithThirdType:(NSString * _Nullable)thirdType
                                  AccessToken:(NSString * _Nullable)accessToken
                                       ThirdID:(NSString * _Nullable)thirdId
                                   Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

// /bxg/user/bindExistAccount 绑定已有账号
- (void)userRequestBindExistAccountWithThirdType:(NSString * _Nullable)thirdType
                                     AccessToken:(NSString * _Nullable)accessToken
                                          ThirdID:(NSString * _Nullable)thirdId
                                          UserName:(NSString * _Nullable)username
                                       Password:(NSString * _Nullable)password
                                      Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

// /bxg/user/bindNewAccount 绑定新账号
- (void)userRequestBindNewAccountWithThirdType:(NSString * _Nullable)thirdType
                                        AccessToken:(NSString * _Nullable)accessToken
                                        ThirdID:(NSString * _Nullable)thirdId
                                      Mobile:(NSString * _Nullable)mobile
                                    Password:(NSString * _Nullable)password
                                        Code:(NSString * _Nullable)code
                                    Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

#pragma mark - 个人设置
///修改头像 /bxg/user/updateHeadPhoto
- (void)userRequestUpdateHeadPhotoByImageData:(NSData* _Nonnull)imageData
                                  andFileType:(NSString* _Nonnull)fileType //"1图片，2附件"
                                    Finished:(BXGNetworkCallbackBlockType _Nullable)finished;

///检查昵称是否重复 /bxg/user/checkNickName
- (void)userRequestCheckNickname:(NSString* _Nonnull)nickName
                        Finished:(BXGNetworkCallbackBlockType _Nullable) finished;

///修改昵称，性别，地区，签名，学习方向 /bxg/user/updateUser
- (void)userRequestUpdateUserNickname:(NSString* _Nullable)nickname //昵称
                         andAutograph:(NSString* _Nullable)autograph //签名
                             andSexId:(NSString* _Nullable)sexId //性别 [0女1男2未知]
                        andProvinceId:(NSString* _Nullable)provinceId //省id
                            andCityId:(NSString* _Nullable)cityId //市id
                     andStudyTargetId:(NSString* _Nullable)targetId //学习目标id
                             Finished:(BXGNetworkCallbackBlockType _Nullable)finished;

///省市列表 /bxg/user/getAllProvinceAndCity
- (void)userRequestGetAllProvinceAndCityFinished:(BXGNetworkCallbackBlockType _Nullable)finished;

///绑定三方账号 /bxg/user/thirdLoginForExitUser
- (void)userRequestBindThirdAccountByThirdAccessToken:(NSString* _Nonnull)thirdaccessToken //调用三方登录返回的凭证
                                         andThirdType:(NSString* _Nonnull)thirdType //5：qq，6：微信，7：微博
                                           andThirdId:(NSString* _Nonnull)thirdId   //（微信需返回openId，微博的uid，qq的appID
                                             Finished:(BXGNetworkCallbackBlockType _Nullable)finished;
///解除第三方绑定 /bxg/user/removeBind
- (void)userRequestUnbindThirdAccountByUserLoginAccount:(NSString * _Nullable)userLoginAccount
                                               Finished:(BXGNetworkCallbackBlockType _Nullable)finished;

///绑定用户名 /bxg/user/bindOtherCount
- (void)userRequestBindUserNameByUserName:(NSString* _Nonnull)userName
                             andLoginType:(NSString* _Nonnull)loginType //绑定类型，目前只有手机，传2即可（1：用户名，2：手机号，3：邮箱）
                                  andCode:(NSString* _Nonnull)code //手机验证码（绑定手机时必填，此处目前只有手机，所以设置必填，未来有扩展的话就是非必填）
//                            andBindStatus:(NSString* _Nullable)bindStatus //1.更换(更换绑定账号时必填，绑定账号操作不用传)
                                 Finished:(BXGNetworkCallbackBlockType _Nullable)finished;


///更换手机号时验证验证身份接口 /bxg/user/identityValid
- (void)userRequestCheckIdentityValidByUserName:(NSString* _Nonnull)userName
                                        andCode:(NSString* _Nonnull)code
                                       Finished:(BXGNetworkCallbackBlockType _Nullable)finished;

///修改密码 /bxg/user/resetPWD
- (void)userRequestRestPWDByUserName:(NSString* _Nonnull)userName
                         andPassword:(NSString* _Nonnull)password
                       andVerifyCode:(NSString* _Nonnull)verifyCode
                            Finished:(BXGNetworkCallbackBlockType _Nullable)finished;

@end
