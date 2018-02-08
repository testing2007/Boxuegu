//
//  BXGQQAPIManager.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGQQAPIManager.h"
#import <TencentOpenAPI/TencentOAuth.h>

//#define kQQAppId @"101420168"
//#define kQQAppId @"101420168"




@interface BXGQQAPIManager() <TencentSessionDelegate>

@property (nonatomic, strong) NSArray *permissions;

// 每次请求后待清理数据
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, copy) BXGCallbackBlockType callbackBlock;
@end

static BXGQQAPIManager *_instance;
@implementation BXGQQAPIManager

- (void)finishedCallbackWithIsCancel:(BOOL)bCancel {
    
    if(_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        dict[@"access_token"] = _tencentOAuth.accessToken;
        dict[@"appid"] = kQQAppId;
        if(self.callbackBlock) {
            self.callbackBlock(true, @"", dict);
        }
    }else {
        if(self.callbackBlock) {
            if(bCancel) {
                self.callbackBlock(false, @"授权取消", nil);
            } else  {
                self.callbackBlock(false, @"授权失败", nil);
            }
        }
    }
    self.callbackBlock = nil;
}

+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       _instance = [BXGQQAPIManager new];
        _instance.permissions = @[kOPEN_PERMISSION_GET_INFO,kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO];
        
    });
    return _instance;
}

+ (BOOL)handleOpenURL:(NSURL *)url; {
    return [TencentOAuth HandleOpenURL:url];
}
+ (void)install {
    [self share];
    
}

- (void)tencentDidLogin
{
    [self finishedCallbackWithIsCancel:NO];
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        [self finishedCallbackWithIsCancel:YES];
    }
    else
    {
        [self finishedCallbackWithIsCancel:NO];
    }
}

-(void)tencentDidNotNetWork
{
    [self finishedCallbackWithIsCancel:NO];
}

#pragma mark - Request

+ (void)getOAuthInfo:(BXGCallbackBlockType )callbackBlock {
    BXGQQAPIManager *apiManager = [self share];
    _instance.tencentOAuth = nil;
    _instance.callbackBlock = nil;    
    _instance.callbackBlock = callbackBlock;
    _instance.tencentOAuth = [[TencentOAuth alloc]initWithAppId:kQQAppId andDelegate:_instance];
    TencentOAuth *tencentOAuth = _instance.tencentOAuth;
    [tencentOAuth authorize:_instance.permissions];
}

#pragma mark - TencentWebViewDelegate(H5登录webview旋转方向回调)

- (BOOL)tencentWebViewShouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation; {
    return false;
}

- (NSUInteger) tencentWebViewSupportedInterfaceOrientationsWithWebkit {
    return UIInterfaceOrientationPortrait;
}

- (BOOL) tencentWebViewShouldAutorotateWithWebkit {
    return false;
}
@end
