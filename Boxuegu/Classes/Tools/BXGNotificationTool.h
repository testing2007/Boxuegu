//
//  BXGNotificationTool.h
//  Boxuegu
//
//  Created by HM on 2017/4/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGNotificationTool.h"
#import "BXGUserModel.h"

@protocol BXGNotificationDelegate <NSObject>

@optional

- (void)catchUserLoginNotificationWith:(BOOL)isLogin;
- (void)catchRechbility:(BXGReachabilityStatus)status;
- (void)catchNewMessageCount:(NSInteger)count;
- (void)catchServerError; // 即将移除
- (void)catchSignInNotificationWithUserModel:(BXGUserModel *)userModel;
- (void)catchOrderPayFinishSuceessCallback;
- (void)catchOrderPayFinishFailCallback;
- (void)catchOrderCancelOK;
- (void)catchUserExpired;

@end

@interface BXGNotificationTool : NSObject <BXGNetWorkToolDelegate>

+ (instancetype)share;

/**
 用户登录通知 (旧) (将要废弃)
 */
+ (void)addObserverForUserLogin:(NSObject<BXGNotificationDelegate> *)observer;
+ (void)postNotificationForUserLogin:(BOOL)isLogin;

/**
 用户登录通知 (新)
 */
+ (void)addObserverForSignIn:(NSObject<BXGNotificationDelegate> *)observer;
+ (void)postNotificationForSignInWithUserModel:(BXGUserModel *)userModel;

/**
 网络状态变化通知
 */

+ (void)addObserverForReachability:(NSObject<BXGNotificationDelegate> *)observer;
+ (void)postNotificationForReachability:(BXGReachabilityStatus)state;

#pragma mark - 通知新消息

+ (void)postNotificationForNewMessageCount:(NSInteger)count;
+ (void)addObserverForNewMessageCount:(NSObject<BXGNotificationDelegate> *)observer;


#pragma mark - 通知网络错误
+ (void)postNotificationForServerError;
+ (void)addObserverForServerError:(NSObject<BXGNotificationDelegate> *)observer;

#pragma mark - 通知用户过期
+ (void)postNotificationForUserExpired;
+ (void)addObserverForUserExpired:(NSObject<BXGNotificationDelegate> *)observer;

/**
 订单支付完成回调通知
 */
+ (void)addObserverForOrderPayFinishSuccessCallback:(NSObject<BXGNotificationDelegate> *)observer;
+ (void)postNotificationForOrderPayFinishSuccessCallback;

+ (void)addObserverForOrderPayFinishFailCallback:(NSObject<BXGNotificationDelegate> *)observer;
+ (void)postNotificationForOrderPayFinishFailCallback;

///订单取消
+ (void)addObserverForOrderCancelOK:(NSObject<BXGNotificationDelegate> *)observer;
+ (void)postNotificationForOrderCancelOK;

//

/// 移除监听
+ (void)removeObserver:(id)obj;
@end
