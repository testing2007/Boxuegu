//
//  VideoPlayerView.h
//  Vimeo
//

//

@import Foundation;
@import AVFoundation;
@import UIKit;

@class DWVideoPlayer;
@class DWVideoPlayerView;

@protocol DWVideoPlayerViewDelegate <NSObject>

@optional
- (void)videoPlayerViewIsReadyToPlayVideo:(DWVideoPlayerView *)videoPlayerView;
- (void)videoPlayerViewDidReachEnd:(DWVideoPlayerView *)videoPlayerView;
- (void)videoPlayerView:(DWVideoPlayerView *)videoPlayerView timeDidChange:(CMTime)cmTime;
- (void)videoPlayerView:(DWVideoPlayerView *)videoPlayerView loadedTimeRangeDidChange:(float)duration;
- (void)videoPlayerViewPlaybackBufferEmpty:(DWVideoPlayerView *)videoPlayerView;
- (void)videoPlayerViewPlaybackLikelyToKeepUp:(DWVideoPlayerView *)videoPlayerView;
- (void)videoPlayerView:(DWVideoPlayerView *)videoPlayerView didFailWithError:(NSError *)error;

@end

@interface DWVideoPlayerView : UIView

@property (nonatomic, weak) id<DWVideoPlayerViewDelegate> delegate;

@property (nonatomic, strong) DWVideoPlayer *player;

- (void)setPlayer:(DWVideoPlayer *)player;


/**
 
 AVPlayerLayer的videoGravity属性设置
 AVLayerVideoGravityResize,       // 非均匀模式。两个维度完全填充至整个视图区域
 AVLayerVideoGravityResizeAspect,  // 等比例填充，直到一个维度到达区域边界
 AVLayerVideoGravityResizeAspectFill, // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
 */

- (void)setVideoFillMode:(NSString *)fillMode;

@end
