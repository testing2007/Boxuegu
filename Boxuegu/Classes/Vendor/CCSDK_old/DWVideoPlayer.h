//

//


@import Foundation;
@import AVFoundation;

#import <CommonCrypto/CommonDigest.h>

@class DWVideoPlayer;

@protocol DWVideoPlayerDelegate <NSObject>

@optional

/*
 *
 *AVPlayerItem的三种状态
 *AVPlayerItemStatusUnknown,
 *AVPlayerItemStatusReadyToPlay,
 *AVPlayerItemStatusFailed
 */


// 可播放／播放中
- (void)videoPlayerIsReadyToPlayVideo:(DWVideoPlayer *)videoPlayer;

//播放完毕
- (void)videoPlayerDidReachEnd:(DWVideoPlayer *)videoPlayer;
//当前播放时间 已经切换到主线程 可直接更新UI
- (void)videoPlayer:(DWVideoPlayer *)videoPlayer timeDidChange:(CMTime)cmTime;

//duration 当前缓冲的长度
- (void)videoPlayer:(DWVideoPlayer *)videoPlayer loadedTimeRangeDidChange:(float)duration;

//进行跳转后没数据 即播放卡顿
- (void)videoPlayerPlaybackBufferEmpty:(DWVideoPlayer *)videoPlayer;

// 进行跳转后有数据 能够继续播放
- (void)videoPlayerPlaybackLikelyToKeepUp:(DWVideoPlayer *)videoPlayer;

//加载失败
- (void)videoPlayer:(DWVideoPlayer *)videoPlayer didFailWithError:(NSError *)error;

@end

typedef void (^DWErrorBlock)(NSError *error);
typedef void(^DWVideoPlayerGetPlayUrlsBlock)(NSDictionary *playUrls);

@interface DWVideoPlayer : NSObject<NSXMLParserDelegate>

@property (nonatomic, weak) id<DWVideoPlayerDelegate> delegate;

@property (nonatomic, strong, readonly) AVPlayer *player;

@property (nonatomic, assign) BOOL playing; //播放时为YES 暂停时为NO
@property (nonatomic, assign, getter=isLooping) BOOL looping;//是否循环播放 默认为NO
@property (nonatomic, assign, getter=isMuted) BOOL muted;//是否静音 默认为NO



@property (copy, nonatomic)NSString *userId;
@property (copy, nonatomic)NSString *videoId;
@property (copy, nonatomic)NSString *key;
@property (assign, nonatomic)NSTimeInterval timeoutSeconds;//超时时间
@property(nonatomic, assign)NSTimeInterval seekStartTime;//滑动时间
@property(nonatomic, strong)NSURL *sourceURL;
@property(nonatomic, assign)int action;
@property(nonatomic, strong)NSString *playaction;
@property(nonatomic, assign)int playNum;
@property(nonatomic, assign)BOOL isReplay;

@property (copy, nonatomic)DWVideoPlayerGetPlayUrlsBlock getPlayUrlsBlock;


/**
 *  @brief 获取视频播放信息或播放过程中发生错误或失败时，回调该block。可以在该block内更新UI，如更改视频播放状态。
 */
@property (copy, nonatomic)DWErrorBlock failBlock;


/**
 *  @brief drmServer 绑定的端口。
 *
 *  若你使用了DRM视频加密播放服务，则必须先启动 DWDrmServer，并在调用 prepareToPlay 之前，设置 drmServerPort 设置为 DWDrmServer 绑定的端口。
 */
@property (assign, nonatomic)UInt16 drmServerPort;

/**
 *  @brief 正在使用的URL。
 *
 *  若播放url的扩展名为pcm，则 writeURL为： http://127.0.0.1:xxx/pcm?url=urlEncode(currentContentURl)， 否则 writeURL 同 URL。
 */
@property (strong, nonatomic, readonly)NSURL *writeURL;

/**
 *  @brief 初始化播放对象
 *
 *  @param userId      用户ID，不能为nil
 *  @param videoId     即将播放的视频ID，不能为nill
 *  @param key         用户秘钥，不能为nil
 *
 *  @return 播放对象
 */
- (id)initWithUserId:(NSString *)userId andVideoId:(NSString *)videoId key:(NSString *)key;

/**
 *  @brief 初始化播放对象
 *
 *  @param userId      用户ID，不能为nil
 *  @param key         用户秘钥，不能为nil
 *
 *  @return 播放对象
 */
- (id)initWithUserId:(NSString *)userId key:(NSString *)key;

/**
 *  @brief 开始请求视频播放信息。
 */
- (void)startRequestPlayInfo;

/**
 *  @brief 取消请求视频播放信息
 */
- (void)cancelRequestPlayInfo;

//setURL方法 添加播放资源  如果有正在播放的资源，会释放掉当前播放的资源
- (void)setURL:(NSURL *)URL;

- (void)setAsset:(AVAsset *)asset;

// Playback

//播放
- (void)play;

//暂停
- (void)pause;

//拖动到指定时间
- (void)seekToTime:(float)time;

//关闭
- (void)reset;

// AirPlay技术 外部播放设置
//支持AirPlay外部播放
- (void)enableAirplay;
//不支持AirPlay外部播放
- (void)disableAirplay;

//检测是否支持支持AirPlay外部播放
- (BOOL)isAirplayEnabled;

// Time Updates
//添加当前播放时间观察
- (void)enableTimeUpdates; // TODO: need these? no
//移除时间观察
- (void)disableTimeUpdates;

// Scrubbing
/*
 *开始滑动
 */
- (void)startScrubbing;

/*
 * 取消当前任务 滑到新的任务指定时间
 */
- (void)scrub:(float)time;

/*
 *停止滑动
 */
- (void)stopScrubbing;

// Volume

//设置音量
- (void)setVolume:(float)volume;
//加大音量
- (void)fadeInVolume;
//减小音量
- (void)fadeOutVolume;


//获取可播放的持续时间
- (NSTimeInterval )playableDuration;

//获取当前player播放的URL
-(NSURL *)urlOfCurrentlyPlayingInPlayer;



//统计信息
/**
 *  @brief 播放动作日志发送接口
 */
-(void)play_action;

/**
 *  @brief 首次加载日志发送接口
 */
-(void)first_load;

/**
 *  @brief 播卡统计click日志发送接口
 */
-(void)playlog_php;

/**
 *  @brief 播卡统计flare日志发送接口
 */
-(void)playlog;

/**
 *   @brief 每次播卡后缓冲完成开始播放时发送
 */
- (void)replay;

/**
 *  @brief 拖拽动作统计
 */
-(void)drag_action;

/**
 *  @brief 清晰度切换统计
 */
- (void)swith_quality;


@end
