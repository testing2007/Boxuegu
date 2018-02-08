//
//  BXGPlayer.h
//  RWPlayer
//
//  Created by RenyingWu on 2017/12/13.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXGPlayer;
@protocol BXGPlayerDelegate <NSObject>
@optional
- (void)playerPlayStateDidChange:(BXGPlayer *)player state:(BOOL)isPlaying;
- (void)playerVideoDidReachEnd:(BXGPlayer *)player;
- (void)playerVideoDidFailed:(BXGPlayer *)player didFailWithErrorMsg:(NSString *)errorMsg;
- (void)playerVideoReadyToPlay:(BXGPlayer *)player;
- (void)playerVideoTimeDidChange:(BXGPlayer *)player timeDidChange:(float)currentTime duration:(float)durationTime;
- (void)player:(BXGPlayer *)player loadedTimeRangeDidChange:(float)duration;
- (void)player:(BXGPlayer *)player bufflingStateDidChange:(BOOL)isBuffling;
@end

@interface BXGPlayer : NSObject
@property (nonatomic, weak) id<BXGPlayerDelegate> delegate;

- (void)playWithVideoId:(NSString *)videoId;
- (UIView *)generatePlayerViewWithCCUserId:(NSString *)ccUserId andCCAPIKey:(NSString *)ccAPIKey;
//- (UIView *)generatePlayerView;
- (void)test;
- (void)play;
- (void)pause;
- (void)seekToTime:(float)time;
- (float)currentTime;
- (float)durationTime;
- (BOOL)playing;
- (BOOL)buffling;
- (NSTimeInterval)playableDuration;
- (void)releasePlayer;
- (float)playerRate;
- (void)setPlayerRate:(float)rate;
@end
