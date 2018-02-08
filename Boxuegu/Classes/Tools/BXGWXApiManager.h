//
//  BXGWXApiManager.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/11.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef void (^CancelBlockType)(void);
@interface BXGWXApiManager : NSObject
+ (instancetype)share;

/**
 启动 初始化
 */
+ (void)install;


/**
 必需要在这里执行 - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
 必需要在这里执行 -(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
 */
+ (BOOL)handleOpenURL:(NSURL *)url;
+ (BOOL)isWXAppInstalled;
- (void)sendAuthReq:(void(^)(BOOL success, NSString *msg, NSDictionary *result))finished
     andReturnBlock:(void(^)())returnBlock
     andCancelBlock:(void(^)())cancelBlock;

@end

