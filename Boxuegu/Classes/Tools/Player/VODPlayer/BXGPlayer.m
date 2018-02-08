//
//  BXGPlayer.m
//  RWPlayer
//
//  Created by RenyingWu on 2017/12/13.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "BXGPlayer.h"
#import "DWSDK.h"
#import "BXGAppDelegate.h"

@interface BXGPlayer() <DWVideoPlayerDelegate>
@property (nonatomic,strong) DWPlayerView *playerView;
@property (nonatomic,strong) NSTimer *playerTimer;
@property (nonatomic,assign) float lastCurrentTime;
@property (nonatomic, assign) BOOL buffling;
@end
@implementation BXGPlayer
@synthesize buffling = _buffling;

#pragma mark - Init

- (instancetype)init {
    
    self = [super init];
    return self;
}
#pragma mark - Function



- (UIView *)generatePlayerViewWithCCUserId:(NSString *)ccUserId andCCAPIKey:(NSString *)ccAPIKey {
    
    NSString *cc_user_id = ccUserId;
    NSString *cc_api_key = ccAPIKey;
    
    self.playerView = nil;
    self.lastCurrentTime = 0;
    
    // 绝对不能存在两个
    DWPlayerView *playerView = [[DWPlayerView alloc]initWithUserId:cc_user_id key:cc_api_key];
    playerView.contentMode = UIViewContentModeScaleAspectFit;
    BXGAppDelegate *appDelegate = (BXGAppDelegate *)[UIApplication sharedApplication].delegate;
    playerView.drmServerPort = appDelegate.drmServer.listenPort;
    playerView.timeoutSeconds = 10;
    // 绑定关系
    self.playerView = playerView;
    playerView.delegate = self;
    
    [self installObserver];
    
    // 创建成功
    return playerView;
}

- (void)playWithVideoId:(NSString *)videoId {
    
    __weak typeof(self) weakSelf = self;
    
    if(videoId.length <= 0) {
        return; // 调用错误回调
    }

    [weakSelf.playerView pause];
    [weakSelf.playerView resetPlayer];
    //    [weakSelf.playerView cancelRequestPlayInfo];
    /* --- 初始化播放器控件 --- */
    
    weakSelf.playerView.timeoutSeconds = 10;
    
    weakSelf.playerView.videoId = videoId;
    weakSelf.playerView.failBlock = ^(NSError *error) {
        [weakSelf videoPlayer:weakSelf.playerView didFailWithError:error];
        //        - (void)videoPlayer:(DWPlayerView *)playerView didFailWithError:(NSError *)error; {
    };
    
    weakSelf.playerView.getPlayUrlsBlock = ^(NSDictionary *playUrls) {
        
        NSNumber *status = [playUrls objectForKey:@"status"];
        
        if (status == nil || [status integerValue] != 0) {
            return;
        }
        
        // 判断是否是VR
        NSNumber *vrmode =[playUrls objectForKey:@"vrmode"];
        
        if (vrmode == nil || [vrmode integerValue] != 0) {
            return;
        }
        
        // 获得最清晰的分辨率的URL
        NSArray *qualityArray = [playUrls objectForKey:@"qualities"];
        if(qualityArray == nil || qualityArray.count <= 0){
            return;
        }
        /* --- 播放视频--- */
        
        
        
        NSString *urlString = qualityArray.lastObject[@"playurl"];
        [weakSelf.playerView resetPlayer];
        [weakSelf.playerView setURL:[NSURL URLWithString:urlString] withCustomId:nil];
        //        [weakSelf.playerView seekToTime:0];
        [weakSelf.playerView scrub:0];
        //        - (void)scrub:(float)time;
        [weakSelf.playerView play];
    };
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [weakSelf.playerView startRequestPlayInfo];
    });
}


- (void)test;{
    
    __weak typeof(self) weakSelf = self;
    [weakSelf.playerView pause];
    [weakSelf.playerView resetPlayer];
//    [weakSelf.playerView cancelRequestPlayInfo];
    /* --- 初始化播放器控件 --- */
    
    weakSelf.playerView.timeoutSeconds = 10;
    
    weakSelf.playerView.videoId = @"454AE8D7351E981E9C33DC5901307461";
    weakSelf.playerView.failBlock = ^(NSError *error) {
        [weakSelf videoPlayer:weakSelf.playerView didFailWithError:error];
//        - (void)videoPlayer:(DWPlayerView *)playerView didFailWithError:(NSError *)error; {
    };
    
    weakSelf.playerView.getPlayUrlsBlock = ^(NSDictionary *playUrls) {
        
        NSNumber *status = [playUrls objectForKey:@"status"];
        
        if (status == nil || [status integerValue] != 0) {
            return;
        }
        
        // 判断是否是VR
        NSNumber *vrmode =[playUrls objectForKey:@"vrmode"];
        
        if (vrmode == nil || [vrmode integerValue] != 0) {
            return;
        }
        
        // 获得最清晰的分辨率的URL
        NSArray *qualityArray = [playUrls objectForKey:@"qualities"];
        if(qualityArray == nil || qualityArray.count <= 0){
            return;
        }
        /* --- 播放视频--- */
        
        
        
        NSString *urlString = qualityArray.lastObject[@"playurl"];
        [weakSelf.playerView resetPlayer];
        [weakSelf.playerView setURL:[NSURL URLWithString:urlString] withCustomId:nil];
//        [weakSelf.playerView seekToTime:0];
        [weakSelf.playerView scrub:0];
//        - (void)scrub:(float)time;
        [weakSelf.playerView play];
    };
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [weakSelf.playerView startRequestPlayInfo];
    });
}

- (void)play {
    [self.playerView play];
}

- (void)pause {
    [self.playerView pause];
}

- (void)seekToTime:(float)time{
    [self.playerView play];
    [self.playerView startScrubbing];
    [self.playerView scrub:time];
    [self.playerView play];
}

#pragma mark - Getter Setter

- (float)currentTime {
    
    float currentTime = 0;
    if(self.playerView.item) {
        currentTime = CMTimeGetSeconds(self.playerView.item.currentTime);
    }
    
    if(isnan(currentTime)) {
        currentTime = 0;
    }
    return currentTime;
}

- (float)durationTime {
    
    float durationTime = 0;
    
    // TODO: 获取当前播放值
    if(self.playerView.item) {
        durationTime = CMTimeGetSeconds(self.playerView.item.duration);
    }
    
    // TODO: 处理Nan值
    if(isnan(durationTime)) {
        durationTime = 0;
    }
    
    return durationTime;
}



- (BOOL)playing {
    
    if(self.playerView){
        
        return self.playerView.playing;
    }else {
        
        return false;
    }
}

#pragma mark - Notification Observer

- (void)installObserver;{
    [self.playerView addObserver:self forKeyPath:@"playing" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(catchEnterForegroundNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(catchEnterBackgroundNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    self.playerTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(playerTimerAction) userInfo:nil repeats:true];
    
    [[NSRunLoop currentRunLoop] addTimer:self.playerTimer forMode:NSRunLoopCommonModes];
}

- (void)playerTimerAction; {
    
    BOOL moved = self.currentTime == self.lastCurrentTime;
    self.lastCurrentTime = self.currentTime;
    if(moved && self.playing) {
        // buffling
        self.buffling = true;
    }else {
        
        self.buffling = false;
    }
}

- (void)setBuffling:(BOOL)buffling {
    if(_buffling == buffling){
        
    }else {
        _buffling = buffling;
        // 调用代理
        if([self.delegate respondsToSelector:@selector(player:bufflingStateDidChange:)]) {
            [self.delegate player:self bufflingStateDidChange:buffling];
        }
    }
}

- (void)uninstallObserver;{
    
    // 播放状态
    
    [self.playerView removeObserver:self forKeyPath:@"playing"];
    
    // 通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 计数器
        [self.playerTimer invalidate];
        self.playerTimer = nil;
    
    // 移除监听网络状态
    //    [BXGNotificationTool removeObserver:self];
}

// 计时器

//    self.playerTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(playerTimerIntervalOperation) userInfo:nil repeats:true];
//
//    [[NSRunLoop currentRunLoop] addTimer:_playerTimer forMode:NSRunLoopCommonModes];


//    // 设备旋转
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(catchDeviceOrientationChange)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:nil
//     ];
//
//
//
//    // 监听网络状态
////    [BXGNotificationTool addObserverForReachability:self];
//
//



- (void)catchEnterForegroundNotification:(NSNotification *)noti {
    
}

- (void)catchEnterBackgroundNotification:(NSNotification *)noti {
    
    //[self playCurrentVideo];
}



#pragma mark - DWVideoPlayerDelegate

//duration 当前缓冲的长度 - 存在bug
- (void)videoPlayer:(DWPlayerView *)playerView loadedTimeRangeDidChange:(float)duration {
    
    // 判断是否是暂停状态 非暂停状态时继续播放
    
    if(self.playing && self.buffling) {
        [self.playerView play];
    }
    
    if([self.delegate respondsToSelector:@selector(player:loadedTimeRangeDidChange:)]) {
        [self.delegate player:self loadedTimeRangeDidChange:duration];
    }
}

//进行跳转后没数据 即播放卡顿
- (void)videoPlayerPlaybackBufferEmpty:(DWPlayerView *)playerView {
    
}

// 进行跳转后有数据 能够继续播放
- (void)videoPlayerPlaybackLikelyToKeepUp:(DWPlayerView *)playerView; {
    
}

//加载失败
- (void)videoPlayer:(DWPlayerView *)playerView didFailWithError:(NSError *)error; {
    
    [self.delegate playerVideoDidFailed:self didFailWithErrorMsg:@"error"];
}

/// 播放器 状态切换
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (object == self.playerView) {
            
            if ([keyPath isEqualToString:@"playing"]) {
                
                BOOL isPlaying =[[change objectForKey:@"new"] boolValue];
                // 调用播放状态变化代理方法
                if([self.delegate respondsToSelector:@selector(playerPlayStateDidChange:state:)]) {
                    [self.delegate playerPlayStateDidChange:self state:isPlaying];
                }
            }
        }
    });
}

/// 播放完毕
- (void)videoPlayerDidReachEnd:(DWPlayerView *)playerView {
    
    if([self.delegate respondsToSelector:@selector(playerVideoDidReachEnd:)]) {
        [self.delegate playerVideoDidReachEnd:self];
    }
}

/// 数据请求完成准备播放
- (void)videoPlayerIsReadyToPlayVideo:(DWPlayerView *)playerView {
    
    if([self.delegate respondsToSelector:@selector(playerVideoReadyToPlay:)]){
        [self.delegate playerVideoReadyToPlay:self];
    }

}

/// 当前播放时间切换
- (void)videoPlayer:(DWPlayerView *)playerView timeDidChange:(CMTime)cmTime {
    
    float durationTime = self.durationTime;
    float currentTime = self.currentTime;
    if([self.delegate respondsToSelector:@selector(playerVideoTimeDidChange:timeDidChange:duration:)]) {
        [self.delegate playerVideoTimeDidChange:self timeDidChange:currentTime duration:durationTime];
    }
}

- (void)releasePlayer {
    
    [self uninstallObserver];
    
//    [self.playerView cancelRequestPlayInfo];
    [self.playerView resetPlayer];
    self.playerView.playerLayer = nil;
    self.playerView.item = nil;
    self.playerView.player = nil;
    self.playerView.urlAsset = nil;
    self.playerView = nil;
}
- (void)setPlayerRate:(float)rate;{
    [self.playerView setPlayerRate:rate];
}
- (float)playerRate {
    return self.playerView.player.rate;
}
- (NSTimeInterval)playableDuration; {
    NSTimeInterval playableDuration = self.playerView.playableDuration;
    // TODO: 处理Nan值
    if(isnan(playableDuration)) {
        playableDuration = 0;
    }
    return playableDuration;
}
@end
