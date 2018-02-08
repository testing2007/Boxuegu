//
//  BXGNotificationTool.m
//  Boxuegu
//
//  Created by RW on 2017/4/18.
//  Copyright © 2017年 itcast. All rights reserved.
//
#import "BXGNotificationTool.h"

// 用户登录登出通知名 (旧)
#define kBXGNotiNameUserLogin @"kBXGNotiNameUserLogin"
#define kBXGNotiUserInfoUserLogin @"kBXGNotiUserInfoUserLogin"

// 用户登录登出通知名 (新)
#define kBXGNotiNameSignIn @"kBXGNotiNameSignIn"
#define kBXGNotiUserInfoSignIn @"kBXGNotiUserInfoSignIn"

// 用户网路检测通知名
#define kBXGNotiNameReachbility @"kBXGNotiNameReachbility"
#define kBXGUserInfoReachbility @"kBXGUserInfoReachbilityState"

// 通知新消息总数
#define kBXGNotiNameNewMessage @"kBXGNotiNameNewMessage"
#define kBXGNotiUserInfoNewMessageCount @"kBXGNotiUserInfoNewMessageCount"

// 服务器异常 /
#define kBXGNotiServerError @"kBXGNotiServerError"
#define kBXGNotiUserInfokNotiServerError @"kBXGNotiUserInfokNotiServerError"

// Token过期通知
#define kBXGNotiNameUserExpired @"kBXGNotiNameUserExpired"

//订单支付通知
#define kBXGNotiNameOrderFinishPaySuccessCallback @"kBXGNotiNameOrderFinishPaySuccessCallback"
#define kBXGNotiNameOrderFinishPayFailCallback @"kBXGNotiNameOrderFinishPayFailCallback"

//订单取消通知
#define kBXGNotiNameOrderCancelOK @"kBXGNotiNameOrderCancelOK"

#define kUserLogin @"BXGUserLogin"


@interface BXGNotificationTool() <BXGNetWorkToolDelegate>

@end

@implementation BXGNotificationTool

static BXGNotificationTool *instance;
+ (instancetype)share {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        instance = [BXGNotificationTool new];
    });
    return instance;
}

+ (void)addObserverForUserLogin:(NSObject<BXGNotificationDelegate> *)observer {
    
    __weak NSObject<BXGNotificationDelegate> *weakObserver = observer;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kBXGNotiNameUserLogin object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if([weakObserver respondsToSelector:@selector(catchUserLoginNotificationWith:)]) {
        
            NSNumber *login = [note.userInfo objectForKey:kBXGNotiUserInfoUserLogin];
            [weakObserver catchUserLoginNotificationWith:[login boolValue]];
        }
    }];
}



/**
 用户登录通知 (新)
 */
//+ (void)addObserverForSignIn:(NSObject<BXGNotificationDelegate> *)observer {
//
//    NSDictionary *dict = @{kuser: @(isLogin)};
//    [[NSNotificationCenter defaultCenter] postNotificationName:kBXGNotiNameUserLogin object:nil userInfo:dict];
//}
//
//+ (void)postNotificationForSignInWithUserModel:(BXGUserModel *)userModel {
//
//    
//}




+ (void)postNotificationForUserLogin:(BOOL)isLogin {

    NSDictionary *dict = @{kBXGNotiUserInfoUserLogin: @(isLogin)};
    [[NSNotificationCenter defaultCenter] postNotificationName:kBXGNotiNameUserLogin object:nil userInfo:dict];
}

+ (void)postNotificationForReachability:(BXGReachabilityStatus)state {
    
    NSDictionary *dict = @{kBXGUserInfoReachbility: @(state)};
    [[NSNotificationCenter defaultCenter] postNotificationName:kBXGNotiNameReachbility object:nil userInfo:dict];
}

+ (void)addObserverForReachability:(NSObject<BXGNotificationDelegate> *)observer; {

    __weak NSObject<BXGNotificationDelegate> *weakObserver = observer;
    
    [[NSNotificationCenter defaultCenter] addObserverForName: kBXGNotiNameReachbility object:nil queue:[NSOperationQueue mainQueue]  usingBlock:^(NSNotification * _Nonnull noti) {
        
        if([weakObserver respondsToSelector:@selector(catchRechbility:)]){
            NSNumber *state = [noti.userInfo objectForKey:kBXGUserInfoReachbility];
            [weakObserver catchRechbility: [state integerValue]];
        }
    }];
}


#pragma mark - 通知新消息

+ (void)postNotificationForNewMessageCount:(NSInteger)count {
    
    NSDictionary *dict = @{kBXGNotiUserInfoNewMessageCount: @(count)};
    [[NSNotificationCenter defaultCenter] postNotificationName:kBXGNotiNameNewMessage object:nil userInfo:dict];
}

+ (void)addObserverForNewMessageCount:(NSObject<BXGNotificationDelegate> *)observer {
    
    __weak NSObject<BXGNotificationDelegate> *weakObserver = observer;
    
    [[NSNotificationCenter defaultCenter] addObserverForName: kBXGNotiNameNewMessage object:nil queue:[NSOperationQueue mainQueue]  usingBlock:^(NSNotification * _Nonnull noti) {
        
        if([weakObserver respondsToSelector:@selector(catchNewMessageCount:)]){
            NSNumber *state = [noti.userInfo objectForKey:kBXGNotiUserInfoNewMessageCount];
            [weakObserver catchNewMessageCount: [state integerValue]];
        }
    }];
}

#pragma mark - remove

+ (void)removeObserver:(id)obj {
    
    [[NSNotificationCenter defaultCenter] removeObserver:obj];

}

#pragma mark - 服务器异常 / Token过期通知

+ (void)postNotificationForServerError {

    [[NSNotificationCenter defaultCenter] postNotificationName:kBXGNotiServerError object:nil userInfo:nil];
}

+ (void)addObserverForServerError:(NSObject<BXGNotificationDelegate> *)observer {
    
    __weak NSObject<BXGNotificationDelegate> *weakObserver = observer;
    
    [[NSNotificationCenter defaultCenter] addObserverForName: kBXGNotiServerError object:nil queue:[NSOperationQueue mainQueue]  usingBlock:^(NSNotification * _Nonnull noti) {
        
        if([weakObserver respondsToSelector:@selector(catchServerError)]){
            
            [weakObserver catchServerError];
        }
    }];
}

#pragma mark - Network Toll delegate

- (void)networkServerError {

    [[NSNotificationCenter defaultCenter] postNotificationName:kBXGNotiServerError object:nil userInfo:nil];
}

#pragma mark - Pay Finish Callback

+ (void)addObserverForOrderPayFinishSuccessCallback:(NSObject<BXGNotificationDelegate> *)observer {
    
    __weak NSObject<BXGNotificationDelegate> *weakObserver = observer;

    [[NSNotificationCenter defaultCenter] addObserverForName:kBXGNotiNameOrderFinishPaySuccessCallback object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if([weakObserver respondsToSelector:@selector(catchOrderPayFinishSuceessCallback)]) {
            
            [weakObserver catchOrderPayFinishSuceessCallback];
        }
    }];
}

+ (void)postNotificationForOrderPayFinishSuccessCallback {
    [[NSNotificationCenter defaultCenter] postNotificationName:kBXGNotiNameOrderFinishPaySuccessCallback object:nil userInfo:nil];
}

+ (void)addObserverForOrderPayFinishFailCallback:(NSObject<BXGNotificationDelegate> *)observer {
    
    __weak NSObject<BXGNotificationDelegate> *weakObserver = observer;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kBXGNotiNameOrderFinishPayFailCallback object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if([weakObserver respondsToSelector:@selector(catchOrderPayFinishFailCallback)]) {
            
            [weakObserver catchOrderPayFinishFailCallback];
        }
    }];
}

+ (void)postNotificationForOrderPayFinishFailCallback {
    [[NSNotificationCenter defaultCenter] postNotificationName:kBXGNotiNameOrderFinishPayFailCallback object:nil userInfo:nil];
}

+ (void)addObserverForOrderCancelOK:(NSObject<BXGNotificationDelegate> *)observer {
    
    __weak NSObject<BXGNotificationDelegate> *weakObserver = observer;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kBXGNotiNameOrderCancelOK object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if([weakObserver respondsToSelector:@selector(catchOrderCancelOK)]) {
            
            [weakObserver catchOrderCancelOK];
        }
    }];
}

+ (void)postNotificationForOrderCancelOK {
    [[NSNotificationCenter defaultCenter] postNotificationName:kBXGNotiNameOrderCancelOK object:nil userInfo:nil];
}

#pragma mark - 通知用户过期

+ (void)addObserverForUserExpired:(NSObject<BXGNotificationDelegate> *)observer {
    __weak NSObject<BXGNotificationDelegate> *weakObserver = observer;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kBXGNotiNameUserExpired object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if([weakObserver respondsToSelector:@selector(catchUserExpired)]) {
            [weakObserver catchUserExpired];
        }
    }];
}

+ (void)postNotificationForUserExpired {
    [[NSNotificationCenter defaultCenter] postNotificationName:kBXGNotiNameUserExpired object:nil userInfo:nil];
}

@end
