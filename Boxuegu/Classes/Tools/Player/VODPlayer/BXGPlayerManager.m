//
//  BXGPlayerManager.m
//  Boxuegu
//
//  Created by Renying Wu on 2017/11/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPlayerManager.h"
#import "BXGPlayer.h"
#import "BXGAppDelegate.h"

static BXGPlayerManager *_instance;

@interface BXGPlayerManager() <BXGPlayerDelegate>
{
    NSString *_currentVideoId;
}
@property (nonatomic,strong) BXGPlayer *player;
@property (nonatomic,strong) UIView *playerView;
@property (nonatomic,strong) NSMutableArray<id<BXGPlayerManagerDelegate>> *delegates;
@property (nonatomic, assign) BOOL isSeeking;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSMutableArray *seekFinishedBlockArray;
@end
@implementation BXGPlayerManager

#pragma mark - init

+ (instancetype)share {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [BXGPlayerManager new];
    });
    return _instance;
}

#pragma mark - Getter Setter

- (NSMutableArray *)seekFinishedBlockArray {
    
    if(_seekFinishedBlockArray == nil) {
        
        _seekFinishedBlockArray = [NSMutableArray new];
    }
    return _seekFinishedBlockArray;
}

#pragma mark - method

// 创建播放器

- (UIView *)generatePlayerViewWithCCUserId:(NSString *)ccUserId andCCAPIKey:(NSString *)ccAPIKey {
    
    self.player = [BXGPlayer new];
    self.player.delegate = self;
    self.playerView = nil;
    UIView *playerView = [self.player generatePlayerViewWithCCUserId:ccUserId andCCAPIKey:ccAPIKey];
    self.playerView = playerView;
    return playerView;
}

//- (UIView *)generatePlayerView {
//    
//    // 获得用户登录状态
//    self.player = [BXGPlayer new];
//    self.player.delegate = self;
//    self.playerView = nil;
//    UIView *playerView = [self.player generatePlayerView];
//    self.playerView = playerView;
//    return playerView;
//}

// 获取当前播放时间
- (float)currentTime {
    
    return self.player.currentTime;
}

// 获取视频总时长
- (float)durationTime {
    
    return self.player.durationTime;
}

// 获取当前播放状态
- (BOOL)playing {
    return self.player.playing;
}

// 设置播放状态为播放
- (void)play {
    [self.player play];
}

// 设置播放状态为暂停
- (void)pause {
    [self.player pause];
}

// 根据videoId 播放视频
- (void)playWithVideoId:(NSString *)videoId {
    
    // 判断有没有正在播放的视频
    if(_currentVideoId) {
        for (NSInteger i = 0; i < self.delegates.count; i++) {
            
            if([self.delegates[i] respondsToSelector:@selector(playerManagerVideoDidStop:)]) {
                
                [self.delegates[i] playerManagerVideoDidStop:self];
            }
        }
    }
    
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(playerManagerVideoTimeDidChange:timeDidChange:duration:)]) {
            
            [self.delegates[i] playerManagerVideoTimeDidChange:self timeDidChange:0 duration:0];
        }
    }
    
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(playerManager:bufflingStateDidChange:)]) {
            
            [self.delegates[i] playerManager:self bufflingStateDidChange:true];
        }
    }
    
    
    
    
    // 播放下一个视频
    [self.player playWithVideoId:videoId];
    _currentVideoId = videoId;
}

// 根据资源地址 播放视频 (待开发)

// 释放播放资源
- (void)releasePlayer {
    
    // 1.释放player
    [self.player releasePlayer];
    self.player = nil;
    
    // 2.释放playerView
    if(_playerView) {
        
        while(_playerView.subviews.firstObject) {
            
            [_playerView.subviews.firstObject removeFromSuperview];
        }
        if(_playerView.superview) {
            
            [_playerView removeFromSuperview];
        }
        _playerView = nil;
    }
}

// 获取当前速率
- (float)rate {
    return self.player.playerRate;
}

// 设置当前速率
- (void)setRate:(float)rate {
    
    for(NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(playerManager:rateDidChange:)]) {
            [self.delegates[i] playerManager:self rateDidChange:rate];
        }
    }
    [self.player setPlayerRate:rate];
}

// 获取可播放时间
- (NSTimeInterval)playableDuration; {
    return [self.player playableDuration];
}

// 指定时间播放
- (void)seekToTime:(float)time{
    
    if(time < 0) {
        time = 0;
    }
    [self.player seekToTime:time];
}

// 开始拖拽
- (void)startSeekTime:(float)seekTime {
    
    // 1.临界值判断
    if(seekTime < 0) {
        seekTime = 0;
    }
    // 2.暂停
    [self pause];

    // 3.调用代理方法
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(playerManager:startSeekTime:currentTime:duration:)]) {
            
            [self.delegates[i] playerManager:self startSeekTime:seekTime currentTime:self.currentTime duration:self.durationTime];
        }
    }
}

// 拖拽中
- (void)seekingTime:(float)seekTime {
    
    // 1.临界值判断
    if(seekTime < 0) {
        seekTime = 0;
    }
    
    // 2.暂停
    [self pause];
    
    // 3.调用代理方法
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(playerManager:seekingTime:currentTime:duration:)]) {
            
            [self.delegates[i] playerManager:self seekingTime:seekTime currentTime:self.currentTime duration:self.durationTime];
        }
    }
}

// 拖拽完成
- (void)endSeekTime:(float)seekTime {
    
    // 1.临界值判断
    if(seekTime < 0) {
        
        seekTime = 0;
    }
    
    // 2.调用SDK
    [self seekToTime:seekTime];
    [self play];
    
    // 3.调用代理方法
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(playerManager:endSeekTime:currentTime:duration:)]) {
            
            [self.delegates[i] playerManager:self endSeekTime:seekTime currentTime:self.currentTime duration:self.durationTime];
        }
    }
}

#pragma mark - common method

+ (NSString *)formatSecondsToString:(NSInteger)seconds {
    NSString *hhmmss = nil;
    if (seconds < 0) {
        return @"00:00:00";
    }
    
    int h = (int)round((seconds%86400)/3600);
    int m = (int)round((seconds%3600)/60);
    int s = (int)round(seconds%60);
    
    hhmmss = [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
    
    return hhmmss;
}

#pragma mark - Multi-Delegate

- (NSMutableArray<id<BXGPlayerManagerDelegate>> *)delegates {
    
    if(_delegates == nil) {
        
        _delegates = [NSMutableArray new];
    }
    return _delegates;
}

- (void)addDelegate:(id<BXGPlayerManagerDelegate>)delegate {
    
    if([self.delegates containsObject:delegate]) {
        
        // pass
    }else {
        
        [self.delegates addObject:delegate];
    }
}

- (void)removeDelegate:(id<BXGPlayerManagerDelegate>)delegate; {
    
    if([self.delegates containsObject:delegate]) {
        
        [self.delegates removeObject:delegate];
    }
}

#pragma mark - BXGPlayerDelegate

// 播放状态发生改变
- (void)playerPlayStateDidChange:(BXGPlayer *)player state:(BOOL)isPlaying {
    
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(playerManagerPlayStateDidChange:state:)]) {
            
            [self.delegates[i] playerManagerPlayStateDidChange:self state:isPlaying];
        }
    }
}

// 播放完成(中途中断不会调用此代理)
- (void)playerVideoDidReachEnd:(BXGPlayer *)player {
    
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(playerManagerVideoDidReachEnd:)]) {
            
            [self.delegates[i] playerManagerVideoDidReachEnd:self];
        }
    }
    _currentVideoId = nil;
}

// 播放状态为失败
- (void)playerVideoDidFailed:(BXGPlayer *)player didFailWithErrorMsg:(NSString *)errorMsg {
    
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(playerManagerVideoDidFailed:didFailWithErrorMsg:)]) {
            
            [self.delegates[i] playerManagerVideoDidFailed:self didFailWithErrorMsg:@"msg"];
        }
    }
}

// 准备开始播放
- (void)playerVideoReadyToPlay:(BXGPlayer *)player {
    
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(playerManagerVideoReadyToPlay:)]) {
            
            [self.delegates[i] playerManagerVideoReadyToPlay:self];
        }
    }
}

// 播放时间发生改变
- (void)playerVideoTimeDidChange:(BXGPlayer *)player timeDidChange:(float)currentTime duration:(float)durationTime {
    
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(playerManagerVideoTimeDidChange:timeDidChange:duration:)]) {
            
            [self.delegates[i] playerManagerVideoTimeDidChange:self timeDidChange:currentTime duration:durationTime];
        }
    }
}

// 可播放时间发生改变
- (void)player:(BXGPlayer *)player loadedTimeRangeDidChange:(float)duration {
    
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(playerManager:loadedTimeRangeDidChange:)]) {
            
            [self.delegates[i] playerManager:self loadedTimeRangeDidChange:duration];
        }
    }
}

// 缓冲状态发生改变
- (void)player:(BXGPlayer *)player bufflingStateDidChange:(BOOL)isBuffling {
    
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(playerManager:bufflingStateDidChange:)]) {
            
            [self.delegates[i] playerManager:self bufflingStateDidChange:isBuffling];
        }
    }
}

@end
