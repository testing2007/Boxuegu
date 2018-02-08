//
//  BXGComunityUserModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGCommunityUserModel : BXGBaseModel //BasicUser

@property (nonatomic, strong) NSString *idx;
@property (nonatomic, assign) BOOL isAttention;
@property (nonatomic, strong) NSString *smallHeadPhoto;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userId;


@end
