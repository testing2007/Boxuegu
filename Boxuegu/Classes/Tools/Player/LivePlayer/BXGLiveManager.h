//
//  BXGLiveManager.h
//  BXGLiveManager
//
//  Created by Renying Wu on 2018/1/3.
//  Copyright © 2018年 Boxuegu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGLiveDialogModel :NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *userAvatar;
@property (nonatomic, strong) NSString *userCustomMark;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *msg;
@end

typedef NS_ENUM(NSUInteger, BXGLiveManagerState) {
    BXGLiveManagerStateLoading = 0,
    BXGLiveManagerStateLive = 1,
    BXGLiveManagerStateStop = 2,
    BXGLiveManagerStateNotStarted = 3,
    BXGLiveManagerStateNetworkError = 4,
    BXGLiveManagerStateUnknownError = 5,
};

#define kStringBXGLiveManagerStateLoading @"加载中"
#define kStringBXGLiveManagerStateLive @"正在直播"
#define kStringBXGLiveManagerStateStop @"直播已停止"
#define kStringBXGLiveManagerStateNotStarted @"直播未开始"
#define kStringBXGLiveManagerStateNetworkError @"网络异常"
#define kStringBXGLiveManagerStateUnknownError @"获取直播信息失败"

typedef NS_ENUM(NSUInteger, BXGLiveManagerPlayMode) {
    BXGLiveManagerPlayModeVideo,
    BXGLiveManagerPlayModeAudio
};

@class BXGLiveManager;
@protocol BXGLiveManagerDelegate

@optional
// 信息

// TODO: 需要一个current Chanel
- (void)liveManager:(BXGLiveManager *)liveManager channelCount:(NSInteger)chanelCount;
- (void)liveManager:(BXGLiveManager *)liveManager currentChannel:(NSInteger)currentChannel;
- (void)liveManager:(BXGLiveManager *)liveManager qualityArray:(NSArray *)qualityArray;
- (void)liveManager:(BXGLiveManager *)liveManager userCount:(NSInteger)userCount;
- (void)liveManager:(BXGLiveManager *)liveManager announcement:(NSString *)announcement;
- (void)liveManager:(BXGLiveManager *)liveManager dialogArray:(NSArray<BXGLiveDialogModel *> *)dialogArray;
- (void)liveManager:(BXGLiveManager *)liveManager introduce:(NSString *)introduce;
- (void)liveManager:(BXGLiveManager *)liveManager state:(BXGLiveManagerState)state msg:(NSString *)msg;
- (void)liveManager:(BXGLiveManager *)liveManager kickOut:(BOOL)isKickOut;

// 音视频切换
- (void)liveManager:(BXGLiveManager *)liveManager changeMode:(BXGLiveManagerPlayMode)mode;

// TODO: 禁言待调整
- (void)liveManager:(BXGLiveManager *)liveManager message:(NSString *)message;

@end


@interface BXGLiveManager : NSObject

+ (instancetype)share;

- (void)install;
- (void)unintall;

- (void)installLiveView:(UIView *)liveView;
- (void)installDocView:(UIView *)docView;
- (void)installRoomId:(NSString *)roomId;
- (void)requestPlay;
- (void)requestStop;
- (void)requestUserCount;

- (UIView *)generatePlayerView;
- (void)switchQuality:(NSInteger)index;
- (void)switchChannel:(NSInteger)index;
- (void)switchMode:(BXGLiveManagerPlayMode)mode;
- (void)chatMessage:(NSString *)message;

@property (nonatomic, readonly) BXGLiveManagerState state;
@property (nonatomic, readonly) BXGLiveManagerPlayMode playMode;
@property (nonatomic, readonly) NSInteger currentChannel;
@property (nonatomic, readonly) UIView *playerView;
@property (nonatomic, readonly) NSInteger channelCount;
@property (nonatomic, assign) BOOL isOnlyAudio;
// Delegate
- (void)addDelegate:(id<BXGLiveManagerDelegate>)delegate;
- (void)removeDelegate:(id<BXGLiveManagerDelegate>)delegate;
- (void)framev:(UIView *)view;
@end
