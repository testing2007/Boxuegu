//
//  BXGUserCenter.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGUserModel.h"
#import "BXGSocialManager.h"

typedef NS_ENUM(NSInteger, BannerType)
{
    BannerType_Unknow = 0,     //网络访问失败等
    BannerType_Prohibit_Speak, //禁言
    BannerType_Black_Name_List,//拉入黑名单
    BannerType_None,           //没有被禁言或拉入黑名单
};

typedef enum : NSUInteger {
    BXGUserCenterSocialTypeQQ,
    BXGUserCenterSocialTypeSina,
    BXGUserCenterSocialTypeWechat,
} BXGUserCenterSocialType;


@interface BXGUserCenter : NSObject
+ (_Nonnull instancetype)share;
@property (nonatomic, strong) BXGUserModel * _Nullable userModel;

//用户是否被禁言了
@property (nonatomic, assign) BannerType bannerType;

- (void)signInWithUserName:(NSString * _Nullable)userName passWord:(NSString * _Nullable)passWord Finished:(void(^ _Nullable)(BXGUserModel * _Nullable userModel ,NSString * _Nullable msg))finished;
- (void)signOut;
- (void)saveLastUserID:(NSString * _Nullable)userId;
@property (nonatomic, assign) BXGSocialPlatformType lastSocialType;
// UI
- (BOOL)checkSignInWithViewController:(UIViewController * _Nullable)viewContrller;

- (void)loginWithSocialModel:(BXGSocialModel * _Nullable)socialModel
                   Finished:(void(^ _Nullable)(NSInteger status,BXGSocialModel * _Nullable socialModel,NSString * _Nullable message))finished;

- (void)bindExistAccountWithSocialModel:(BXGSocialModel * _Nullable)socialModel
                              UserName:(NSString * _Nullable)username
                              Password:(NSString * _Nullable)password
                              Finished:(void(^ _Nullable)(BOOL succeed, NSString * _Nullable message))finished;

- (void)bindNewAccountWithSocialModel:(BXGSocialModel * _Nullable)socialModel
                              Mobile:(NSString * _Nullable)mobile
                            Password:(NSString * _Nullable)password
                                Code:(NSString * _Nullable)code
                            Finished:(void(^ _Nullable)(BOOL succeed, NSString * _Nullable message))finished;

- (void)bindUserRequestBindUserNameByUserName:(NSString* _Nonnull)userName
                                 andLoginType:(NSString* _Nonnull)loginType //绑定类型，目前只有手机，传2即可（1：用户名，2：手机号，3：邮箱）
                                      andCode:(NSString* _Nonnull)code //手机验证码（绑定手机时必填，此处目前只有手机，所以设置必填，未来有扩展的话就是非必填）
//                                andBindStatus:(NSString* _Nullable)bindStatus //1.更换(更换绑定账号时必填，绑定账号操作不用传)
                               andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage))finishBlock;

@end
