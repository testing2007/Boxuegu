//
//  BXGBasePlayerVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

// Common
#import "BXGAppDelegate.h"

// SDK
#import "DWSDK.h"

// Component
#import "BXGSelectionCell.h"
#import "BXGSelectionVideoCell.h"
#import "BXGLearnedBtn.h"
#import "BXGPlayerHeaderBackBtn.h"
#import "BXGPlayerChangeSizeBtn.h"
#import "BXGPlayerLockBtn.h"
#import "BXGPlayerPlayBtn.h"
#import "BXGPlayerBigPlayBtn.h"
#import "RWSlider.h"

// util
#import "UIExtTableView.h"
#import "UIColor+Extension.h"
#import "RWResponseView.h"
#import "BXGBasePlayerVC.h"


#import "BXGPlayerViewModel.h"

#import "BXGResourceManager.h"

#import "BXGDownloader.h"
#import "BXGHistoryTable.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RWCommonFunction.h"
#import "BXGPlayerGradientView.h"

#pragma mark - 封装

// 1.Player Content View
#import "BXGBasePlayerContentVC.h"
#import "BXGPlayerSeekView.h"

@interface BXGBasePlayerVC () <DWVideoPlayerDelegate, UIGestureRecognizerDelegate,BXGNotificationDelegate>

@property (nonatomic, strong) DWPlayerView *playerView;

// Frame
@property (nonatomic, strong) UIView *mediaView;
@property (nonatomic, strong) UIView *componentView;
@property (nonatomic, strong) RWResponseView *gestrueView;
@property (nonatomic, weak) UIView *playerHeaderView;
@property (nonatomic, weak) UIView *playerFooterView;
@property (nonatomic, weak) UIActivityIndicatorView *bufferingView;

// Sub Components
@property (nonatomic, weak) BXGPlayerChangeSizeBtn *changeSizeBtn;
@property (nonatomic, weak) BXGPlayerLockBtn *playerLockBtn;
@property (nonatomic, weak) UILabel *playerDurationLabel;
@property (nonatomic, weak) UILabel *playerCurrentTimeLabel;
@property (nonatomic, weak) UISlider *playerSlider;
@property (nonatomic, weak) BXGPlayerBigPlayBtn * playerBigPlayBtn;
@property (nonatomic, weak) BXGPlayerPlayBtn * playerPlayBtn;
@property (nonatomic, weak) BXGPlayerHeaderBackBtn *playerHeaderBackBtn;
@property (nonatomic, weak) BXGLearnedBtn *learnedBtn;
@property (nonatomic, weak) UIButton *selectSpeedBtn;
@property (nonatomic, assign) NSInteger currentSpeedIndex;
@property (nonatomic, strong) UIExtTableView *selectSpeedTableView;
@property (nonatomic, strong) UIExtTableView *selectVideoTableView;
@property (nonatomic, weak) UIButton *headerDownloadBtn;
@property (nonatomic, weak) UIButton *selectVideoBtn;
@property (nonatomic, weak) UIView *componentFooterView;
@property (nonatomic, weak) UIView *componentFooterContentView;
@property (nonatomic, weak) UIView *componentHeaderContentView;
// left popView
@property (nonatomic, weak) UIView *footerMoreView;
@property (nonatomic, weak) UIView *leftPopView;
@property (nonatomic, weak) UIView *popView;
@property (nonatomic, weak) UILabel *leftPopViewTitleLabel;
@property (nonatomic, weak) UIView *popContentView;

// 状态
@property (nonatomic, assign) BOOL isLock;
@property (nonatomic, assign) BOOL isSeeking;
@property (nonatomic, assign) BOOL isStatusBarHiden;
@property (nonatomic, assign) BOOL isMediaScreenFull;
@property (nonatomic, assign) BOOL isAutoPlay;
@property (nonatomic, assign) BOOL isExit;
@property (nonatomic, assign) BOOL isAllowCellularWatchOnce;
@property (nonatomic, assign) BOOL isTracking;
@property (nonatomic, assign) BOOL isTryCourse;
@property (nonatomic, assign) double trackingSeekPercent;
@property (nonatomic, assign) BXGCoursePlayType coursePlayType;

// 数据
@property (nonatomic, strong) NSArray<NSDictionary *> *playerSpeedSelectionArray;
@property (nonatomic, strong) NSArray<NSString *> *playerVideoSelectionArray;

// 播放器 计时器
@property (nonatomic, strong) NSTimer *playerTimer;
// 隐藏播放器控件记录时间
@property (nonatomic, strong) NSDate *hidePlayerComponentsDate;

// 当前 | 上次 播放的知识点
@property (nonatomic, strong) BXGCourseOutlineVideoModel *currentPlayVideoModel;
@property (nonatomic, strong) BXGCourseOutlineVideoModel *lastVideoModel; // 上次播放的视频

// 当前播放的VideoModel
@property (nonatomic, copy) NSString *autoPlayPointId;
@property (nonatomic, copy) NSString *autoPlayVideoId;

@property (nonatomic, strong) MPVolumeView *volumeView;

#pragma mark - 封装

// 1.Player Content View
@property (nonatomic, weak) BXGBasePlayerContentVC *contentVC;
@property (nonatomic, strong) BXGPlayerViewModel *playerViewModel;
@property (nonatomic, weak) UIView *contentView;
// @property (nonatomic) NSArray *pointArray;


// 音量调节
typedef NS_ENUM(NSUInteger, Direction) {
    DirectionLeftOrRight,
    DirectionUpOrDown,
    DirectionNone
};

@property (assign, nonatomic) Direction direction;
@property (assign, nonatomic) CGPoint startPoint;
@property (assign, nonatomic) CGFloat startVB;
@property (assign, nonatomic) CGFloat startVideoRate;
@property (nonatomic, strong) UISlider* volumeViewSlider;
@property (nonatomic, assign) float systemVolume;//系统音量值
@property (nonatomic, assign) float changingVolume;
@property (nonatomic, strong) BXGPlayerSeekView *playerSeekView;

// 进度调节
@property (nonatomic, assign) BOOL isPlayerDidSeekTime;
@property (nonatomic, assign) double playerSeekTimeRate;

// 本地视频播放
@property (nonatomic, assign) BOOL isOfflineVideo;
@property (nonatomic, copy) NSString *offlineFilePath;
@property (nonatomic, copy) NSString *offlineVideoId;
@property (nonatomic, strong) BXGCourseOutlineVideoModel *offlineVideoModel;
@end

@implementation BXGBasePlayerVC

@synthesize playerSeekView = _playerSeekView;

- (instancetype)initWithFilePath:(NSString*)filePath andVideoId:(NSString*)videoId; {

    self = [super init];
    if(self) {
    
        self.offlineVideoId = videoId;
        self.offlineFilePath = filePath;
        self.isOfflineVideo = true;
        self.coursePlayType = BXGCoursePlayTypeLocalCourse;
    }
    return self;
}

- (instancetype)initWithFilePath:(NSString*)filePath andVideoId:(NSString*)videoId andCourseModel:(BXGCourseModel *)courseModel; {
    
    self = [super init];
    if(self) {
        
        self.playerViewModel = [[BXGPlayerViewModel alloc]initWithCourseModel:courseModel];
        self.offlineVideoId = videoId;
        self.offlineFilePath = filePath;
        self.isOfflineVideo = true;
        self.coursePlayType = BXGCoursePlayTypeLocalCourse;
    }
    return self;

}

- (instancetype)initWithVideoModel:(BXGCourseOutlineVideoModel *)videoModel andCourseModel:(BXGCourseModel *)courseModel; {
    
    self = [super init];
    if(self) {
    
        self.playerViewModel = [[BXGPlayerViewModel alloc]initWithCourseModel:courseModel];
        self.offlineVideoModel = videoModel;
        // [self playWithVideoModel:videoModel];
        self.isOfflineVideo = true;
    }
    return self;
}

- (void)autoPlayWithPointId:(NSString *)pointId andVideoId:(NSString *)videoId; {

    self.isAutoPlay = true;
    self.autoPlayPointId = pointId;
    self.autoPlayVideoId = videoId;
//    NSLog(@"function pointId:%@, videoId:%@",pointId ,videoId);
}


- (void)setPointModelArray:(NSArray *)pointModelArray {

    __weak typeof (self) weakSelf = self;

    _pointModelArray = pointModelArray;
    
    weakSelf.playerViewModel.pointModelArray = pointModelArray;
    // 获取资源成功
    
    weakSelf.isAutoPlay = true;
    if(weakSelf.isAutoPlay) {
        
        [weakSelf autoplay];
    }
}

- (void)setAutoPlayPointId:(NSString *)autoPlayPointId {

    _autoPlayPointId = autoPlayPointId;
}


//- (instancetype)initWithContentVC:(BXGBasePlayerContentVC *)contentVC; {
//    self = [super init];
//    if(self) {
//    
//        __weak typeof (self) weakSelf = self;
//        
//        self.contentVC = contentVC;
//        [self addChildViewController:contentVC];
//        self.contentView = contentVC.view;
//        
//        contentVC.settingPointModelArrayBlock = ^(NSArray<BXGCourseOutlinePointModel *> *pointModelArray) {
//            weakSelf.playerViewModel.pointModelArray = pointModelArray;
//        };
//        contentVC.clickVideoModelBlock = ^(BXGCourseOutlineVideoModel *videoModel) {
//          
//            [weakSelf playWithVideoModel:videoModel];
//        };
//    }
//    return self;
//}

- (instancetype)initWithCourseId:(NSString *)courseId andContentVC:(BXGBasePlayerContentVC *)contentVC andPlayType:(BXGCoursePlayType)type; {
    self.coursePlayType = type;
    
    BXGCourseModel *courseModel = [[BXGCourseModel alloc]init];
    courseModel.course_id = courseId;
    self = [self initWithCourseModel:courseModel ContentVC:contentVC];
    return self;
}
- (instancetype)initWithCourseModel:(BXGCourseModel *)courseModel ContentVC:(BXGBasePlayerContentVC *)contentVC; {
    self = [super init];
    if(self) {
        
        __weak typeof (self) weakSelf = self;
        
        self.contentVC = contentVC;
        self.courseModel = courseModel;
        [self addChildViewController:contentVC];
//        contentVC.view.frame = CGRectZero;
        self.contentView = contentVC.view;
        
        contentVC.settingPointModelArrayBlock = ^(NSArray<BXGCourseOutlinePointModel *> *pointModelArray) {
            
            
            weakSelf.playerViewModel = [[BXGPlayerViewModel alloc]initWithCourseModel:weakSelf.courseModel andPontModelArray:pointModelArray];
            
            
            // if((BXGReachabilityStatus)[BXGNetWorkTool sharedTool].getReachState == BXGReachabilityStatusReachabilityStatusReachableViaWWAN)
            
            [weakSelf operationAllowCellularWatchOnceAlert:(BXGReachabilityStatus)[BXGNetWorkTool sharedTool].getReachState allowBlock:^{
            
                [weakSelf autoplay];
            }];
            
            
            
        };
        contentVC.clickVideoModelBlock = ^(BXGCourseOutlineVideoModel *videoModel) {
            
            [weakSelf playWithVideoModel:videoModel];
        };
    }
    return self;
}

- (void)autoplay {

    __weak typeof (self) weakSelf = self;
    
    BXGCourseOutlineVideoModel *videoModel;
    
    if(weakSelf.autoPlayVideoId){
    
       videoModel = [weakSelf.playerViewModel videoModelWithVideoId:weakSelf.autoPlayVideoId];
        if(videoModel) {
        
            
            if(videoModel){
                
                [weakSelf playWithVideoModel:videoModel];
                [weakSelf.contentVC scrollToModel:videoModel];
                // [weakSelf.contentVC searchVideoModel:videoModel];
                return;
            }
        }
    }
    
    BXGCourseOutlinePointModel *pointModel = [weakSelf.playerViewModel pointModelWithPointId:weakSelf.autoPlayPointId];
    if(pointModel) {
        
        videoModel = [pointModel videoModelForLastLearned];
        if(!videoModel) {
            
            videoModel = [weakSelf.playerViewModel firstVideoModel:pointModel];
        }
        
    }else {
        
        videoModel = [weakSelf.playerViewModel videoModelForLastLearned];
        if(!videoModel) {
            
            videoModel = [weakSelf.playerViewModel firstVideoModel:[weakSelf.playerViewModel firstPointModel]];
        }
    }
    
    if(videoModel){
    
         [weakSelf playWithVideoModel:videoModel];
         [weakSelf.contentVC scrollToModel:videoModel];
        // [weakSelf.contentVC searchVideoModel:videoModel];
    }
}

- (BXGPlayerViewModel *)playerViewModel {

    if(_playerViewModel == nil){
    
        _playerViewModel = [[BXGPlayerViewModel alloc]initWithCourseModel:self.courseModel andPontModelArray:self.pointModelArray];
    }
    return _playerViewModel;
}

#pragma mark - 自定义状态栏

- (void)setIsStatusBarHiden:(BOOL)isStatusBarHiden {
    
    _isStatusBarHiden = isStatusBarHiden;
    [self setNeedsStatusBarAppearanceUpdate];
}

-(BOOL)prefersStatusBarHidden {
    
    return self.isStatusBarHiden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark - 自定义屏幕旋转

- (BOOL)shouldAutorotate {
    if([self presentedViewController]){
        
        return [self presentedViewController].shouldAutorotate;
    }
    if(self.isLock){
        
        return NO;
    }else {
        
        return YES;
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if([self presentedViewController]){
        if(![[self presentedViewController] isKindOfClass:[UIAlertController class]]){
        
            return [self presentedViewController].supportedInterfaceOrientations;
        }else {
        
            return UIInterfaceOrientationMaskPortrait;
        }
        
    }
    
    if(self.isOfflineVideo)
    {
        return UIInterfaceOrientationMaskLandscape;
    }
    else
    {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
}

- (void)updateMaximumSizePlayerComponents{
    
    switch (self.coursePlayType) {
        case BXGCoursePlayTypeNone:
            break;
        case BXGCoursePlayTypeProCourse:
            break;
        case BXGCoursePlayTypeMiniCourse:
            break;
        case BXGCoursePlayTypeSampleCourse:
            [self updateTryPlayerComponents];
            break;
        case BXGCoursePlayTypeLocalCourse:
            break;
    }
    
    self.changeSizeBtn.condition = BXGPlayerChangeSizeTypeMaximum;
    self.playerLockBtn.hidden = false;
    self.contentView.hidden = true;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat multiplied;
    if(height > width){
        
        multiplied = width / height;
    }else {
        
        multiplied = height / width;
    }
    
    [self.mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(-0);
        make.bottom.offset(0);
//        make.height.equalTo(self.mediaView.mas_width).multipliedBy(multiplied);
    }];
    
    if(K_IS_IPHONE_X) {
        // 修改底部控制栏
        [self.componentFooterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.offset(0);
            make.height.offset(47 + kBottomHeight);
        }];
        
        // 修改左右宽度
        [self.componentHeaderContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(kStatusBarExtHeight);
            make.right.offset(-kStatusBarExtHeight);
            make.bottom.top.offset(0);
        }];
        
        [self.componentFooterContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(kStatusBarExtHeight);
            make.right.offset(-kStatusBarExtHeight);
            make.bottom.top.offset(0);
        }];
        
        [self.playerLockBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.offset(0);
            make.left.offset(15 + kStatusBarExtHeight);
            make.height.width.offset(45);
        }];
        
        [self.playerHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.height.offset(64);
        }];
    }
    
//    [self.mediaView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(0);
//        make.left.offset(0);
//        make.right.offset(0);
////        make.bottom.offset(0);
//        make.height.equalTo(self.mediaView.mas_width).multipliedBy(multiplied);
//    }];
    // 增加倍速和选集按钮
    [self.footerMoreView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(130);
        
    }];
}

- (void)updateMinimumSizePlayerComponents{
    
    switch (self.coursePlayType) {
        case BXGCoursePlayTypeNone:
            break;
        case BXGCoursePlayTypeProCourse:
            break;
        case BXGCoursePlayTypeMiniCourse:
            break;
        case BXGCoursePlayTypeSampleCourse:
            [self updateTryPlayerComponents];
            break;
        case BXGCoursePlayTypeLocalCourse:
            break;
    }
    
    self.changeSizeBtn.condition = BXGPlayerChangeSizeTypeMaximum;
    self.playerLockBtn.hidden = false;
    self.contentView.hidden = true;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat multiplied;
    if(height > width){
        
        multiplied = width / height;
    }else {
        
        multiplied = height / width;
    }
    
    
    [self.mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kStatusBarExtHeight);
        make.left.offset(0);
        make.right.offset(0);
        //        make.bottom.offset(0);
        make.height.equalTo(self.mediaView.mas_width).multipliedBy(multiplied);
    }];
    
    self.changeSizeBtn.condition = BXGPlayerChangeSizeTypeMinimum;
    if(!self.isLock) {
        
        self.playerLockBtn.hidden = true;
    }
    self.contentView.hidden = false;
    // 关闭侧边菜单
    [self closeLeftPopView];
    
    // 删除倍速和选集按钮
    [self.footerMoreView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(0);
    }];
    
    if(K_IS_IPHONE_X) {
        // 修改底部控制栏
        [self.componentFooterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.offset(0);
            make.height.offset(47);
        }];
        
        // 修改左右宽度
        [self.componentHeaderContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.offset(0);
            make.bottom.top.offset(0);
        }];
        
        [self.componentFooterContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.offset(-0);
            make.bottom.top.offset(0);
        }];
        
        // 锁定
        [self.playerLockBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.offset(0);
            make.left.offset(15);
            make.height.width.offset(45);
        }];
        
        [self.playerHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.height.offset(64);
        }];
    }
}

- (void)updateOfflinePlayerComponents{
    
    self.learnedBtn.hidden = true;
    self.headerDownloadBtn.hidden = true;

    self.changeSizeBtn.hidden = true;
    
    [self.footerMoreView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.offset(130);
    }];
    
    self.selectVideoBtn.enabled = false;

    [self.selectVideoBtn setTitle:@"本地" forState:UIControlStateNormal];
    [self.changeSizeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.offset(0);
    }];
    self.contentView.hidden = true;
    [self updateMaximumSizePlayerComponents];
}

- (void)updateTryPlayerComponents{
    
    self.learnedBtn.hidden = true;
    self.headerDownloadBtn.hidden = true;
    
//    self.changeSizeBtn.hidden = true;
    
    [self.footerMoreView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.offset(130);
    }];
    
    self.selectVideoBtn.enabled = false;
    
    [self.selectVideoBtn setTitle:@"试学" forState:UIControlStateNormal];
//    [self.changeSizeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//
//        make.width.offset(0);
//    }];
//    self.contentView.hidden = true;
    
}




- (void)catchDeviceOrientationChange{
    
    if([self presentedViewController]) {
        
        return;
    }
    
    if (self.playerView==nil){
        return;
    }
    if(self.isOfflineVideo){
    
        [self updateOfflinePlayerComponents];
        return;
    }

    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationUnknown:{
            
        }break;
            
        case UIInterfaceOrientationPortrait:{
            
            self.isMediaScreenFull = false;
            
        }break;
            
        case UIInterfaceOrientationLandscapeLeft:{
            switch (self.coursePlayType) {
                case BXGCoursePlayTypeNone:
                    break;
                case BXGCoursePlayTypeProCourse:
                    break;
                case BXGCoursePlayTypeMiniCourse:
                    break;
                case BXGCoursePlayTypeSampleCourse:
                    [self updateTryPlayerComponents];
                    break;
                case BXGCoursePlayTypeLocalCourse:
                    break;
            }
            self.isMediaScreenFull = true;
        }break;
            
        case UIInterfaceOrientationLandscapeRight:{
            switch (self.coursePlayType) {
                case BXGCoursePlayTypeNone:
                    break;
                case BXGCoursePlayTypeProCourse:
                    break;
                case BXGCoursePlayTypeMiniCourse:
                    break;
                case BXGCoursePlayTypeSampleCourse:
                    [self updateTryPlayerComponents];
                    break;
                case BXGCoursePlayTypeLocalCourse:
                    break;
            }
            self.isMediaScreenFull = true;
            
        }break;
            
        default:{
            
        }break;
            
    }
}

- (void)setIsMediaScreenFull:(BOOL)isMediaScreenFull {
    
    _isMediaScreenFull = isMediaScreenFull;
    if(isMediaScreenFull) {
        
        [self updateMaximumSizePlayerComponents];
    }else {
        
        [self updateMinimumSizePlayerComponents];
    }
}

#pragma mark - 公共方法

- (NSString *)formatSecondsToString:(NSInteger)seconds {
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

- (NSString *)stringFormCMTime:(CMTime)cmTime {
    
    float allSec = CMTimeGetSeconds(cmTime);
    NSInteger hour = (NSInteger)allSec / 60 / 60;
    NSInteger min = (NSInteger)allSec / 60;
    NSInteger sec = (NSInteger)allSec % 60;
    
    return [NSString stringWithFormat:@"%02zd:%02zd:%02zd",hour,min,sec];
}

- (double)currentVideoPlayedPercent;{
    
    double proSec = CMTimeGetSeconds([self.playerView.player currentTime]);
    double durSec =CMTimeGetSeconds(self.playerView.player.currentItem.duration);
    double startVideoRate = proSec / durSec;
    
    return startVideoRate;
}

- (void)saveHistoryWithVideoModel:(BXGCourseOutlineVideoModel *)videoModel isEnd:(BOOL)isEnd{
    
    if(!self.playerViewModel.courseModel){
    
        return;
    }
    
    double percent = 0;
    if(isEnd){
        
        percent = 1;
    }else {
        
        percent = [self currentVideoPlayedPercent];
    }
    
    
    if(videoModel) {
        
        [self.playerViewModel saveHistoryWithVideoModel:videoModel andPer:percent];
    }
    
    if(percent >= (2.0 / 3.0)){
        
        if(videoModel){
            
            videoModel.study_status = @1;
            [self.playerViewModel updateUserStudyStateWithIsLearning:false andVideoId:videoModel.idx andCourseId:self.playerViewModel.courseModel.course_id];
        }
    }else {
    
        if(videoModel){
            
            if([videoModel.study_status integerValue] != 1) {
            
                videoModel.study_status = @2;
            }
            [self.playerViewModel updateUserStudyStateWithIsLearning:true andVideoId:videoModel.idx andCourseId:self.playerViewModel.courseModel.course_id];
        }
    }
}

#pragma mark - 计时器

- (void)playerTimerIntervalOperation{
    
    float proSec = CMTimeGetSeconds([self.playerView.player currentTime]);
    float durSec =CMTimeGetSeconds(self.playerView.player.currentItem.duration);
    
    //当前播放
    float playebleDuration =  self.playerView.playableDuration;
    if (self.playerView.playing && proSec + 0.05 >= playebleDuration){
        
        // 缓冲中
        if(!self.bufferingView.animating){
            
            [self.bufferingView startAnimating];
        }
        
        
    }else {
        
        if(self.bufferingView.animating){
            
            [self.bufferingView stopAnimating];
        }
    }
    
    self.playerDurationLabel.text = [self formatSecondsToString:durSec];
    
    //进度条
    
    // 需要一个状态来表示 正在 Seeking
    if(!self.isSeeking) {
        
        self.playerCurrentTimeLabel.text = [self formatSecondsToString:proSec];
        self.playerSlider.value = (float) proSec / durSec;
    }else {
        
        self.hidePlayerComponentsDate = nil;
        self.hidePlayerComponentsDate = [NSDate new];
    }
    
    if(self.hidePlayerComponentsDate.timeIntervalSinceNow < - 4) {
        
        [self hidePlayerComponents:true];
    }
}

- (void)hidePlayerComponents:(BOOL)hide {
    
    if(self.componentView.hidden == hide) {
        
        [self.componentView mas_makeConstraints:^(MASConstraintMaker *make) {
           
        }];
        return;
    }
    
    if(hide) {
        
        if(K_IS_IPHONE_X){
            
        } else {
            self.isStatusBarHiden = true;
        }
//        self.isStatusBarHiden = false;
        self.componentView.hidden = true;
        
    }else {
        
        self.isStatusBarHiden = false;
        self.componentView.hidden = false;
    }
}


#pragma mark - Life Cycle

- (void)initailization {

    self.isLock = false;
    
    // set port
    BXGAppDelegate *appDelegate = (BXGAppDelegate *)[UIApplication sharedApplication].delegate;
    self.playerView.drmServerPort = appDelegate.drmServer.listenPort;
    
    self.playerView.timeoutSeconds = 10;
}

- (void)deallocOperation {
    
//    [self.playerView cancelRequestPlayInfo];
    [self.playerView resetPlayer];
    
    self.playerView.player = nil;
    self.playerView.item = nil;
    self.playerView.urlAsset = nil;
    self.playerView.playerLayer = nil;
    
    self.playerView = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageName = @"视频播放页";
    // 界面初始化
    [self installBaseUI];
    [self initailization];
//    switch (self.coursePlayType) {
//        case BXGCoursePlayTypeNone:
//            break;
//        case BXGCoursePlayTypeProCourse:
//            break;
//        case BXGCoursePlayTypeMiniCourse:
//            break;
//        case BXGCoursePlayTypeSampleCourse:
//            [self updateTryPlayerComponents];
//            break;
//        case BXGCoursePlayTypeLocalCourse:
//            break;
//    }
    if(self.isOfflineVideo) {
    
        
        [self operationPlayOfflineVideo];
    }
    
}
- (void)operationPlayOfflineVideo {

    [self updateOfflinePlayerComponents];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    

    [self playWithVideoModel:self.offlineVideoModel];
//    [self.player reset];
//    
//    self.player.videoId = self.offlineVideoId;
//    self.player.timeoutSeconds = 20;
//    self.player.failBlock = ^void (NSError *error){
//        NSLog(@"failBlock");
//    };
//    
//    [self.player setURL:[NSURL fileURLWithPath:self.offlineFilePath]];
//    
//    //[_playerView setVideoFillMode:AVLayerVideoGravityResizeAspectFill];
//    self.playerView.player = self.player;
//    self.player.delegate = self;
//    
//    [self.player play];
}

- (void)appWillEnterForegroundNotification{
    
    if (self.playerView.playing) {
        
        [self.playerView play];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self updateMinimumSizePlayerComponents];
//    [self.contentView removeFromSuperview];
//    self.contentView = nil;
//    [self.contentVC removeFromParentViewController];
//    self.contentVC = nil;
    
    
    
    self.playerHeaderView.hidden = true;
    // 当前播放视频
    BXGCourseOutlineVideoModel *videoModel = self.currentPlayVideoModel;
    if(videoModel.study_status.integerValue != 1){
        [self saveHistoryWithVideoModel:self.currentPlayVideoModel isEnd:false];
    }else {
        [self saveHistoryWithVideoModel:self.currentPlayVideoModel isEnd:true];
    }
    
    [self.playerView pause];
    [self uninstallObserver];
    
    [super viewWillDisappear:animated];
    
    if(self.navigationController) {
        self.navigationController.navigationBarHidden = NO;
    }
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    [self installTranslucentNavigationBar];
    if(K_IS_IPHONE_X) {
        self.navibackgroundView.backgroundColor = [UIColor blackColor];
    }
    
    self.playerHeaderView.hidden = false;
    // 隐藏导航栏
    if(self.navigationController) {
        
        self.navigationController.navigationBarHidden = true;
    }
    // 添加监听
    
    [self installObserver];
    
    
    
    
    // 设置播放器隐藏控件时间
    self.hidePlayerComponentsDate = [NSDate new];
    
    if(self.playerView) {
        
        [self.playerView play];
    }
    
}

- (void)dealloc {
    
    
    
    // 释放操作
    [self deallocOperation];
}

#pragma mark - Gernerate Data 生成静态数据

- (NSArray<NSDictionary *> *)playerSpeedSelectionArray {
    
    if(!_playerSpeedSelectionArray) {
        
        NSMutableArray *marr = [NSMutableArray new];
        NSArray *arr = @[@1.0,@1.25,@1.5,@1.75,@2.0];
        for(NSInteger i = 0; i < arr.count; i++) {
            
            ;
            NSDictionary *dict = @{@"desc":[[arr[i] description] stringByAppendingString:@"倍速"], @"value": arr[i]};
            [marr addObject:dict];
            
        }
        _playerSpeedSelectionArray = [marr copy];
    }
    return _playerSpeedSelectionArray;
}

- (NSArray<NSString *> *)playerVideoSelectionArray {
    
    if(!_playerVideoSelectionArray) {
        
        _playerVideoSelectionArray = @[@"1-Java 背景介绍",@"2-Java 入门程序的编写",@"3-环境配置",@"4-基本概念介绍",@"5-类型转化",@"6-Java 运算符的使用"];
    }
    
    return _playerVideoSelectionArray;
}

#pragma mark - InstallUI Frame

- (void)installBaseUI {
    
    UIView *mediaView = [UIView new];
    // 1.整体播放器封装UIView
    [self.view addSubview:mediaView];
    self.mediaView = mediaView;
    self.mediaView.backgroundColor = [UIColor whiteColor];
    
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat multiplied;
    if(height > width){
        
        multiplied = width / height;
    }else {
        
        multiplied = height / width;
    }
    
    [mediaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kStatusBarExtHeight);
        make.left.offset(0);
        make.right.offset(0);
        make.height.equalTo(mediaView.mas_width).multipliedBy(multiplied);
    }];
    
    // 2.蒙版层
    UIView *maskView = [self installMaskView];
    [mediaView addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    
    // 2.播放器PlayerView
    UIView *playerView = [self installPlayerView];
    
    [mediaView addSubview:playerView];
    
    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    
    maskView.backgroundColor = [UIColor clearColor];
    
    // 2.透明手势View
    UIView *gestureView = [self installGestureView];
    [mediaView addSubview:gestureView];
    [gestureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    
    UIView *componentView = [self installComponentView];
    self.componentView = componentView;
    [gestureView addSubview:componentView];
    [componentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    
    
    UIView *leftPopView = [self installLeftPopView];
    self.leftPopView = leftPopView;
    [mediaView addSubview:leftPopView];
    [leftPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
        // make.width.equalTo(leftPopView.mas_height).multipliedBy(453.0 / 750.0);
    }];
    
    [self installPlayerSelectSpeedTableView];
    [self installPlayerSelectVideoTableView];
    
//    self.view.backgroundColor = [UIColor blackColor];
    
    
    
    
#pragma mark 关联 Player contentView
    
    
    
    
//    self.contentView.frame = CGRectZero;
    UIView *contentView = self.contentView;
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(mediaView.mas_bottom);
        make.bottom.offset(-kBottomHeight);
    }];
    // 更新当前状态的布局样式
    [self updateMinimumSizePlayerComponents];
}

#pragma mark - InstallUI  SubViews

- (UIView *)installPlayerView {
//    
//    DWVideoPlayerView *playerView = [[DWVideoPlayerView alloc]initWithFrame:CGRectMake(0, 0, 300, 400)];
//
    
    BXGUserModel *userModel = [BXGUserDefaults share].userModel;
    
    NSString *ccUserId;
    NSString *ccKey;
    
    if(userModel) {
        
        ccUserId = userModel.cc_user_id;
        ccKey = userModel.cc_api_key;
    }
    DWPlayerView *playerView = [[DWPlayerView alloc]initWithUserId:ccUserId key:ccKey];
    playerView.delegate = self;
    playerView.frame = CGRectMake(0, 0, 300, 400);
    
        playerView.videoGravity = AVLayerVideoGravityResizeAspect;
        // [playerView setVideoFillMode:AVLayerVideoGravityResizeAspect];
    
        self.playerView = playerView;
        return playerView;
}

- (UIView *)installBufferingView {
    
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.bufferingView = aiView;
    [aiView startAnimating];
    return aiView;
}

- (UIView *)installGestureView {
    
    __weak typeof (self) weakSelf = self;
    RWResponseView *superView = [RWResponseView new];
    superView.touchesMovedBlock = ^(CGPoint point) {
        //得出手指在Button上移动的距离
        CGPoint panPoint = CGPointMake(point.x - weakSelf.startPoint.x, point.y - weakSelf.startPoint.y);
        //分析出用户滑动的方向
        if (weakSelf.direction == DirectionNone) {
            if (panPoint.x >= 30 || panPoint.x <= -30) {
                //进度
                weakSelf.direction = DirectionLeftOrRight;
            } else if (panPoint.y >= 30 || panPoint.y <= -30) {
                //音量和亮度
                weakSelf.direction = DirectionUpOrDown;
            }
        }
        
        if (weakSelf.direction == DirectionNone) {
            return;
        } else if (weakSelf.direction == DirectionUpOrDown) {
            //音量和亮度
            if (weakSelf.startPoint.x <= weakSelf.mediaView.frame.size.width / 2.0) {
                //调节亮度
                if (panPoint.y < 0) {
                    //增加亮度
                    [[UIScreen mainScreen] setBrightness:weakSelf.startVB + (-panPoint.y / 30.0 / 10)];
                } else {
                    //减少亮度
                    [[UIScreen mainScreen] setBrightness:weakSelf.startVB - (panPoint.y / 30.0 / 10)];
                }
            } else {
                //音量
                if (panPoint.y < 0) {
                    //增大音量
                    [weakSelf.volumeViewSlider setValue:weakSelf.startVB + (-panPoint.y / 30.0 / 10) animated:YES];
                    if (weakSelf.startVB + (-panPoint.y / 30 / 10) - weakSelf.volumeViewSlider.value >= 0.1) {
                        [weakSelf.volumeViewSlider setValue:0.1 animated:NO];
                        [weakSelf.volumeViewSlider setValue:weakSelf.startVB + (-panPoint.y / 30.0 / 10) animated:YES];
                        [weakSelf.volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                    } else {
                        //减少音量
                        [weakSelf.volumeViewSlider setValue:weakSelf.startVB - (panPoint.y / 30.0 / 10) animated:YES];
                        [weakSelf.volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
            }
        } else if (weakSelf.direction == DirectionLeftOrRight ) {
            //进度
            
            
            CGFloat rate = [weakSelf currentVideoPlayedPercent] + (panPoint.x / 30.0 / 80.0 / 1.2);
            if (rate > 1) {
                rate = 1;
            } else if (rate < 0) {
                rate = 0;
            }
            
            weakSelf.playerSeekTimeRate = rate;
            weakSelf.isPlayerDidSeekTime = true;
            [weakSelf startScrubbing];
            [weakSelf scrubbing:rate];
        }
    };
    
    superView.touchBeganBlock = ^(CGPoint point) {
        
        weakSelf.startPoint = point;
        //检测用户是触摸屏幕的左边还是右边，以此判断用户是要调节音量还是亮度，左边是亮度，右边是音量
        if (weakSelf.startPoint.x <= weakSelf.mediaView.frame.size.width / 2.0) {
            //亮度
            weakSelf.startVB = [UIScreen mainScreen].brightness;
        } else {
            //音/量
            weakSelf.startVB = weakSelf.volumeViewSlider.value;
        }
        //方向置为无
        weakSelf.direction = DirectionNone;
    };
    
    superView.touchesEndedBlock = ^(CGPoint point) {
        
        if(weakSelf.isPlayerDidSeekTime) {
        
            [weakSelf stopScrubbing:weakSelf.playerSeekTimeRate];
            weakSelf.isPlayerDidSeekTime = false;
        }
    };
    
    superView.responseBlock = ^(UIView *view) {
        
        weakSelf.hidePlayerComponentsDate = nil;
        weakSelf.hidePlayerComponentsDate = [NSDate new];
    };
    // superView.inter
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureView:)];
    
    [superView addGestureRecognizer:tapGesture];
    
    
    UIView *bufferingView = [self installBufferingView];
    [superView addSubview:bufferingView];
    [bufferingView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.offset(0);
        make.centerX.offset(0);
    }];
    self.gestrueView = superView;
    
    return superView;
}

- (UIView *)installLeftPopView{
    
    
    UIView *superView = [UIView new];
    //;
    
    UIView *maskView = [UIView new];
    UIView *popView = [UIView new];
    UILabel *titleLabel = [UILabel new];
    UIView *contentView = [UIView new];
    UIView *spView = [UIView new];
    
    [superView addSubview:popView];
    // [popView addGestureRecognizer:[UITapGestureRecognizer new]];
    [superView addSubview:maskView];
    [popView addSubview:contentView];
    [popView addSubview:spView];
    [popView addSubview:titleLabel];
    
    // pop
    [popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.right.offset(0);
        make.width.equalTo(superView.mas_height).multipliedBy(453.0 / 750.0);
    }];
    self.popView = popView;
    popView.backgroundColor = [UIColor colorWithHex:0x11161F alpha:0.9];
    // [UIColor colorWithHex:0x11161F alpha:0.9];
    
    
    
    
    // title Label
    self.leftPopViewTitleLabel = titleLabel;
    titleLabel.font = [UIFont bxg_fontSemiboldWithSize:13];
    titleLabel.textColor = [UIColor colorWithHex:0xcccccc];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.offset(0);
        make.height.offset(43);
        make.left.offset(15);
    }];
    
    // sp
    
    spView.backgroundColor = [UIColor colorWithHex:0xffffff];
    spView.alpha = 0.1;
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(titleLabel.mas_bottom).offset(0);
        make.left.equalTo(popView).offset(0);
        make.right.equalTo(popView).offset(0);
        make.height.offset(1);
    }];
    
    
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(spView.mas_bottom).offset(0);
        make.bottom.right.offset(0);
        make.left.offset(0);
    }];
    
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.offset(0);
        make.right.equalTo(popView.mas_left).offset(0);
    }];
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeLeftPopView)];
    [maskView addGestureRecognizer:tap];
    
    
    superView.hidden = true;
    
    
    self.popContentView = contentView;
    return superView;
}

- (void)installPlayerSelectSpeedTableView {
    
    __weak typeof (self) weakSelf = self;
    
    UIExtTableView *selectSpeedTableView = [UIExtTableView new];
    selectSpeedTableView.backgroundColor = [UIColor clearColor];
    selectSpeedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    selectSpeedTableView.rowHeight = 50;
    self.selectSpeedTableView = selectSpeedTableView;
    [selectSpeedTableView registerClass:[BXGSelectionCell class] forCellReuseIdentifier:@"BXGSelectionCell"];
    selectSpeedTableView.allowsSelection = true;
    [selectSpeedTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.1)]];
    
    
    selectSpeedTableView.numberOfRowsInSectionBlock = ^NSInteger(UITableView *tableView, NSInteger section) {
        
        // 倍速相关
        
        return weakSelf.playerSpeedSelectionArray.count;
        
    };
    selectSpeedTableView.cellForRowAtIndexPathBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        
        BXGSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGSelectionCell" forIndexPath:indexPath];
        
        
        NSDictionary *dict = weakSelf.playerSpeedSelectionArray[indexPath.row];
        
        cell.cellTitle = dict[@"desc"];
        
        //[weakSelf closeLeftPopView];
        return cell;
    };
    
    selectSpeedTableView.didSelectRowAtIndexPathBlock = ^(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
        weakSelf.currentSpeedIndex = indexPath.row;
        NSString *strEventId = nil;
        switch(weakSelf.currentSpeedIndex)
        {
            case 0:
                strEventId = spbf_bs1;
                break;
            case 1:
                strEventId = spbf_bs2;
                break;
            case 2:
                strEventId = spbf_bs3;
                break;
            case 3:
                strEventId = spbf_bs4;
                break;
            case 4:
                strEventId = spbf_bs5;
                break;
            default:
                break;
        }
        if(strEventId)
        {
           [[BXGBaiduStatistic share] statisticEventString:strEventId andParameter:nil];
        }
    };
}

- (void)setCurrentSpeedIndex:(NSInteger)currentSpeedIndex {
    
    _currentSpeedIndex = currentSpeedIndex;
    NSDictionary *dict = self.playerSpeedSelectionArray[_currentSpeedIndex];
    [self.playerView setPlayerRate:[dict[@"value"] doubleValue]];
    // self.player.player.rate = [dict[@"value"] doubleValue];
    [self.selectSpeedBtn setTitle:dict[@"desc"]forState:UIControlStateNormal];
}

- (void)installPlayerSelectVideoTableView {
    __weak typeof (self) weakSelf = self;
    
    UIExtTableView *selectVideoTableView = [UIExtTableView new];
    selectVideoTableView.backgroundColor = [UIColor clearColor];
    selectVideoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    selectVideoTableView.rowHeight = 50;
    self.selectVideoTableView = selectVideoTableView;
    [selectVideoTableView registerClass:[BXGSelectionVideoCell class] forCellReuseIdentifier:@"BXGSelectionVideoCell"];
    selectVideoTableView.allowsSelection = true;
    [selectVideoTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.1)]];
    
    
    selectVideoTableView.numberOfRowsInSectionBlock = ^NSInteger(UITableView *tableView, NSInteger section) {
        
        return weakSelf.currentPlayVideoModel.superPointModel.videos.count;
        
    };
    
    selectVideoTableView.cellForRowAtIndexPathBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        
        BXGSelectionVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGSelectionVideoCell" forIndexPath:indexPath];
        // 1.添加 视频Model
        BXGCourseOutlineVideoModel *videoModel = weakSelf.currentPlayVideoModel.superPointModel.videos[indexPath.row];
        
        if(videoModel == weakSelf.currentPlayVideoModel){
            
            cell.isArrow = true;
        }else {
            
            
            cell.isArrow = false;
        }
        // 2.判断是否相同的视频Model 点亮
        
        cell.model = videoModel;
        return cell;
    };
    
    selectVideoTableView.didSelectRowAtIndexPathBlock = ^(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
        
        BXGCourseOutlineVideoModel *videoModel = weakSelf.currentPlayVideoModel.superPointModel.videos[indexPath.row];
        [weakSelf playWithVideoModel:videoModel];
        [weakSelf closeLeftPopView];
    };
    
}

#pragma mark - Left Pop View
- (void)openLeftPopView:(UIView *)view andTitle:(NSString *)title{

    self.leftPopView.hidden = true;
    if(title){
        
        self.leftPopViewTitleLabel.text = title;
    }else {
        self.leftPopViewTitleLabel.text = @"";
    }
    
    [self.popContentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    
    CGAffineTransform transform = self.leftPopView.transform;
    self.leftPopView.transform = CGAffineTransformTranslate( transform, self.leftPopView.bounds.size.width, 0);
    self.leftPopView.hidden = false;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.leftPopView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)closeLeftPopView{
    
    if(!self.leftPopView.hidden) {
        
        self.leftPopView.transform = CGAffineTransformIdentity;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGAffineTransform transform = self.leftPopView.transform;
            self.leftPopView.transform = CGAffineTransformTranslate( transform, self.leftPopView.bounds.size.width, 0);
            
        } completion:^(BOOL finished) {
            self.leftPopView.hidden = true;
            [self.popContentView.subviews.lastObject removeFromSuperview];
        }];
    }
}

- (UIView *)installMaskView {
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"播放器-视频占位图"]];
    
    return imageView;
}

- (UIView *)installComponentView {
    
    UIView *superView = [UIView new];
    // - 播放器 头部控件
    UIView *headerView = [UIButton new];
    
    // 从button 改成 uiview
    UIView *headerBGView = [[BXGPlayerGradientView alloc]initWithType:BXGPlayerGradientViewTypeHeader];
    [headerView addSubview:headerBGView];
    [headerBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    headerBGView.userInteractionEnabled = true;
    
//    CAGradientLayer *headerViewGradientLayer = [CAGradientLayer layer];
//    headerViewGradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor];
//    headerViewGradientLayer.locations = @[@(0.1)];
//    headerViewGradientLayer.startPoint = CGPointMake(0, 0);
//    headerViewGradientLayer.endPoint = CGPointMake(0, 1);
//    headerViewGradientLayer.frame = CGRectMake(0, 0, 2000, 64);
//    [headerBGView.layer addSublayer:headerViewGradientLayer];
    
    UIView *headerContentView = [UIView new];
    self.playerHeaderView = headerView;
    self.componentHeaderContentView = headerContentView;
    [superView addSubview:headerView];
    [self.playerHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(64);
    }];
    [headerView addSubview:headerContentView];
    [headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
    
    UIButton *headerDownloadBtn = [UIButton new];
    [headerContentView addSubview:headerDownloadBtn];
    [headerDownloadBtn addTarget:self action:@selector(clickHeaderDownloadBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerDownloadBtn setImage:[UIImage imageNamed:@"导航栏-下载"] forState:UIControlStateNormal];
    // [headerDownloadBtn setImage:[UIImage imageNamed:@"播放器-下载"] forState:UIControlStateNormal];
    
    [headerDownloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.offset(10);
        make.right.offset(-15);
        make.height.width.offset(RWAutoFontSize(22));
    }];
    self.headerDownloadBtn = headerDownloadBtn;
    BXGLearnedBtn *learnedBtn = [BXGLearnedBtn buttonWithType:UIButtonTypeCustom];
    
    self.learnedBtn = learnedBtn;
    [headerContentView addSubview:learnedBtn];
    
    [learnedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.offset(10);
        make.right.equalTo(headerDownloadBtn.mas_left).offset(-15);
        make.width.offset(53);
        make.height.offset(22);
    }];
    
    [learnedBtn addTarget:self action:@selector(clickPlayerHeaderLearnedBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    BXGPlayerHeaderBackBtn *backBtn = [BXGPlayerHeaderBackBtn new];
    [headerContentView addSubview:backBtn];
    self.playerHeaderBackBtn = backBtn;
    [backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.btnTitle = @"";
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.offset(10);
        make.left.offset(6.95);
        //make.width.offset(100);
        make.height.equalTo(headerView);
        make.right.equalTo(learnedBtn.mas_left).offset(-15);
    }];
    
#pragma mark - 底部视图
    
    // - 播放器 底部控件
    UIButton *footerView = [UIButton new]; // 屏蔽到消息响应
    self.componentFooterView = footerView;
    [superView addSubview:footerView];
    CGFloat height = 47;
    
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(height);
    }];
    
    // 用于屏蔽交互
    [footerView addGestureRecognizer:[UITapGestureRecognizer new]];
    //[footerView addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    
    
    // - 底部视图背景层
    UIView *footerBGView = [[BXGPlayerGradientView alloc]initWithType:BXGPlayerGradientViewTypeFooter];
    
    [footerView addSubview:footerBGView];
    [footerBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.top.offset(0);
    }];
    
    UIView *footerContentView = [UIView new];
    self.componentFooterContentView = footerContentView;
    [footerView addSubview:footerContentView];
    [footerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
    
    
    BXGPlayerPlayBtn *playerPlayBtn = [BXGPlayerPlayBtn buttonWithType:UIButtonTypeCustom];
    self.playerPlayBtn = playerPlayBtn;
    [playerPlayBtn addTarget:self action:@selector(clickPlayerPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [footerContentView addSubview: playerPlayBtn];
    // [playerPlayBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    [playerPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(15);
        make.centerY.offset(4);
        make.width.height.offset(23);
    }];
    
    UILabel *currentTimeLabel = [UILabel new]; // 封装成一个独立显示Time的label  或者一个分类
    [footerContentView addSubview: currentTimeLabel];
    
    currentTimeLabel.font = [UIFont bxg_fontRegularWithSize:12];
    currentTimeLabel.text = @"00:00:20";
    currentTimeLabel.textColor = [UIColor whiteColor];
    currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    [currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(playerPlayBtn.mas_right).offset(10);
        make.height.offset(12 + 2);
        make.width.offset(32 + 2 + 17 + 5);
        make.centerY.equalTo(playerPlayBtn).offset(0);
        
    }];
    
    BXGPlayerChangeSizeBtn *changeSizeBtn = [BXGPlayerChangeSizeBtn buttonWithType:UIButtonTypeCustom];
    // [changeSizeBtn setImage:[UIImage imageNamed:@"全屏"] forState:UIControlStateNormal];
    
    self.changeSizeBtn = changeSizeBtn;
    
    [footerContentView addSubview: changeSizeBtn];
    [changeSizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-15);
        make.centerY.equalTo(playerPlayBtn).offset(0);
        make.width.height.offset(23);
    }];
    
    // [changeSizeBtn addTarget:self action:@selector(clickChangeSizeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [changeSizeBtn addTarget:self action:@selector(clickChangeSizeBtn:) forControlEvents:UIControlEventTouchDown];
    __weak typeof (self) weakSelf = self;
    
    
    
#pragma mark Install Slider
    
    // init
    RWSlider *playSlider = [RWSlider new];
    
    // response
    playSlider.touchDownBlock = ^(UISlider *sender, float value) {
        RWLog(@"------------touchDownBlock")
        // [weakSelf.player startScrubbing];
        //weakSelf.isSeeking = true;
        //[weakSelf pauseCurrentVideo];
        [weakSelf startScrubbing];
    };
//    playSlider.touchDownBlock = ^(UISlider *sender) {
//
//
//    };
    playSlider.touchUpBlock = ^(UISlider *sender, float value) {
        [weakSelf stopScrubbing:sender.value];
    };
//    playSlider.touchUpBlock = ^(UISlider *sender) {
//
//
//        RWLog(@"------------touchUpBlock")
//        //float durSec =CMTimeGetSeconds(weakSelf.player.player.currentItem.duration);
//        //GFloat time = sender.value * durSec;
//        [weakSelf stopScrubbing:sender.value];
////        [weakSelf scrubbing:sender.value];
////        [weakSelf scrubbing:sender.value:sender.value];
////         [weakSelf.player seekToTime:time];
////        [weakSelf playCurrentVideo];
////        weakSelf.isSeeking = false;
////        [weakSelf.player scrub:time];
////        [weakSelf.player stopScrubbing];
//    };
    
    playSlider.valueChangBlock = ^(UISlider *sender, float value) {
        RWLog(@"------------valueChangBlock")
        [weakSelf scrubbing:value];
        
        
//        float durSec =CMTimeGetSeconds(weakSelf.player.player.currentItem.duration);
//        
//        weakSelf.playerCurrentTimeLabel.text = [weakSelf formatSecondsToString:sender.value * durSec];
//        weakSelf.playerDurationLabel.text = [weakSelf formatSecondsToString:durSec];
    };
    
    // addsubview
    [footerContentView addSubview: playSlider];
    
    // config
    playSlider.minimumValue = 0.0f;
    playSlider.maximumValue = 1.0f;
    playSlider.value = 0.0f;
    playSlider.continuous = true;
    [playSlider setThumbImage:[UIImage imageNamed:@"视频进度滑块"] forState:UIControlStateNormal];
    playSlider.maximumTrackTintColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.5];
    playSlider.minimumTrackTintColor = [UIColor colorWithRed:56 / 256.0 green:173 / 256.0 blue:255 / 256.0 alpha:1];
    
    // interface
    self.playerSlider = playSlider;
    
    // layout
    [playSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(playerPlayBtn).offset(0);
        make.left.equalTo(currentTimeLabel.mas_right).offset(10);
    }];
    
#pragma mark Install Duration Label
    
    UILabel *durationTimeLabel = [UILabel new]; // 封装成一个独立显示Time的label  或者一个分类
    [footerContentView addSubview: durationTimeLabel];
    durationTimeLabel.font = [UIFont bxg_fontRegularWithSize:12];
    durationTimeLabel.text = @"00:00:00";
    durationTimeLabel.textColor = [UIColor whiteColor];
    self.playerDurationLabel = durationTimeLabel;
    self.playerCurrentTimeLabel = currentTimeLabel;
    durationTimeLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [durationTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.centerY.equalTo(playerPlayBtn).offset(0);
        make.height.offset(12 + 2);
        make.width.offset(32 + 2 + 17 + 5);
        
        make.left.equalTo(playSlider.mas_right).offset(10);

    }];
    
    
    UIView *footerMoreView = [UIView new];
    [footerContentView addSubview:footerMoreView];
    [footerMoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.offset(0);
        make.height.equalTo(footerView);
        make.centerY.equalTo(playerPlayBtn).offset(0);
        make.left.equalTo(durationTimeLabel.mas_right).offset(10);
        make.right.equalTo(changeSizeBtn.mas_left).offset(0);
    }];
    self.footerMoreView = footerMoreView;
    
    UIButton *selectSpeedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [footerMoreView addSubview: selectSpeedBtn];
    [selectSpeedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.centerY.equalTo(playerPlayBtn).offset(0);
        //make.width.lessThanOrEqualTo(@50);
    }];
    
    [selectSpeedBtn setTitle:@"1倍速" forState:UIControlStateNormal];
    selectSpeedBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:14];
    
    self.selectSpeedBtn = selectSpeedBtn;
    
    [selectSpeedBtn addTarget:self action:@selector(clickPlayerSpeedBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *selectVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [selectVideoBtn setTitle:@"选集" forState:UIControlStateNormal];
    selectVideoBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:14];
    
    [selectVideoBtn addTarget:self action:@selector(clickPlayerSelectVideoBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [footerMoreView addSubview: selectVideoBtn];
    [selectVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectSpeedBtn.mas_right);
        make.right.offset(-10);
        make.centerY.equalTo(playerPlayBtn).offset(0);
        make.width.equalTo(selectSpeedBtn);
        //make.width.lessThanOrEqualTo(@50);
    }];
    self.selectVideoBtn = selectVideoBtn;
    
    
    
    // 2.控件显示层
    // - header
    
    
    // - 前部控件
    
    
    // - 左部控件
    
    
    
    // - 右部控件
    
    
    // - 左侧 加锁按钮
    
    BXGPlayerLockBtn *playerLockBtn = [BXGPlayerLockBtn new];
    [superView addSubview:playerLockBtn];
    [playerLockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.offset(0);
        make.left.offset(15);
        make.height.width.offset(45);
    }];
    
    self.playerFooterView = footerView;
    self.playerLockBtn = playerLockBtn;
    self.playerLockBtn.hidden = true;
    [playerLockBtn addTarget:self action:@selector(clickPlayerLock:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    BXGPlayerBigPlayBtn *playerBigPlayBtn = [BXGPlayerBigPlayBtn new];
    self.playerBigPlayBtn = playerBigPlayBtn;
    [playerBigPlayBtn addTarget:self action:@selector(clickPlayerPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    [playerBigPlayBtn setImage:[UIImage imageNamed:@"播放-大"] forState:UIControlStateNormal];
    
    [superView addSubview:playerBigPlayBtn];
    
    
    
    [playerBigPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.offset(0);
        make.centerX.offset(0);
        make.height.width.offset(62);
    }];
    
    
    
    
    return superView;
}

#pragma mark - Player Operation

- (void)playCurrentVideo; {
    
    [self.playerView play];
    // 重新设置
    self.currentSpeedIndex = self.currentSpeedIndex;
}

- (void)pauseCurrentVideo; {
    
    [self.playerView pause];
}

- (void)cancle {
    
    [self.playerView pause];
    [self.playerView resetPlayer];
//    [self.playerView cancelRequestPlayInfo];
}

- (void)resumePlay{
    
}

- (void)playWithVideoModel:(BXGCourseOutlineVideoModel *)videoModel {
    
    /* --- 初始化参数 --- */
    
    static BOOL busy = false;
    __weak typeof (self) weakSelf = self;
    
    /* --- 防止多次重复点击 --- */
    
    if(busy) {
        
        return;
    }

    /* --- 更新控件状态 --- */
    
    // 播放器控件显示 / 刷新倒计时
    [weakSelf hidePlayerComponents:false];
    weakSelf.hidePlayerComponentsDate = [NSDate new];
    
    weakSelf.isSeeking = false;
    
    /* --- 同步学习进度 保存历史信息 --- */
    if(weakSelf.currentPlayVideoModel.study_status.integerValue != 1){
        [weakSelf saveHistoryWithVideoModel:weakSelf.currentPlayVideoModel isEnd:false];
    }else {
        [weakSelf saveHistoryWithVideoModel:weakSelf.currentPlayVideoModel isEnd:true];
    }
    
    [weakSelf.playerView pause];
    [weakSelf.playerView resetPlayer];
//    [weakSelf.playerView cancelRequestPlayInfo];
    /* --- 初始化播放器控件 --- */
    
    // 倍速相关初始化
    weakSelf.currentSpeedIndex = 0;
    [weakSelf.selectSpeedTableView reloadData];
    [weakSelf.selectSpeedTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:true scrollPosition:UITableViewScrollPositionTop];
    [weakSelf.selectSpeedBtn setTitle:@"1倍速" forState:UIControlStateNormal];
    weakSelf.playerHeaderBackBtn.btnTitle = videoModel.name;
    if(videoModel.study_status.integerValue == 1) {

        weakSelf.learnedBtn.condition = BXGLearnedTypeLearned;
    }else {
    
        weakSelf.learnedBtn.condition = BXGLearnedTypeNOLearned;
    }
    
   
    
    //0 为学习
    //1.已学习
    //2.学习中

    
    /* --- 安全判断--- */
    
    if(!videoModel) {

#warning  调用外部block
        // [[BXGHUDTool share] showLoadingHUDWithString:@"加载失败"];
        busy = false;
        return;
    }
    
    // 判断是否被锁定
    if((!videoModel.lock_status || [videoModel.lock_status integerValue] == 0) && !weakSelf.isOfflineVideo && _coursePlayType != BXGCoursePlayTypeSampleCourse){

        [[BXGHUDTool share] showHUDWithString:@"请到官网闯关测试后\n再学习本知识点"];
        busy = false;
        return;

    }
    
    /* --- 播放视频--- */
    weakSelf.playerView.timeoutSeconds = 10;
    if(!videoModel.video_id) {
    
        busy = false;
        [[BXGHUDTool share]showHUDWithString:@"请求视频失败"];
        return;
    }
    
    weakSelf.playerView.videoId = videoModel.video_id;
    weakSelf.playerView.failBlock = ^(NSError *error) {

        busy = false;
        [[BXGHUDTool share]showHUDWithString:@"请求视频失败"];
    };
    
    weakSelf.playerView.getPlayUrlsBlock = ^(NSDictionary *playUrls) {

        busy = false;
        NSNumber *status = [playUrls objectForKey:@"status"];

        if (status == nil || [status integerValue] != 0) {
            
            busy = false;
            RWLog(@"审核未通过");
            [[BXGHUDTool share]showHUDWithString:@"请求视频失败"];
            return;
        }

        // 判断是否是VR
        NSNumber *vrmode =[playUrls objectForKey:@"vrmode"];

        if (vrmode == nil || [vrmode integerValue] != 0) {
            [[BXGHUDTool share]showHUDWithString:@"请求视频失败"];
            busy = false;
            return;
        }

        // 获得最清晰的分辨率的URL
        NSArray *qualityArray = [playUrls objectForKey:@"qualities"];
        if(qualityArray == nil || qualityArray.count <= 0){

            [[BXGHUDTool share]showHUDWithString:@"请求视频失败"];
            busy = false;
            return;
        }
    /* --- 播放视频--- */

        weakSelf.currentPlayVideoModel = videoModel;
        NSString *videoId;
        NSString *courseId;
        if(videoModel){
        
            videoId = videoModel.idx;
        }
        if(weakSelf.playerViewModel.courseModel) {
        
            courseId = weakSelf.playerViewModel.courseModel.course_id;
        }
        
        if(videoId && courseId) {
        
            [weakSelf.playerViewModel updateUserStudyStateWithIsLearning:true andVideoId:videoId andCourseId:courseId];
        }
        
        if([videoModel.study_status integerValue] != 1) {
            
            videoModel.study_status = @2;
        }
        // videoModel.study_status = @(2);
        
        // 选集相关
        [weakSelf.selectVideoTableView reloadData];

        NSString *urlString = qualityArray.lastObject[@"playurl"];
         [weakSelf.playerView resetPlayer];
        
        
        if([BXGUserDefaults share].userModel.user_id){
            // [weakSelf.contentVC updateHighlightVideoModel:videoModel];
            [weakSelf.playerView setURL:[NSURL URLWithString:urlString] withCustomId:[BXGUserDefaults share].userModel.user_id];
            // sweakSelf.playerView.player =weakSelf.player;
            // weakSelf.player.delegate =weakSelf;
            //[weakSelf.playerView setSeekStartTime:0];
            [weakSelf.playerView scrub:0];
//            [weakSelf.playerView seekToTime:0];
            
            [weakSelf.playerView play];
        }
        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            
//            
//            
//            
////             [weakSelf.playerView setURL:[NSURL URLWithString:urlString]];
//            
//        });
        
        
    };
    
    // [self updateContentView];
    
    
    [self.contentVC updateHighlightVideoModel:videoModel];
    NSString *localPath;
    BOOL result = [[BXGResourceManager shareInstance] isDownloadFileExistInLocalByVideoIdx:videoModel.idx withReturnLocalPath:&localPath];

    if(result && localPath) {

        // 本地播放
        
        [self localVideoWith:localPath andVideoModel:videoModel];
    
    }else {
    
        // 在线播放
        busy = true;
        [weakSelf.bufferingView startAnimating];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
            [weakSelf.playerView startRequestPlayInfo];
        }); 
    }
}

- (void)localVideoWith:(NSString *)path andVideoModel:(BXGCourseOutlineVideoModel *)videoModel {
    
    __weak typeof (self) weakSelf = self;
    
        weakSelf.currentPlayVideoModel = videoModel;
    // 选集相关
    [weakSelf.selectVideoTableView reloadData];
//        [weakSelf.playerView seekToTime:0];
    [weakSelf.playerView scrub:0];
    
        weakSelf.playerHeaderBackBtn.btnTitle = videoModel.name;
    
    [weakSelf.playerView resetPlayer];
    
//     [weakSelf.playerView setURL:[NSURL fileURLWithPath:path] withCustomId:[BXGUserDefaults share].userModel.user_id];
     [weakSelf.playerView setURL:[NSURL fileURLWithPath:path] withCustomId:nil];
        // [weakSelf.playerView setURL:[NSURL fileURLWithPath:path]];
//        weakSelf.playerView.player = self.player;
//        weakSelf.player.delegate =self;
        [weakSelf.playerView play];

}

- (void)videoPlayer:(DWPlayerView *)playerView didFailWithError:(NSError *)error
{
    RWLog(@"error=%@", error.debugDescription);
}

#pragma mark - Response

- (void)clickPlayerPlayBtn:(UIButton *)sender {
    
    [[BXGBaiduStatistic share]statisticEventString:jybbf_21 andParameter:nil];
    if(self.playerView.playing) {
        
        if(self.playerView.player.currentItem && self.playerView.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            
            [self pauseCurrentVideo];
            
        }else {
            
            // [self cancle];
        }
        
    }else {
        
        if(self.playerView.player.currentItem && self.playerView.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            
            [self playCurrentVideo];
            
        }else {
            
            //[self play];
            
        }
    }
}

- (void)clickHeaderDownloadBtn:(UIButton *)sender {
    
    [[BXGBaiduStatistic share]statisticEventString:jybzsd_20 andParameter:nil];
    BXGCourseModel *courseModel = self.playerViewModel.courseModel;
    BXGCourseOutlinePointModel *pointModel = self.currentPlayVideoModel.superPointModel;
    BXGCourseOutlineVideoModel *videoModel = self.currentPlayVideoModel;
    
    if(!courseModel || !pointModel || !videoModel){
        
        NSLog(@"参数异常");
        return;
    }
    DWDownloadState state = [[BXGDownloader shareInstance] inquireDownlaodStateByVideoIdx:videoModel.idx];
    switch (state) {
        case DWDownloadStateNone: {
            
        }
        case DWDownloadStateSuspended: {
            
        }
        case DWDownloadStateFailed: {
            
            [[BXGDownloader shareInstance] startDownloadCourseModel:courseModel pointModel:pointModel withVideoModel:videoModel notifyBlock:nil];
            [[BXGHUDTool share]showHUDWithString:@"正在下载\n您可以在“我的-下载管理”\n页面查看"];
        }break;
        case DWDownloadStateReadying: {
            
            [[BXGHUDTool share]showHUDWithString:@"队列中\n您可以在“我的-下载管理”\n页面查看"];
            
        }break;
        case DWDownloadStateRunning: {
            
            [[BXGHUDTool share]showHUDWithString:@"正在下载中\n您可以在“我的-下载管理”\n页面查看"];
        }break;
            
        case DWDownloadStateCompleted: {
            
            [[BXGHUDTool share]showHUDWithString:@"已下载\n您可以在“我的-下载管理”\n页面查看"];
        }break;
        default:
            break;
    }
    
}

- (void)clickPlayerLock:(BXGPlayerLockBtn *)sender {
    
    if(self.isLock) {
        
        // 按钮状态
        sender.condition = BXGPlayerLockBtnTypeNoLocked;
        
        // 显示头部控件和底部控件
        
        self.playerFooterView.hidden = false;
        self.playerHeaderView.hidden = false;
        
        
    }else {
        
        // 隐藏按钮状态
        sender.condition = BXGPlayerLockBtnTypeLocked;
        
        // 头部控件和底部控件
    
        self.playerFooterView.hidden = true;
        self.playerHeaderView.hidden = true;
        
    }
    self.isLock = !self.isLock;
    
}

- (void)clickChangeSizeBtn:(UIButton *)sender {
    
    [[BXGBaiduStatistic share]statisticEventString:jybqp_23 andParameter:nil];
    if(self.isMediaScreenFull == true){
        
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        self.isMediaScreenFull = false;
    }else {
        
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
        self.isMediaScreenFull = true;
    }
    
}

- (void)tapGestureView:(UITapGestureRecognizer *)tap {

    if(self.componentView.hidden) {
        
        [self hidePlayerComponents:false];
        //        self.isStatusBarHiden = false;
        //        self.componentView.hidden = !self.componentView.hidden;
        
    }else {
        
        [self hidePlayerComponents:true];
        //        self.isStatusBarHiden = true;
        //        self.componentView.hidden = !self.componentView.hidden;
    }
}

- (void)clickPlayerSpeedBtn:(UIButton *)btn; {
    [[BXGBaiduStatistic share] statisticEventString:jybbs_25 andParameter:nil];
    [self openLeftPopView:self.selectSpeedTableView andTitle:@"倍速选择"];
}

- (void)clickPlayerSelectVideoBtn:(UIButton *)btn; {
    
    [[BXGBaiduStatistic share] statisticEventString:jybxj_26 andParameter:nil];
    [self openLeftPopView:self.selectVideoTableView andTitle:@"选集"];
}

- (void)clickPlayerHeaderLearnedBtn:(BXGLearnedBtn *)sender {
    
    [[BXGBaiduStatistic share]statisticEventString:jybxxgl_22 andParameter:nil];
    __weak typeof (self) weakSelf = self;
    if(!self.currentPlayVideoModel || self.currentPlayVideoModel.study_status.integerValue == BXGStudyStatusFinish){
        
        return;
    }
    else {
        
        BXGAlertController *alert = [BXGAlertController confirmWithTitle:@"标记为已学完" message:nil handler:^{
            
//            [weakSelf.playerViewModel updateUserStudyStateWithIsLearning:false andVideoId:weakSelf.currentPlayVideoModel.idx andCourseId:weakSelf.playerViewModel.courseModel.course_id];
        
            sender.condition = BXGLearnedTypeLearned;
            [weakSelf videoPlayerDidReachEndOperation];
        }];
        
        
        [weakSelf presentViewController:alert animated:true completion:nil];
    }
    
}

- (void)clickBackBtn:(UIButton *)sender {
    
    if(self.isMediaScreenFull){
        
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        self.isMediaScreenFull = false;
        
    }else {
        
        [self.navigationController popViewControllerAnimated:true];
    }
}
- (void)startScrubbing {
    
    [[BXGBaiduStatistic share]statisticEventString:jybkj_24 andParameter:nil];
    __weak typeof (self) weakSelf = self;
    [weakSelf.playerView startScrubbing];
    weakSelf.isSeeking = true;
    [weakSelf pauseCurrentVideo];
}


- (void)scrubbing:(double)value {
    __weak typeof (self) weakSelf = self;
    float durSec =CMTimeGetSeconds(weakSelf.playerView.player.currentItem.duration);
    float curSec =CMTimeGetSeconds(weakSelf.playerView.player.currentItem.currentTime);
    
    weakSelf.playerCurrentTimeLabel.text = [weakSelf formatSecondsToString:value * durSec];
    weakSelf.playerDurationLabel.text = [weakSelf formatSecondsToString:durSec];
    
    [self.playerSeekView currentTime:curSec andDurationTime:durSec andSeekTime:value * durSec];
    self.playerSlider.value = value;
}

- (BXGPlayerSeekView *)playerSeekView {
    
    if(!_playerSeekView) {
        
        _playerSeekView = [BXGPlayerSeekView new];
        [self.mediaView insertSubview:_playerSeekView belowSubview:self.gestrueView];
        [_playerSeekView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.offset(0);
        }];
        self.playerBigPlayBtn.hidden = true;
    }
    return _playerSeekView;
}

- (void)setPlayerSeekView:(BXGPlayerSeekView *)playerSeekView {
    
    if(playerSeekView == nil){
        
        if(_playerSeekView.superview){
            
            [_playerSeekView removeFromSuperview];
            self.playerBigPlayBtn.hidden = false;
        }
        _playerSeekView = nil;
    }
}

- (void)stopScrubbing:(double)value {
    
    __weak typeof (self) weakSelf = self;
    float durSec = CMTimeGetSeconds(weakSelf.playerView.player.currentItem.duration);
    CGFloat time = value * durSec;
//    [weakSelf.playerView seekToTime:time];
    [weakSelf.playerView scrub:time];
    [weakSelf playCurrentVideo];
    weakSelf.isSeeking = false;
    [weakSelf.playerView scrub:time];
    [weakSelf.playerView stopScrubbing];
    
    self.playerSeekView = nil;
}
#pragma mark - SDK Delegate

- (void)videoPlayerIsReadyToPlayVideo:(DWPlayerView *)videoPlayer {
    
    [self.bufferingView startAnimating];
    [[BXGHUDTool share] closeHUD];
    
    NSString *courseId = self.playerViewModel.courseModel.course_id;
    NSString *videoId = self.currentPlayVideoModel.idx;
    double percent = [[BXGHistoryTable new] seekPercentWithCourseId:courseId andVideoId:videoId];
    if(percent == 1) {
        
        percent = 0;
    }
    self.isSeeking = false;
    
    double durSec = CMTimeGetSeconds(self.playerView.player.currentItem.duration);
    double switchTime = percent * durSec;
    
    if(switchTime > 0 && switchTime <= durSec) {
        
//        [self.playerView seekToTime:switchTime];
        [self.playerView scrub:switchTime];
        self.trackingSeekPercent = 0;
    }

}

- (void)videoPlayerDidReachEnd:(DWPlayerView *)videoPlayer {
    if(self.isOfflineVideo){
        
        return;
    }
    
    [self videoPlayerDidReachEndOperation];
}

- (void)videoPlayerDidReachEndOperation {
    
    __weak typeof (self) weakSelf = self;

    if(self.currentPlayVideoModel) {
        
        [self saveHistoryWithVideoModel:self.currentPlayVideoModel isEnd:true];
    }
    
    // 是否是试学视频
    if(self.coursePlayType == BXGCoursePlayTypeSampleCourse) {
        // kBXGStatSamplePlayerProCourseEventTypeToastFillOrder
        BXGAlertController *alertVC = [BXGAlertController confirmWithTitle:@"恭喜您，试学结束，立即报名？" message:nil confirmHandler:^{
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatSamplePlayerProCourseEventTypeToastFillOrder andLabel:nil];
            if(self.contentVC.sampleVideoPlayDoneBlock) {
                self.contentVC.sampleVideoPlayDoneBlock();
            }
        } cancleHandler:^{
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatSamplePlayerProCourseEventTypeToastCancle andLabel:nil];
        }];
        [self presentViewController:alertVC animated:true completion:nil];
        return;
    }

    // 2.判断有没有下一个视频
    
    BXGCourseOutlineVideoModel *nextVideoModel = [weakSelf.playerViewModel nextVideoModel:self.currentPlayVideoModel];
    if(nextVideoModel){
    
        // 播放下一个视频
        [self playWithVideoModel:nextVideoModel];
        
    }else {
    
        // 寻找下一个点
        BXGCourseOutlinePointModel *pointModel = self.currentPlayVideoModel.superPointModel;
        BXGCourseOutlinePointModel *nextPointModel = [weakSelf.playerViewModel nextPointModel:pointModel];
        
        if(nextPointModel) {
        
            BXGAlertController *alertVC = [BXGAlertController confirmWithTitle:@"恭喜你顺利完成该知识点的学习,是否学习下一个知识点?" message:nil handler:^{
            
                // 播放下一个点的第一个视频
                BXGCourseOutlineVideoModel *videoModel = [weakSelf.playerViewModel firstVideoModel:nextPointModel];
                
                [weakSelf playWithVideoModel:videoModel];
            }];
           [self presentViewController:alertVC animated:true completion:nil];
            
        }else {
        
            NSString *msg;
            if(self.courseModel.type.integerValue == BXGCourseModelTypeProCourse) {
            
                msg= @"恭喜您学习完本节课程，请返回上页继续学习！";
            }else {
            
                msg = @"恭喜你顺利完成该课程!";
            }
            BXGAlertController *alertVC = [BXGAlertController tipWithTitle:msg message:nil confirmHandler:nil];
            [self presentViewController:alertVC animated:true completion:nil];
        }
    }
}

- (void)videoPlayer:(DWPlayerView *)videoPlayer timeDidChange:(CMTime)cmTime{
    //double curSec = CMTimeGetSeconds(self.player.player.currentItem.currentTime);
    //RWLog(@"%lf",curSec);
}

- (void)videoPlayer:(DWPlayerView *)videoPlayer loadedTimeRangeDidChange:(float)duration {
    double curSec = CMTimeGetSeconds(self.playerView.player.currentItem.currentTime);
//    RWLog(@"buf:%lf",curSec);
}

#pragma mark - 添加监听
- (void)uninstallObserver;{
    
    // 播放状态
    
    [self.playerView removeObserver:self forKeyPath:@"playing"];
    
    // 通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 计数器
    [self.playerTimer invalidate];
    self.playerTimer = nil;
    
    // 移除监听网络状态
    [BXGNotificationTool removeObserver:self];
}

- (void)installObserver;{
    
    // 计时器
    
    self.playerTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(playerTimerIntervalOperation) userInfo:nil repeats:true];
    
    [[NSRunLoop currentRunLoop] addTimer:_playerTimer forMode:NSRunLoopCommonModes];
    
    
    // 设备旋转
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(catchDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    [self.playerView addObserver:self forKeyPath:@"playing" options:NSKeyValueObservingOptionNew context:nil];
    
    // 监听网络状态
    [BXGNotificationTool addObserverForReachability:self];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(catchEnterForegroundNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(catchEnterBackgroundNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}

#pragma mark 添加监听 播放状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (object == self.playerView) {
            
            if ([keyPath isEqualToString:@"playing"]) {
                
                BOOL isPlaying =[[change objectForKey:@"new"] boolValue];
                
                //播放
                if (isPlaying) {
                    
                    self.isSeeking = false;
                    self.playerPlayBtn.condition = BXGPlayerPlayBtnTypePlaying;
                    self.playerBigPlayBtn.condition = BXGPlayerBigPlayBtnTypePlaying;
                    
                    
                }else{
                    //暂停
                    self.playerPlayBtn.condition = BXGPlayerPlayBtnTypeStop;
                    self.playerBigPlayBtn.condition = BXGPlayerBigPlayBtnTypeStop;
                    
                }
                
            }
            
        }
    });
}

- (void)catchEnterForegroundNotification:(NSNotification *)noti {
    
    if(self.playerView.playing){
        
        [self playCurrentVideo];
    }
}

- (void)catchEnterBackgroundNotification:(NSNotification *)noti {
    
    //[self playCurrentVideo];
}

#pragma mark - 检测网络状态
// 监听网络状态
-(void)catchRechbility:(BXGReachabilityStatus)status; {
    
    if(BXGReachabilityStatusReachabilityStatusNotReachable == status) {
        
        [[BXGHUDTool share]showHUDWithString:kBXGToastNonNetworkTip];
    }else {
        
        [self operationAllowCellularWatchOnceAlert:status allowBlock:nil];
    }
}

- (void)operationAllowCellularWatchOnceAlert:(BXGReachabilityStatus)status allowBlock:(void(^)())allowBlock{

    static BOOL busy = false;
    // 全局允许
    
    if(!busy && status == BXGReachabilityStatusReachabilityStatusReachableViaWWAN && ![BXGUserDefaults share].isAllowCellularWatch) {
        
        __weak typeof (self) weakSelf = self;
        busy = true;
        // isAllowCellularWatchOnce
        
        BXGAlertController *vc = [BXGAlertController confirmWithTitle:@"你正在使用3G/4G网络观看视频，是否继续？" message:nil confirmHandler:^{
            
            [BXGUserDefaults share].isAllowCellularWatch = true;
            
            busy = false;
            if(allowBlock){
                
                allowBlock();
            }
            
        } cancleHandler:^{
            
            [weakSelf.navigationController popViewControllerAnimated:true];
            busy = false;
            
        }];
        
        [weakSelf presentViewController:vc animated:true completion:nil];
    }else {
    
        if(allowBlock) {
        
            allowBlock();
        }
    }
}

#pragma mark - View
- (UISlider *)volumeViewSlider {
    
    if(_volumeViewSlider == nil) {
        
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        _volumeViewSlider = nil;
        for (UIView *view in [volumeView subviews])
        {
            if ([view.class.description isEqualToString:@"MPVolumeSlider"])
            {
                _volumeViewSlider = (UISlider *)view;
                break;
            }
        }
        if(_volumeViewSlider!=nil)
        {
            //systemVolume = _volumeViewSlider.value;
            // changingVolume = systemVolume;
        }
    }
    return _volumeViewSlider;
}
#pragma mark - Player

@end
