//
//  BXGQQAPIManager.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^BXGCallbackBlockType)(BOOL succeed, NSString *msg, NSDictionary* result);
@interface BXGQQAPIManager : NSObject
+ (BOOL)handleOpenURL:(NSURL *)url;
+ (void)getOAuthInfo:(BXGCallbackBlockType )callbackBlock;
@end
