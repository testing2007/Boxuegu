//
//  BXGWXApiManager.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/11.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGWXApiManager.h"

static BXGWXApiManager *_instance;

@interface BXGWXApiManager() <WXApiDelegate>
@property (nonatomic, strong) NSMutableDictionary *sendAuthReqBlockDict;
@property (nonatomic, strong) NSMutableDictionary *returnReqBlockDict;
@property (nonatomic, strong) void (^sendAuthReqBlock)(BOOL success, NSString *msg, NSDictionary *rusult);
@property (nonatomic, copy) void(^cancelBlock)() ;

@end

@implementation BXGWXApiManager

+ (BOOL)isWXAppInstalled; {
    return [WXApi isWXAppInstalled];
}

- (NSMutableDictionary *)sendAuthReqBlockDict {
    if(_sendAuthReqBlockDict == nil) {
        _sendAuthReqBlockDict = [NSMutableDictionary new];
    }
    return _sendAuthReqBlockDict;
}

- (NSMutableDictionary *)returnReqBlockDict {
    if(_returnReqBlockDict == nil) {
        _returnReqBlockDict = [NSMutableDictionary new];
    }
    return _returnReqBlockDict;
}

+ (instancetype)share; {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [BXGWXApiManager new];
    });
    return _instance;
}

// 必需要执行 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
+ (void)install {
    [WXApi registerApp:kWeiXinAppId];
}

// 必需要执行 - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
// 必需要执行 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
+ (BOOL)handleOpenURL:(NSURL *)url; {
    return [WXApi handleOpenURL:url delegate:[BXGWXApiManager share]];
}

#pragma mark - WXApiDelegate

// onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
- (void)onReq:(BaseReq *)req {
    
}

- (void)onResp:(BaseResp *)resp {
    Weak(weakSelf);
    
    // 微信支付结果
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
                [BXGNotificationTool postNotificationForOrderPayFinishSuccessCallback];
                RWLog(@"suceess");
                break;
                
            default:
                [BXGNotificationTool postNotificationForOrderPayFinishFailCallback];
                RWLog(@"failed");
                break;
        }
    }
    // 微信登录结果
    if([resp isKindOfClass:[SendAuthResp class]]) {
        if(resp.errCode==-2) {
            //针对有的系统进入微信界面,可以点击"取消"授权返回情况处理;
            self.cancelBlock();
            return;
        }
        
        SendAuthResp *auresp = (SendAuthResp *)resp;
        NSString *appId = kWeiXinAppId;
        NSString *secret = kWeiXinAppSc;
        NSString *code = auresp.code;
        NSString *state = auresp.state;
        NSString *url = [NSString stringWithFormat:@"/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",appId,secret,code];
//        [[BXGHUDTool share] showLoadingHUDWithString:nil];
        
        if(weakSelf.returnReqBlockDict[state]) {
            void(^returnBlock)() = weakSelf.returnReqBlockDict[state];
            returnBlock();
            weakSelf.returnReqBlockDict[state]= nil;
        }
        [[BXGNetWorkTool sharedTool]requestType:POST andBaseURLString:@"https://api.weixin.qq.com" andUrlString:url andParameter:nil andFinished:^(id  _Nullable responseObject) {
            if(weakSelf.sendAuthReqBlockDict[state]
               && [responseObject isKindOfClass:[NSDictionary class]]
               && [responseObject[@"access_token"] isKindOfClass:[NSString class]]
               && [responseObject[@"openid"] isKindOfClass:[NSString class]])
            {
                NSMutableDictionary *dict = [NSMutableDictionary new];
                dict[@"access_token"] = responseObject[@"access_token"];
                dict[@"openid"] = responseObject[@"openid"];
                
                if(weakSelf.sendAuthReqBlockDict[state]) {
                    void(^authBlock)(BOOL success, NSString *msg, NSDictionary *rusult) = weakSelf.sendAuthReqBlockDict[state];
                    authBlock(true,@"",dict);
                    weakSelf.sendAuthReqBlockDict[state]= nil;
                }
            }else {
                // 失败
                if(weakSelf.sendAuthReqBlockDict[state]) {
                    void(^authBlock)(BOOL success, NSString *msg, NSDictionary *rusult) = weakSelf.sendAuthReqBlockDict[state];
                    authBlock(false,@"授权失败",nil);
                    weakSelf.sendAuthReqBlockDict[state]= nil;
                }
            }
        } andFailed:^(NSError * _Nonnull error) {
            [[BXGHUDTool share] closeHUD];
            if(weakSelf.sendAuthReqBlockDict[state]) {
                void(^authBlock)(BOOL success, NSString *msg, NSDictionary *rusult) = weakSelf.sendAuthReqBlockDict[state];
                authBlock(false,@"授权失败",nil);
                weakSelf.sendAuthReqBlockDict[state]= nil;
            }
        }];
    }
}

//                NSString *url2 = [NSString stringWithFormat:@"/sns/userinfo?access_token=%@&openid=%@",responseObject[@"access_token"],responseObject[@"openid"]];
//                [[BXGNetWorkTool sharedTool]requestType:GET andBaseURLString:@"https://api.weixin.qq.com" andUrlString:url2 andParameter:nil andFinished:^(id  _Nullable responseObject) {
//                    if(weakSelf.sendAuthReqBlockDict[state]
//                       && [responseObject isKindOfClass:[NSDictionary class]]
//                       && [responseObject[@"unionid"] isKindOfClass:[NSString class]])   {
//                        void(^authBlock)(BOOL success, NSString *msg, NSString *uid) = weakSelf.sendAuthReqBlockDict[state];
//                        authBlock(true,@"登录成功",responseObject);
//                        weakSelf.sendAuthReqBlockDict[state]= nil;
//                    }else {
//                        if(weakSelf.sendAuthReqBlockDict[state]) {
//                            void(^authBlock)(BOOL success, NSString *msg, NSString *uid) = weakSelf.sendAuthReqBlockDict[state];
//                            authBlock(false,@"登录失败",nil);
//                            weakSelf.sendAuthReqBlockDict[state]= nil;
//                        }
//                    }
//                } andFailed:^(NSError * _Nonnull error) {
//                    if(weakSelf.sendAuthReqBlockDict[state]) {
//                        void(^authBlock)(BOOL success, NSString *msg, NSString *uid) = weakSelf.sendAuthReqBlockDict[state];
//                        authBlock(false,@"登录失败",nil);
//                        weakSelf.sendAuthReqBlockDict[state]= nil;
//                    }
//                }];
//            }else {
//                if(weakSelf.sendAuthReqBlockDict[state]) {
//                    void(^authBlock)(BOOL success, NSString *msg, NSString *uid) = weakSelf.sendAuthReqBlockDict[state];
//                    authBlock(false,@"登录失败",nil);
//                    weakSelf.sendAuthReqBlockDict[state]= nil;
//                }
//            }

- (void)sendAuthReq:(void(^)(BOOL success, NSString *msg, NSDictionary *result))finished
     andReturnBlock:(void(^)())returnBlock
     andCancelBlock:(void(^)())cancelBlock {
    // TODO: 是否安装微信
    if([WXApi isWXAppInstalled]) {
        self.cancelBlock = cancelBlock;
        // ** 已安装
        SendAuthReq* req =[SendAuthReq new];
//        req.scope = @"snsapi_userinfo";
        req.scope = @"snsapi_userinfo,snsapi_base";
        NSString *state = [NSString stringWithFormat:@"%zd",@([[NSDate new] timeIntervalSince1970]).integerValue];
        // 存放到字典
        if(finished){
            self.sendAuthReqBlockDict[state] = finished;
            self.returnReqBlockDict[state] = returnBlock;
        }
        req.state = state;
        [WXApi sendReq:req];
    }else {
        if(finished) {
            finished(false,@"未安装微信",nil);
        }
    }
}
@end
