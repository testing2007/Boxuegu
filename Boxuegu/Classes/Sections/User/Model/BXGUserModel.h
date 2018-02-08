//
//  BXGUserModel.h
//  Boxuegu
//
//  Created by RW on 2017/4/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGCommunityUserModel.h"

/**
 用户中心 - 用户信息模型
 */
@interface BXGUserModel : BXGBaseModel

/// 用户签名
@property (nonatomic, strong) NSString *sign;
/// 用户Id
@property (nonatomic, strong) NSString *user_id;
/// 用户头像
@property (nonatomic, strong) NSString *head_img;
/// 用户昵称
@property (nonatomic, strong) NSString *nickname;
/// 用户名
@property (nonatomic, strong) NSString *username;
/// CC视频用户名
@property (nonatomic, strong) NSString *cc_user_id;
/// CC视频APIKey
@property (nonatomic, strong) NSString *cc_api_key;

@property (nonatomic, strong) NSString *cc_live_user_id;

@property (nonatomic, strong) NSString *cc_live_playback_key;

/// 密码
@property (nonatomic, strong) NSString *psw;

@property (nonatomic, strong) NSNumber *itcast_uuid;



//
@property (nonatomic, readonly) BXGCommunityUserModel *communityUserModel;


@end
