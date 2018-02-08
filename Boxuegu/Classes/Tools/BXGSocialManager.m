//
//  BXGSocialManager.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSocialManager.h"
#import "BXGWXApiManager.h"
#import "BXGQQAPIManager.h"

#import <UMSocialCore/UMSocialCore.h>

@interface BXGSocialManager() <WXApiDelegate>
@property (nonatomic, strong) UMSocialManager *manager;
@end
@implementation BXGSocialManager

static BXGSocialManager *_instance;
+ (instancetype)share {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [BXGSocialManager new];
        [_instance config];
    });
    return _instance;
}

- (void)config {
    UMSocialManager *manager = [UMSocialManager defaultManager];
    self.manager = manager;
    manager.umSocialAppkey = kUmengAppKey;
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kWeiboAppId appSecret:kWeiboAppSc redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}

// QQ登录
- (void)getAuthWithUserInfoFromQQWithFinished:(void(^)(BOOL success, NSString *msg, BXGSocialModel *model))finished; {
    
    [BXGQQAPIManager getOAuthInfo:^(BOOL succeed, NSString *msg, NSDictionary *result) {
        if(succeed) {
            BXGSocialModel *resultModel = [BXGSocialModel new];
            resultModel.accessToken = result[@"access_token"];
            resultModel.thirdId = result[@"appid"];
            resultModel.type = BXGSocialPlatformTypeQQ;
            finished(true,@"",resultModel);
        }else {
            finished(false,msg,nil);
        }
    }];
}

// 微信登录
- (void)getAuthWithUserInfoFromWechatWithFinished:(void(^)(BOOL success, NSString *msg, BXGSocialModel *model))finished
                                   andReturnBlock:(void(^)())returnBlock
                                   andCancelBlock:(void(^)())cancelBlock{
    
    [[BXGWXApiManager share] sendAuthReq:^(BOOL success, NSString *msg, NSDictionary *result) {
        if(success) {
            BXGSocialModel *resultModel = [BXGSocialModel new];
            resultModel.thirdId = result[@"openid"];
            resultModel.accessToken = result[@"access_token"];
            resultModel.type = BXGSocialPlatformTypeWeChat;
            finished(true,@"",resultModel);
        }else {
            finished(false,msg,nil);
        }
    } andReturnBlock:returnBlock
      andCancelBlock:cancelBlock];
}

// 新浪
- (void)getAuthWithUserInfoFromSinaWithFinished:(void(^)(BOOL success, NSString *msg, BXGSocialModel *model))finished; {
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            RWLog(@"error %@", error);
            if(error.code == 2009){ // 取消 
                if(finished) {
                    finished(false, @"授权取消", nil);
                }
            }else{
                if(finished) {
                    finished(false, @"授权失败", nil);
                }
            }
        } else {
            UMSocialUserInfoResponse *resp = result;
            BXGSocialModel *model = [BXGSocialModel new];
            model.thirdId = resp.uid;
            model.accessToken = resp.accessToken;
            model.type = BXGSocialPlatformTypeWeibo;
            if(finished) {
                finished(true, @"", model);
            }
        }
    }];
}

- (void)getAuthWithUserInfoWithType:(BXGSocialPlatformType)type
                           Finished:(BXGSocialCallbackBlockType)finished
                     andReturnBlock:(void(^)())returnBlock
                     andCancelBlock:(void(^)())cancelBlock {
    switch (type) {
        case BXGSocialPlatformTypeNone: {
            
        } break;
        case BXGSocialPlatformTypeWeChat: {
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatSocialEventTypeSocialPlatFormLogin andLabel:@"微信"];
            [[BXGSocialManager share] getAuthWithUserInfoFromWechatWithFinished:finished
                                                                 andReturnBlock:returnBlock
                                                                 andCancelBlock:cancelBlock];
        }break;
        case BXGSocialPlatformTypeQQ: {
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatSocialEventTypeSocialPlatFormLogin andLabel:@"QQ"];
            [[BXGSocialManager share] getAuthWithUserInfoFromQQWithFinished:finished];
        }break;
        case BXGSocialPlatformTypeWeibo: {
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatSocialEventTypeSocialPlatFormLogin andLabel:@"微博"];
            [[BXGSocialManager share] getAuthWithUserInfoFromSinaWithFinished:finished];
        }break;
        default:{
            
        }break;
    }
}


@end

@implementation BXGSocialModel
@end
