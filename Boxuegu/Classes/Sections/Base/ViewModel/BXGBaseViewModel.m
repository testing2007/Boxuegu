//
//  BXGBaseViewModel.m
//  Boxuegu
//
//  Created by Renying Wu on 2017/5/11.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
#import "BXGNotificationTool.h"
#import "BXGUserCenter.h"
#import "NetworkParameter.h"
#import "DynamicParameter.h"


@interface BXGBaseViewModel() <BXGNotificationDelegate>
@end

@implementation BXGBaseViewModel

- (instancetype)init {

    self = [super init];
    if(self){
        // 监听用户登录登出
        [BXGNotificationTool addObserverForUserLogin:self];
    }
    return self;
}

-(BXGUserModel *)userModel {
    
    return [BXGUserDefaults share].userModel;
}

- (BXGNetWorkTool *)networkTool {
    
    if(!_networkTool) {
        
        _networkTool = [BXGNetWorkTool sharedTool];
    }
    return _networkTool;
}

- (void)dealloc {
    
    [BXGNotificationTool removeObserver:self];
}

-(void)requstIsBannedFinishedBlock:(void (^)(BannerType bannerType, NSString *errorMessage))finishedBlock
                         isRefresh:(BOOL)bRefresh
{
    Weak(weakSelf);
//    if(!finishedBlock) {
//
//        return ;
//    }
    if(bRefresh)
    {
        [BXGUserCenter share].bannerType = BannerType_Unknow;
    }
    if(BannerType_Unknow == [BXGUserCenter share].bannerType)
    {
//        NSNumber *uuid = [BXGUserCenter share].userModel.itcast_uuid;
//        NSString *sign = [BXGUserCenter share].userModel.sign;
//        NetworkParameter *uuidPara = [[NetworkParameter alloc] initObjectKey:@"userId" value:uuid isOption:NO];
//        NetworkParameter *signPara = [[NetworkParameter alloc] initObjectKey:@"sign" value:sign isOption:NO];
//        DynamicParameter *dynamicParameter = [[DynamicParameter alloc] init];
//        [dynamicParameter setParameters:@[uuidPara, signPara]];
//
//        __weak typeof(self) weakSelf = self;
//        [self.networkTool requestIsBannedWithDynamicParameter:dynamicParameter andCheckParameterBlock:^(BOOL bSuccess, NSString *errorMessage) {
//            if(finishedBlock)
//            {
//                finishedBlock(BannerType_Unknow, @"parameter error");
//            }
//            [BXGUserCenter share].bannerType = BannerType_Unknow;
//        } andFinishedBlock:^(NSInteger status, NSString *message, id result) {
//            BannerType bannerType = [weakSelf _bannerTipStringByNetworkStatus:status andNetworkMessage:message andNetworkResult:result];
//            if(finishedBlock)
//            {
//                finishedBlock(bannerType, @"");
//            }
//            [BXGUserCenter share].bannerType = bannerType;
//        } andFailedBlock:^(NSError * _Nonnull error) {
//            if(finishedBlock)
//            {
//                finishedBlock(BannerType_Unknow, error.debugDescription);
//            }
//            [BXGUserCenter share].bannerType = BannerType_Unknow;
//        }];
        [self.networkTool requestIsBannedWithFinished:^(id  _Nullable responseObject) {
            if(finishedBlock)
            {
                finishedBlock(BannerType_Unknow, @"parameter error");
            }
            [BXGUserCenter share].bannerType = BannerType_Unknow;
            [BXGNetworkParser communityNetworkParser:responseObject andFinished:^(NSInteger status, NSString *message, id result) {
                BannerType bannerType = [weakSelf _bannerTipStringByNetworkStatus:status andNetworkMessage:message andNetworkResult:result];
                if(finishedBlock)
                {
                    finishedBlock(bannerType, @"");
                }
                [BXGUserCenter share].bannerType = bannerType;
            }];
        } Failed:^(NSError * _Nonnull error) {
            if(finishedBlock)
            {
                finishedBlock(BannerType_Unknow, error.debugDescription);
            }
            [BXGUserCenter share].bannerType = BannerType_Unknow;
        }];
    }
    else
    {
        if(finishedBlock)
        {
            finishedBlock([BXGUserCenter share].bannerType, @"");
        }
    }
}

-(BannerType)_bannerTipStringByNetworkStatus:(NSInteger)status
                           andNetworkMessage:(NSString*)message
                            andNetworkResult:(id)result
{
    BannerType type = BannerType_Unknow;
    if(200 == status)
    {
        type = BannerType_None;
    }
    else if(status==400)
    {
        type = BannerType_Black_Name_List;
    }
    else if(status==401)
    {
        type = BannerType_Prohibit_Speak;
    }
    else
    {
        type = BannerType_Unknow;
    }
    return type;
}

@end
