//
//  BXGUserCenter.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGUserCenter.h"
#import "BXGUserLoginVC.h"

static BXGUserCenter *instance;
@implementation BXGUserCenter

#pragma mark - Init
+ (instancetype)share; {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [BXGUserCenter new];
    });
    return instance;
}

#pragma mark - Getter Setter
- (BXGUserModel *)userModel {

    return [BXGUserDefaults share].userModel;
}

- (void)setUserModel:(BXGUserModel *)userModel {

    [BXGUserDefaults share].userModel = userModel;
}

#pragma - Action
- (void)signOut {

    BXGUserModel *model = self.userModel;
    
    // 1. -----网络处理------

    // 网络处理 - 请求退出登录
    [[BXGNetWorkTool sharedTool] requestLogoutWithUserID:model.user_id andSign:model.sign andFinished:^(id  _Nullable responseObject) {
        
        RWLog(@"用户退出成功");
    } Failed:^(NSError * _Nullable error) {
        
        RWLog(@"用户退出失败");
    }];
    
    // 2. -----本地处理------
    
    self.userModel = nil;
    
    // 3. -----通知处理------
    
    [BXGNotificationTool postNotificationForUserLogin:false];
}
- (void)saveLastUserID:(NSString *)userId {
    
    BXGUserDefaults *userInfo = [BXGUserDefaults share];
    userInfo.lastUserID = userId;
}
- (void)signInWithUserName:(NSString *)userName passWord:(NSString *)passWord Finished:(void(^)(BXGUserModel *userModel,NSString *msg))finishedBlock {
    Weak(weakSelf);
    // 清除上次用户信息
    if(self.userModel){
       self.userModel = nil;
    }
    
    if(!finishedBlock) {
        finishedBlock = ^(BXGUserModel *userModel,NSString *msg){};
    }
    
    [[BXGNetWorkTool sharedTool] appRequestLoginUserName:userName Password:passWord Finished:^(NSInteger status, NSString * _Nullable errorMsg, id  _Nullable result) {
        
        BXGUserModel *model;
        if(status == 200) {
            model = [BXGUserModel yy_modelWithDictionary:result];
        }
        if(!errorMsg) {
            errorMsg = kBXGToastLodingError;
        }
        if(model){
            [weakSelf login:model UserName:userName Social:BXGSocialPlatformTypeNone];
            finishedBlock(model,@"登录成功");
        }else {
            // 失败回调
            finishedBlock(nil,errorMsg);
        }
    }];
}

- (void)login:(BXGUserModel *)userModel UserName:(NSString *)userName Social:(BXGSocialPlatformType)socialType {
    if(userModel){
        // 保存用户模型
        [BXGUserDefaults share].userModel = userModel;
        // 发送登录成功通知
        [BXGNotificationTool postNotificationForUserLogin:true];
        // 保存为上次登录userName
        if(socialType == BXGSocialPlatformTypeNone) {
            self.lastSocialType = BXGSocialPlatformTypeNone;
            if(userName.length > 0) {
                [self saveLastUserID:userName];
            }else {
                [self saveLastUserID:nil];
            }
        }else {
            [self saveLastUserID:nil];
            self.lastSocialType = socialType;
        }
    }
}

- (void)updateUserModel:(BXGUserModel *)userModel {
    
    [BXGUserDefaults share].userModel = userModel;
}

- (BOOL)checkSignInWithViewController:(UIViewController *)viewContrller; {
    if(self.userModel){
        return true;
    }else {
        UIViewController * toViewController = [[BXGBaseNaviController alloc]initWithRootViewController:[BXGUserLoginVC new]];
        [viewContrller presentViewController:toViewController animated:true completion:nil];
    }
    return false;
}

- (void)loginWithSocialModel:(BXGSocialModel *)socialModel
                    Finished:(void(^ _Nullable)(NSInteger status,BXGSocialModel * _Nullable socialModel,NSString * _Nullable message))finished {
    
    Weak(weakSelf);
    
    NSString * thirdType = [self getThirdType:socialModel.type];
    NSString * thirdId = socialModel.thirdId;
    NSString * accessToken = socialModel.accessToken;
    
    [[BXGNetWorkTool sharedTool] userRequestThirdLoginAppWithThirdType:thirdType AccessToken:accessToken ThirdID:thirdId Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if([result isKindOfClass:[NSDictionary class]]) {
            BXGUserModel *userModel = [BXGUserModel yy_modelWithDictionary:result];
            if(userModel){
                [weakSelf login:userModel UserName:nil Social:socialModel.type];
            }
            weakSelf.lastSocialType = socialModel.type;
        }
        finished(status,socialModel,message);
    }];
}

- (void)bindExistAccountWithSocialModel:(BXGSocialModel * _Nullable)socialModel
                               UserName:(NSString * _Nullable)username
                               Password:(NSString * _Nullable)password
                               Finished:(void(^ _Nullable)(BOOL succeed, NSString * _Nullable message))finished {
    NSString * thirdType = [self getThirdType:socialModel.type];
    NSString * thirdId = socialModel.thirdId;
    NSString * accessToken = socialModel.accessToken;
    
    [[BXGNetWorkTool sharedTool] userRequestBindExistAccountWithThirdType:thirdType AccessToken:accessToken ThirdID:thirdId UserName:username Password:password Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        // TODO: 登录流程
        Weak(weakSelf);
        if(status == 200) {
            if([result isKindOfClass:[NSDictionary class]]) {
                BXGUserModel *userModel = [BXGUserModel yy_modelWithDictionary:result];
                if(userModel){
                    [weakSelf login:userModel UserName:username Social:socialModel.type];
                }
            }
            finished(true,@"登录成功");
            // 登录成功操作
        }else {
            finished(false,message);
        }
    }];
}

- (void)bindNewAccountWithSocialModel:(BXGSocialModel * _Nullable)socialModel
                               Mobile:(NSString * _Nullable)mobile
                             Password:(NSString * _Nullable)password
                                 Code:(NSString * _Nullable)code
                             Finished:(void(^ _Nullable)(BOOL succeed, NSString * _Nullable message))finished {
    Weak(weakSelf);
    NSString * thirdType = [self getThirdType:socialModel.type];
    NSString * thirdId = socialModel.thirdId;
    NSString * accessToken = socialModel.accessToken;
    
    [[BXGNetWorkTool sharedTool] userRequestBindNewAccountWithThirdType:thirdType AccessToken:accessToken ThirdID:thirdId Mobile:mobile Password:password Code:code Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        // TODO: 登录流程
        if(status == 200) {
            if([result isKindOfClass:[NSDictionary class]]) {
                BXGUserModel *userModel = [BXGUserModel yy_modelWithDictionary:result];
                if(userModel){
                    [weakSelf login:userModel UserName:mobile Social:socialModel.type];
                }
            }
            finished(true,@"登录成功");
            // 登录成功操作
        }else {
            finished(false,message);
        }
    }];
}

- (void)setLastSocialType:(BXGSocialPlatformType)lastSocialType {
    [BXGUserDefaults share].lastLoginSocialPlatform = lastSocialType;
}

- (BXGSocialPlatformType)lastSocialType {
    return [BXGUserDefaults share].lastLoginSocialPlatform;
}

- (NSString *)getThirdType:(BXGSocialPlatformType )type {
    NSString *thirdType = nil;
    switch (type) {
        case BXGSocialPlatformTypeNone:
        {
            thirdType = nil;
        }break;
        case BXGSocialPlatformTypeWeChat:
        {
            thirdType = @"6";
        }break;
        case BXGSocialPlatformTypeQQ:
        {
            thirdType = @"5";
        }break;
        case BXGSocialPlatformTypeWeibo:
        {
            thirdType = @"7";
        }break;
        default:{
            thirdType = nil;
        }
    }
    return thirdType;
}

///绑定用户名 /bxg/user/bindOtherCount
- (void)bindUserRequestBindUserNameByUserName:(NSString* _Nonnull)userName
                                 andLoginType:(NSString* _Nonnull)loginType //绑定类型，目前只有手机，传2即可（1：用户名，2：手机号，3：邮箱）
                                      andCode:(NSString* _Nonnull)code //手机验证码（绑定手机时必填，此处目前只有手机，所以设置必填，未来有扩展的话就是非必填）
//                                andBindStatus:(NSString* _Nullable)bindStatus //1.更换(更换绑定账号时必填，绑定账号操作不用传)
                               andFinishBlock:(void (^_Nullable)(BOOL bSuccess, NSString * _Nullable errorMessage))finishBlock {
    Weak(weakSelf);
    [[BXGNetWorkTool sharedTool] userRequestBindUserNameByUserName:userName andLoginType:loginType andCode:code Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status==200) {
            if([result isKindOfClass:[NSDictionary class]]) {
                BXGUserModel *userModel = [BXGUserModel yy_modelWithDictionary:result];
                if(userModel){
                    [weakSelf updateUserModel:userModel];
                }
            }
            return finishBlock(TRUE, @"成功");
        } else {
            return finishBlock(FALSE, message);
        }
    }];
}

@end
