//
//  BXGUserModel.m
//  Boxuegu
//
//  Created by RW on 2017/4/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGUserModel.h"


@implementation BXGUserModel

@synthesize communityUserModel = _communityUserModel;
- (BXGCommunityUserModel *)communityUserModel {

    if(!_communityUserModel) {
    
        _communityUserModel = [BXGCommunityUserModel new];
        _communityUserModel.userId = [self.itcast_uuid stringValue];
        _communityUserModel.isAttention = false;
        _communityUserModel.smallHeadPhoto = self.head_img;
        _communityUserModel.userName = self.username;
    }
    return _communityUserModel;
}
@end
