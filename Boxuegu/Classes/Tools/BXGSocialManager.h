//
//  BXGSocialManager.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXGSocialModel: NSObject
@property (nonatomic, strong) NSString *thirdId;
@property (nonatomic, strong) NSString *accessToken; 
@property (nonatomic, assign) BXGSocialPlatformType type;
@end

typedef void(^BXGSocialCallbackBlockType)(BOOL success, NSString *msg, BXGSocialModel *model);

@interface BXGSocialManager : NSObject
+ (instancetype)share;
- (void)getAuthWithUserInfoFromQQWithFinished:(void(^)(BOOL success, NSString *msg, BXGSocialModel *model))finished;
- (void)getAuthWithUserInfoFromWechatWithFinished:(void(^)(BOOL success, NSString *msg, BXGSocialModel *model))finished;
- (void)getAuthWithUserInfoFromSinaWithFinished:(void(^)(BOOL success, NSString *msg, BXGSocialModel *model))finished;
- (void)getAuthWithUserInfoWithType:(BXGSocialPlatformType)type
                           Finished:(BXGSocialCallbackBlockType)finished
                     andReturnBlock:(void(^)())returnBlock
                     andCancelBlock:(void(^)())cancelBlock;
@end
