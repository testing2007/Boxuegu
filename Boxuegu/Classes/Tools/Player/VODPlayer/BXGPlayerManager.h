//
//  BXGPlayerManager.h
//  Boxuegu
//
//  Created by Renying Wu on 2017/11/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXGPlayerManager;

@protocol BXGPlayerManagerDelegate <NSObject>

@optional

// 播放状态发生改变
- (void)playerManagerPlayStateDidChange:(BXGPlayerManager *)playerManager state:(BOOL)isPlaying;

// 视频播放完成
- (void)playerManagerVideoDidReachEnd:(BXGPlayerManager *)playerManager;

// 视频播放失败
- (void)playerManagerVideoDidFailed:(BXGPlayerManager *)playerManager didFailWithErrorMsg:(NSString *)errorMsg;

// 准备开始播放
- (void)playerManagerVideoReadyToPlay:(BXGPlayerManager *)playerManager;

// 播放时间发生改变
- (void)playerManagerVideoTimeDidChange:(BXGPlayerManager *)playerManager timeDidChange:(float)currentTime duration:(float)durationTime;

// 获取播放总时长
- (void)playerManager:(BXGPlayerManager *)playerManager loadedTimeRangeDidChange:(float)duration;

// 获取当前缓冲状态
- (void)playerManager:(BXGPlayerManager *)playerManager bufflingStateDidChange:(BOOL)isBuffling;

// 开始SEEK
- (void)playerManager:(BXGPlayerManager *)playerManager startSeekTime:(float)seekTime currentTime:(float)currentTime duration:(float)durationTime;

// SEEK中
- (void)playerManager:(BXGPlayerManager *)playerManager seekingTime:(float)seekTime currentTime:(float)currentTime duration:(float)durationTime;

/// 完成SEEK
- (void)playerManager:(BXGPlayerManager *)playerManager endSeekTime:(float)seekTime currentTime:(float)currentTime duration:(float)durationTime;

// 速率发生改变
- (void)playerManager:(BXGPlayerManager *)playerManager rateDidChange:(float)rate;

// 视频为播放完成被切换
- (void)playerManagerVideoDidStop:(BXGPlayerManager *)playerManager;
@end

/**
 播放器管理类
 */
@interface BXGPlayerManager : NSObject

/// 单例对象
+ (instancetype)share;

/// 创建播放器

- (UIView *)generatePlayerViewWithCCUserId:(NSString *)ccUserId andCCAPIKey:(NSString *)ccAPIKey;
//- (UIView *)generatePlayerView

/// 根据VideoId播放视频
- (void)playWithVideoId:(NSString *)videoId; // 增加更多interface

/// 当前播放视频资源 (待开发)

/// 当前播放视频id
@property (nonatomic, readonly) NSString *currentVideoId;

/// 倍速
@property (nonatomic, assign) float rate;

/// 暂停
- (void)play;

/// 播放
- (void)pause;

/// SEEK
- (void)seekToTime:(float)time;

/// 开始SEEK (代理)
- (void)startSeekTime:(float)seekTime;

/// SEEK中 (代理)
- (void)seekingTime:(float)seekTime;

/// 完成SEEK (代理)
- (void)endSeekTime:(float)seekTime;

/// 析构播放器
- (void)releasePlayer;

// * 状态
@property (nonatomic, assign) float durationTime;
@property (nonatomic, assign) float currentTime;
@property (nonatomic, readonly) BOOL playing;
@property (nonatomic, readonly) NSTimeInterval playableDuration;

// * 代理
- (void)addDelegate:(id<BXGPlayerManagerDelegate>)delegate;
- (void)removeDelegate:(id<BXGPlayerManagerDelegate>)delegate;

#pragma mark - 不应该在这里
+ (NSString *)formatSecondsToString:(NSInteger)seconds;
@property (nonatomic, strong) NSArray<NSNumber *> *rateList; // 倍速速率 不应该在这里
@end
