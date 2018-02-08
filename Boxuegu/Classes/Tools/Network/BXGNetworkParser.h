//
//  BXGNetworkParser.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGCommunityParserItem.h"
#import "BXGMainParserItem.h"

typedef NS_ENUM(NSInteger, BXGNetworkResultStatus) {
    //
    BXGNetworkResultStatusSucceed = 200,
    BXGNetworkResultStatusFailed = 400,
    BXGNetworkResultStatusExpired = 1001,
    BXGNetworkResultStatusParserError = 0,
    // error
    BXGNetworkResultStatusServerError = 500,
};

/// 200 成功 400 失败 1001 过期
@interface BXGNetworkParser : NSObject

+ (void)communityNetworkParser:(id)obj andFinished:(void(^)(BXGNetworkResultStatus status, NSString *message, id result))finishedBlock;
+ (void)consultNetworkParser:(id)obj andFinished:(void(^)(BXGNetworkResultStatus status, NSString *errorMsg, id result))finishedBlock;
+ (void)userNetworkParser:(id)obj andFinished:(void(^)(BXGNetworkResultStatus status, NSString *message, id result))finishedBlock;
+ (void)mainNetworkParser:(id)obj andFinished:(void(^)(BXGNetworkResultStatus status, NSString *message, id result))finishedBlock;
@end
