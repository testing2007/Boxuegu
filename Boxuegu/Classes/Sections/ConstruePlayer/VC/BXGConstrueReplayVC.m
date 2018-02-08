//
//  BXGConstrueReplayVC.m
//  Boxuegu
//
//  Created by wurenying on 2018/1/15.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGConstrueReplayVC.h"

#import "BXGPlayerManager.h"

#import "BXGPlayerHeaderBackBtn.h"
#import "BXGPlayerGradientView.h"

#import "BXGPlayerPlayBtn.h"
#import "BXGPlayerBigPlayBtn.h"

#import "BXGPlayerChangeSizeBtn.h"
#import "RWSlider.h"

#import "BXGPlayerSelectSpeedCell.h"
#import "BXGPlayerSelectSpeedView.h"

#import "BXGPlayerSelectVideoCell.h"
#import "BXGPlayerSelectVideoView.h"

#import "BXGConstrueLiveViewModel.h"
#import "BXGConstrueReplayModel.h"
#import "BXGPlayerSeekView.h"

#import "BXGPlayerManager.h"
#import <MediaPlayer/MediaPlayer.h>

#import "BXGPlayerLockBtn.h"
#import "BXGVODPlayerGestrueView.h"
#import "BXGPlayerSeekView.h"

#import "BXGPlayerVolumeManager.h"
#import "BXGPlayerBrightnessManager.h"

#import "BXGPlayerView.h"

#import "BXGVODPlayBackPlayerView.h"
#import "BXGPlayerListManager.h"
#import "BXGSelectionVideoCell.h"

@interface BXGConstrueReplayVC () <BXGPlayerManagerDelegate, BXGPlayerListManagerDelegate, UITableViewDataSource, UITableViewDelegate, BXGNotificationDelegate, BXGPlayerViewDelegate>

@property (nonatomic, strong) BXGConstrueLiveViewModel *viewModel;
@property (nonatomic, strong) BXGPlayerManager *playerManager;
@property (nonatomic, strong) BXGPlayerListManager *playerListManager;


@property (nonatomic, strong) NSArray<BXGConstrueReplayModel *> *modelArray;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isLock;
@property (nonatomic, assign) BOOL isStatusBarHidden;
// UI
@property (nonatomic, strong) BXGVODPlayBackPlayerView *playerView;
@property (nonatomic, strong) UIView *componentView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) BXGPlayerHeaderBackBtn *headerBackBtn;
@property (nonatomic, strong) BXGPlayerPlayBtn *smallPlayBtn;
@property (nonatomic, strong) BXGPlayerBigPlayBtn *bigPlayBtn;
@property (nonatomic, strong) BXGPlayerLockBtn *lockBtn;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) RWSlider *playSlider;
@property (nonatomic, strong) UIButton *selectSpeedBtn;
@property (nonatomic, strong) UIButton *selectVideoBtn;
@property (nonatomic, strong) UILabel *durationTimeLabel;
@property (nonatomic, strong) UIButton *popMaskView;
@property (nonatomic, strong) BXGPlayerSelectVideoView *selectVideoView;
@property (nonatomic, strong) BXGPlayerSelectSpeedView *selectSpeedView;


@end

@implementation BXGConstrueReplayVC

#pragma mark - init

- (void)dealloc {
    
}

- (instancetype)initWithPlanId:(NSString *)planId {
    
    self = [super init];
    
    if(self) {
        
        _planId = planId;
    }
    return self;
}

- (BXGPlayerBigPlayBtn *)bigPlayBtn {
    
    if(_bigPlayBtn == nil) {
        
        _bigPlayBtn = [UIView new];
//        [_bigPlayBtn addTarget:self action:@selector(onClickPlayBtn:) forControlEvents:UIControlEventTouchDown];
    }
    return _bigPlayBtn;
}

#pragma mark - getter setter

- (void)setIsStatusBarHidden:(BOOL)isStatusBarHidden {
    _isStatusBarHidden = isStatusBarHidden;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BXGPlayerLockBtn *)lockBtn {
    
    if(_lockBtn == nil) {
        
        _lockBtn = [BXGPlayerLockBtn new];
        [_lockBtn addTarget:self action:@selector(onClickLockBtn:) forControlEvents:UIControlEventTouchDown];
    }
    return _lockBtn;
}

- (BXGPlayerManager *)playerManager {
    
    if(_playerManager == nil) {
        
        _playerManager = [BXGPlayerManager share];
        
    }
    return _playerManager;
}

- (BXGConstrueLiveViewModel *)viewModel {
    
    if(_viewModel == nil) {
        
        _viewModel = [BXGConstrueLiveViewModel new]; ;
    }
    return _viewModel;
}

#pragma mark - load data

- (void)loadData {
    Weak(weakSelf);
    
    [[BXGHUDTool share] showLoadingHUDWithString:nil];
    
    // 首先判断当前网络状态  继续 / 弹出去
    [self.viewModel loadConstrueReplayListWithPlanId:self.planId Finished:^(NSArray<BXGConstrueReplayModel *> *modelArray, NSString *msg) {
        weakSelf.modelArray = modelArray;
        
        [[BXGHUDTool share] closeHUD];
        if(!modelArray) {
            [[BXGHUDTool share] showHUDWithString:kBXGToastLodingError];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[BXGHUDTool share] closeHUD];
                [weakSelf dismissViewControllerAnimated:true completion:nil];
            });
            return;
        }else {
            
            // 获取直播间名字
            if(modelArray.firstObject) {
                weakSelf.headerBackBtn.btnTitle = modelArray.firstObject.name;
            }
            
            NSMutableArray *vodVideoModelArray = [NSMutableArray new];
            for (NSInteger i = 0; i < modelArray.count; i++) {
                BXGVODPlayerVideoModel *videoModel = [BXGVODPlayerVideoModel new];
                videoModel.idx = [NSString stringWithFormat:@"%@%zd",@([NSDate new].timeIntervalSinceNow).stringValue,i];
                videoModel.name = modelArray[i].name;
                videoModel.resourceId = modelArray[i].recordVideoId;
                [vodVideoModelArray addObject:videoModel];
            }
            
            [weakSelf.playerListManager playWithVideoList:vodVideoModelArray.copy andPlay:true];
            // 播放第一个视频
            //        [weakSelf.playerManager playWithVideoId:modelArray.firstObject.recordVideoId];
        }
    }];
}

- (BXGPlayerListManager *)playerListManager {
    
    if(_playerListManager == nil) {
        
        _playerListManager = [BXGPlayerListManager new];
        _playerListManager.delegate = self;
    }
    return _playerListManager;
}

- (BXGVODPlayBackPlayerView *)playerView {
    
    if(_playerView == nil) {
        
        _playerView = [BXGVODPlayBackPlayerView new];
        _playerView.componentsView = self.componentView;
        [_playerView installUI];
    }
    return _playerView;
}

- (UIView *)componentView {
    
    if(_componentView == nil) {
        
        _componentView = [UIView new];
        
        UIView *headerView = self.headerView;
        UIView *footerView = self.footerView;
        UIView *lockBtn = self.lockBtn;
        UIView *bigPlayBtn = self.bigPlayBtn;
        
        [_componentView addSubview:headerView];
        [_componentView addSubview:footerView];
        [_componentView addSubview:lockBtn];
        [_componentView addSubview:bigPlayBtn];

        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
            make.height.offset(64);
        }];
        
        [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.offset(0);
            if(K_IS_IPHONE_X){
                make.height.offset(47 + K_BOTTOM_SAFE_OFFSET);
            }else {
                make.height.offset(47);
            }
        }];
        
        [lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            if(K_IS_IPHONE_X) {
                make.left.offset(15 + K_STATUS_BAR_OFFSET);
            }else {
                make.left.offset(15);
            }
            make.height.width.offset(45);
        }];
        
        [bigPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.offset(0);
            make.centerX.offset(0);
            make.height.width.offset(62);
        }];
    }
    return _componentView;
}

- (UIView *)headerView {
    
    if(_headerView == nil) {
        
        _headerView = [UIView new];
        BXGPlayerGradientView *bgView = [[BXGPlayerGradientView alloc]initWithType:BXGPlayerGradientViewTypeHeader];
        BXGPlayerHeaderBackBtn *backBtn = self.headerBackBtn;
        
        [_headerView addSubview:bgView];
        [_headerView addSubview:backBtn];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.offset(0);
        }];
        
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(K_IS_IPHONE_X) {
                make.left.offset(15 + K_STATUS_BAR_OFFSET);
            }else {
                make.left.offset(15);
            }
            make.top.bottom.offset(0);
            make.width.lessThanOrEqualTo(_headerView).multipliedBy(0.5);
        }];
    }
    return _headerView;
}

- (BXGPlayerHeaderBackBtn *)headerBackBtn {
    
    if(_headerBackBtn == nil) {
        
        _headerBackBtn = [BXGPlayerHeaderBackBtn new];
        [_headerBackBtn addTarget:self action:@selector(onClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerBackBtn;
}

- (UIView *)footerView {
    
    if(_footerView == nil) {
        
        _footerView = [UIButton new];
        
        BXGPlayerGradientView *bgView = [[BXGPlayerGradientView alloc]initWithType:BXGPlayerGradientViewTypeFooter];
        BXGPlayerPlayBtn *smallPlayBtn = self.smallPlayBtn;
        UILabel *currentTimeLabel = self.currentTimeLabel;
//        BXGPlayerChangeSizeBtn *changeSizeBtn = self.changeSizeBtn;
        RWSlider *playSlider = self.playSlider;
        UIButton *selectSpeedBtn = self.selectSpeedBtn;
        UIButton *selectVideoBtn = self.selectVideoBtn;
        UILabel *durationTimeLabel = self.durationTimeLabel;
        
        [_footerView addSubview:bgView];
//        [_footerView addSubview:changeSizeBtn];
        [_footerView addSubview:playSlider];
        [_footerView addSubview:selectSpeedBtn];
        [_footerView addSubview:selectVideoBtn];
        [_footerView addSubview:smallPlayBtn];
        [_footerView addSubview:currentTimeLabel];
        [_footerView addSubview:durationTimeLabel];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.top.bottom.offset(0);
        }];
        
        
        [smallPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if(K_IS_IPHONE_X) {
                make.left.offset(15 + K_STATUS_BAR_OFFSET);
                make.centerY.offset(4 - K_BOTTOM_SAFE_OFFSET * 0.5);
            }else {
                make.left.offset(15);
                make.centerY.offset(4);
            }
            
            make.width.height.offset(23);
        }];
        
        [currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(smallPlayBtn.mas_right).offset(10);
            make.height.offset(12 + 2);
            make.width.offset(32 + 2 + 17 + 5);
            make.centerY.equalTo(smallPlayBtn).offset(0);
        }];
        
        [playSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(smallPlayBtn).offset(0);
            make.left.equalTo(currentTimeLabel.mas_right).offset(10);
        }];
        
        [durationTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.centerY.equalTo(smallPlayBtn).offset(0);
            make.height.offset(12 + 2);
            make.width.offset(32 + 2 + 17 + 5);
            
            make.left.equalTo(playSlider.mas_right).offset(10);
        }];
        
        [selectSpeedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(durationTimeLabel.mas_right).offset(10);
            make.centerY.equalTo(smallPlayBtn).offset(0);
            make.width.offset(70);
        }];
        
        [selectVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(selectSpeedBtn.mas_right).offset(10);
            if(K_IS_IPHONE_X) {
                make.right.offset(-15 - K_STATUS_BAR_OFFSET);
            }else {
                make.right.offset(-15);
            }
            make.centerY.equalTo(selectSpeedBtn).offset(0);
            make.width.offset(50);
        }];
    }
    return _footerView;
}

- (RWSlider *)playSlider {
    
    Weak(weakSelf);
    if(_playSlider == nil) {
        
        // init
        _playSlider = [RWSlider new];
    
        // config
        _playSlider.minimumValue = 0.0f;
        _playSlider.maximumValue = 1.0f;
        _playSlider.value = 0.0f;
        _playSlider.continuous = true;
        [_playSlider setThumbImage:[UIImage imageNamed:@"视频进度滑块"] forState:UIControlStateNormal];
        _playSlider.maximumTrackTintColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.5];
        _playSlider.minimumTrackTintColor = [UIColor colorWithRed:56 / 256.0 green:173 / 256.0 blue:255 / 256.0 alpha:1];
        
        // response
        _playSlider.touchDownBlock = ^(UISlider *sender, float value) {
            RWLog(@"down %lf",value);
            weakSelf.playerView.gestrueView.userInteractionEnabled = false;
            [weakSelf.playerManager startSeekTime:weakSelf.playerManager.currentTime];
        };
        _playSlider.valueChangBlock = ^(UISlider *sender, float value) {
            RWLog(@"change %lf",value);
            weakSelf.playerView.gestrueView.userInteractionEnabled = false;
            [weakSelf.playerManager seekingTime:weakSelf.playerManager.durationTime * value];
        };
        _playSlider.touchUpBlock = ^(UISlider *sender, float value) {
            RWLog(@"up %lf",value);
            weakSelf.playerView.gestrueView.userInteractionEnabled = true;
            [weakSelf.playerManager endSeekTime:weakSelf.playerManager.durationTime * value];
        };
    }
    return _playSlider;
}

- (UIButton *)selectSpeedBtn {
    
    if(_selectSpeedBtn == nil) {
        
        _selectSpeedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectSpeedBtn setTitle:@"1.00倍速" forState:UIControlStateNormal];
        _selectSpeedBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:14];
        [_selectSpeedBtn addTarget:self action:@selector(onClickPlayerSelectSpeedBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectSpeedBtn;
}

- (UIButton *)selectVideoBtn {
    
    if(_selectVideoBtn == nil) {
        
        _selectVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectVideoBtn setTitle:@"选集" forState:UIControlStateNormal];
        _selectVideoBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:14];
        [_selectVideoBtn addTarget:self action:@selector(onClickPlayerSelectVideoBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectVideoBtn;
}

- (UILabel *)durationTimeLabel {
    
    if(_durationTimeLabel == nil) {
        
        _durationTimeLabel = [UILabel new];
        _durationTimeLabel.font = [UIFont bxg_fontRegularWithSize:12];
        _durationTimeLabel.text = @"00:00:00";
        _durationTimeLabel.textColor = [UIColor whiteColor];
        _durationTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _durationTimeLabel;
}

- (UILabel *)currentTimeLabel {
    
    if(_currentTimeLabel == nil) {
        
        _currentTimeLabel = [UILabel new];
        _currentTimeLabel.font = [UIFont bxg_fontRegularWithSize:12];
        _currentTimeLabel.text = @"00:00:00";
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (BXGPlayerPlayBtn *)smallPlayBtn {
    
    if(_smallPlayBtn == nil) {
        
        _smallPlayBtn = [BXGPlayerPlayBtn buttonWithType:UIButtonTypeCustom];
        [_smallPlayBtn addTarget:self action:@selector(onClickPlayBtn:) forControlEvents:UIControlEventTouchDown];
    }
    return _smallPlayBtn;
}

- (UIButton *)popMaskView {
    
    if(_popMaskView == nil) {
        
        _popMaskView = [UIButton new];
        [_popMaskView addTarget:self action:@selector(onClickPopMaskView:) forControlEvents:UIControlEventTouchDown];
    }
    return _popMaskView;
}

- (BXGPlayerSelectSpeedView *)selectSpeedView {
    
    if(_selectSpeedView == nil) {
        
        _selectSpeedView = [BXGPlayerSelectSpeedView new];
//        _selectSpeedView.backgroundColor = [UIColor colorWithHex:0xf500f5];
    }
    return _selectSpeedView;
}

- (BXGPlayerSelectVideoView *)selectVideoView {
    
    if(_selectVideoView == nil) {
        
        _selectVideoView = [BXGPlayerSelectVideoView new];
        _selectVideoView.delegate = self;
        _selectVideoView.dataSource = self;
    }
    return _selectVideoView;
}

- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;

    if(_isPlaying) {
        self.smallPlayBtn.condition = BXGPlayerPlayBtnTypePlaying;
    }else {
        self.smallPlayBtn.condition = BXGPlayerPlayBtnTypeStop;
    }
    
    
}

#pragma mark - Response

// * components view

- (void)onClickChangeSizeBtn:(UIButton *)sender {
    
}

- (void)onClickPlayerSpeedBtn:(UIButton *)sender {
    
}

- (void)onClickPlayBtn:(UIButton *)sender {
    Weak(weakSelf);
    if([self.playerManager playing]) {
        [self.playerManager pause];
        
    }else {
        [self.playerManager play];
    }
}

- (void)onClickLockBtn:(UIButton *)sender {
    
    self.isLock = !self.isLock;
    
    if(self.isLock) {
        
        self.lockBtn.condition = BXGPlayerLockBtnTypeLocked;
        self.headerView.hidden = true;
        self.footerView.hidden = true;
        self.bigPlayBtn.hidden = true;
    }else {
        
        self.lockBtn.condition = BXGPlayerLockBtnTypeNoLocked;
        self.headerView.hidden = false;
        self.footerView.hidden = false;
        self.bigPlayBtn.hidden = false;
    }
    
}

- (void)onClickPopMaskView:(UIButton *)sender {
    
    [self closePopMaskView];
}

- (void)closePopMaskView {
    // 移除
    if(self.selectSpeedView.superview) {
        [self.selectSpeedView removeFromSuperview];
        self.selectSpeedView = nil;
    }
    
    if(self.selectVideoView.superview) {
        [self.selectVideoView removeFromSuperview];
        self.selectVideoView = nil;
    }
    
    if(self.popMaskView.superview) {
        [self.popMaskView removeFromSuperview];
        self.popMaskView = nil;
    }
}

- (void)onClickPlayerSelectVideoBtn:(UIButton *)sender {

    Weak(weakSelf);
    
    // 清理 pop mask View
    UIView *popMaskView = self.popMaskView;
    BXGPlayerSelectVideoView *selectVideoView = self.selectVideoView;
    
    NSMutableArray<NSString *> *titleArray = [NSMutableArray new];
//    for (NSInteger i = 0; i < self.modelArray.count; i++) {
//
//        BXGConstrueReplayModel *model = self.modelArray[i];
//        if(model.name && model.name.length > 0) {
//
//        }else {
//            model.name = @" ";
//        }
//        [titleArray addObject:model.name];
//    }
    
    for (NSInteger i = 0; i < self.playerListManager.videos.count; i++) {
        
        BXGVODPlayerVideoModel *model = self.playerListManager.videos[i];
        if(model.name && model.name.length > 0) {
            
        }else {
            model.name = @" ";
        }
        [titleArray addObject:model.name];
    }
    
    selectVideoView.didSelectedBlock = ^(NSInteger index) {
        [weakSelf.playerListManager playOnListWithIndex:index];
    };
    
    selectVideoView.titleArray = titleArray.copy;
    [self.componentView addSubview:popMaskView];
    [self.componentView addSubview:selectVideoView];
    
    [popMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
    
    [selectVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.width.offset(227);
        make.right.offset(227);
    }];
    
    [self.componentView layoutIfNeeded];
    
    [selectVideoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.componentView layoutIfNeeded];
    }];
    
    [selectVideoView.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.playerListManager.currentIndex inSection:0] animated:false scrollPosition:UITableViewScrollPositionBottom];
}

- (void)onClickPlayerSelectSpeedBtn:(UIButton *)sender {
    
    // 清理 pop mask View
    UIView *popMaskView = self.popMaskView;
    BXGPlayerSelectSpeedView *selectSpeedView = self.selectSpeedView;
    
    [self.componentView addSubview:popMaskView];
    [self.componentView addSubview:selectSpeedView];
    
    [popMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
    
    [selectSpeedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.width.offset(227);
        make.right.offset(227);
    }];
    
    [self.componentView layoutIfNeeded];
    
    [selectSpeedView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.componentView layoutIfNeeded];
    }];
}

- (void)onClickBackBtn {
    
//    [self.navigationController popViewControllerAnimated:true];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)installUI {
    
    UIView *maskView = [UIView new];
    maskView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];

    [self.view addSubview:self.playerView];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.offset(0);
    }];
    
    [self.view layoutIfNeeded];
}

#pragma mark - Left Pop View

- (void)popSelectSpeedView {
    
}

- (void)openLeftPopView:(UIView *)view andTitle:(NSString *)title{
    
//    self.leftPopView.hidden = true;
//    if(title){
//
//        self.leftPopViewTitleLabel.text = title;
//    }else {
//        self.leftPopViewTitleLabel.text = @"";
//    }
//
//    [self.popContentView addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.offset(0);
//    }];
//
//    CGAffineTransform transform = self.leftPopView.transform;
//    self.leftPopView.transform = CGAffineTransformTranslate( transform, self.leftPopView.bounds.size.width, 0);
//    self.leftPopView.hidden = false;
//
//    [UIView animateWithDuration:0.3 animations:^{
//
//        self.leftPopView.transform = CGAffineTransformIdentity;
//    } completion:^(BOOL finished) {
//
//    }];
}

- (void)closeLeftPopView{
    
//    if(!self.leftPopView.hidden) {
//
//        self.leftPopView.transform = CGAffineTransformIdentity;
//
//        [UIView animateWithDuration:0.3 animations:^{
//
//            CGAffineTransform transform = self.leftPopView.transform;
//            self.leftPopView.transform = CGAffineTransformTranslate( transform, self.leftPopView.bounds.size.width, 0);
//
//        } completion:^(BOOL finished) {
//            self.leftPopView.hidden = true;
//            [self.popContentView.subviews.lastObject removeFromSuperview];
//        }];
//    }
}


#pragma mark - Rotate

- (BOOL)shouldAutorotate {
    
    if(self.isLock) {
        return false;
    }else {
        return true;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
 
    Weak(weakSelf);
    
    [self installUI];
    [self playerListManager];
    [self playerManager];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BXGReachabilityStatus status = [BXGNetWorkTool sharedTool].getReachState;
        
        if([self allowCellularWatchAlert:status confirmHandler:^{
            [weakSelf loadData];
        } cancleHandler:^{
            
        }]) {
            // 允许时
            [weakSelf loadData];
        }
    });
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:false];
    [self uninstallObservers];
    [self.playerManager removeDelegate:self];
    [self.playerManager releasePlayer];
    [self.playerListManager uninstall];
    self.playerListManager = nil;
    [self.playerView removeFromSuperview];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true];
    [self installObservers];
    [self.playerManager addDelegate:self];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
}

//- (UIView *)playerView {
//
//    if(_playerView == nil) {
//
//        _playerView = [UIView new];
//        _playerView.backgroundColor = [UIColor grayColor];
//    }
//    return _playerView;
//}

#pragma mark - Observers

- (void)installObservers {
    
    [BXGNotificationTool addObserverForReachability:self];
    [self.playerView addDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboadWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboadWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(catchDeviceOrientationChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)uninstallObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [BXGNotificationTool removeObserver:self];
    [self.playerView removeDelegate:self];
}

- (void)keyboadWillShow:(NSNotification *)noti {
    
}

- (void)keyboadWillHide:(NSNotification *)noti {
    
}

- (void)UIDeviceOrientationLandscapeRight {
    
}
- (void)UIDeviceOrientationLandscapeLeft {
    
    
}
- (void)UIDeviceOrientationPortrait {
    // 竖屏约束

    
}
- (void)UIDeviceOrientationPortraitUpsideDown {
    
}

- (void)catchDeviceOrientationChange:(NSNotification *)noti {
//    switch ([UIDevice currentDevice].orientation) {
//        case UIDeviceOrientationUnknown:{
//
//            [self UIDeviceOrientationPortrait];
//
//        }break;
//        case UIDeviceOrientationPortrait:{
//
//            [self UIDeviceOrientationPortrait];
//
//        }break;
//        case UIDeviceOrientationPortraitUpsideDown:{
//
//        }break;
//        case UIDeviceOrientationLandscapeLeft:{
//
//            [self UIDeviceOrientationLandscapeLeft];
//
//        }break;
//        case UIDeviceOrientationLandscapeRight:{ // 摄像头在右边
//
//            [self UIDeviceOrientationLandscapeRight];
//
//        }break;
//        case UIDeviceOrientationFaceUp:{
//            NSLog(@"平面上");
//        }break;
//        case UIDeviceOrientationFaceDown:{
//            NSLog(@"扣死");
//        }break;
//        default:{
//            NSLog(@"");
//        }break;
//    }
}

#pragma mark - StatusBarStyle

- (BOOL)prefersStatusBarHidden {
    return self.isStatusBarHidden;
}

#pragma mark - BXGPlayerViewDelegate

- (void)playerView:(BXGPlayerView *)playerView hideComponentsView:(BOOL)isHidden {
    self.isStatusBarHidden = isHidden;
}

#pragma mark - BXGPlayerManagerDelegate

- (void)playerManagerPlayStateDidChange:(BXGPlayerManager *)playerManager state:(BOOL)isPlaying; {
    
    self.isPlaying = isPlaying;
}

- (void)playerManagerVideoDidReachEnd:(BXGPlayerManager *)playerManager {
    
}

- (void)playerManagerVideoDidFailed:(BXGPlayerManager *)playerManager didFailWithErrorMsg:(NSString *)errorMsg {
    
}

- (void)playerManagerVideoReadyToPlay:(BXGPlayerManager *)playerManager {
    
} // 监听准备播放

- (void)playerManagerVideoTimeDidChange:(BXGPlayerManager *)playerManager timeDidChange:(float)currentTime duration:(float)durationTime {
    
    self.playSlider.value = currentTime / durationTime;
    self.currentTimeLabel.text = [BXGPlayerManager formatSecondsToString:@(currentTime).integerValue];
    self.durationTimeLabel.text = [BXGPlayerManager formatSecondsToString:@(durationTime).integerValue];
}

- (void)playerManager:(BXGPlayerManager *)playerManager loadedTimeRangeDidChange:(float)duration {
    
}

- (void)playerManager:(BXGPlayerManager *)playerManager bufflingStateDidChange:(BOOL)isBuffling {
    
    // float
}

- (void)playerManager:(BXGPlayerManager *)playerManager seekingTime:(float)seekTime currentTime:(float)currentTime duration:(float)durationTime {
    if(!self.playSlider.highlighted) {
        self.playSlider.value = seekTime / durationTime;
    }else {
        self.playSlider.userInteractionEnabled = false;
    }
    self.currentTimeLabel.text = [BXGPlayerManager formatSecondsToString:@(seekTime).integerValue];
    self.durationTimeLabel.text = [BXGPlayerManager formatSecondsToString:@(durationTime).integerValue];
}

- (void)playerManager:(BXGPlayerManager *)playerManager startSeekTime:(float)seekTime currentTime:(float)currentTime duration:(float)durationTime {
    
    if(!self.playSlider.highlighted) {
        self.playSlider.value = seekTime / durationTime;
        
    }else {
        self.playSlider.userInteractionEnabled = false;
    }
    self.currentTimeLabel.text = [BXGPlayerManager formatSecondsToString:@(seekTime).integerValue];
    self.durationTimeLabel.text = [BXGPlayerManager formatSecondsToString:@(durationTime).integerValue];
}

- (void)playerManager:(BXGPlayerManager *)playerManager endSeekTime:(float)seekTime currentTime:(float)currentTime duration:(float)durationTime {
    
    if(!self.playSlider.highlighted) {
        self.playSlider.value = seekTime / durationTime;
    }
    self.playSlider.userInteractionEnabled = true;
    self.currentTimeLabel.text = [BXGPlayerManager formatSecondsToString:@(seekTime).integerValue];
    self.durationTimeLabel.text = [BXGPlayerManager formatSecondsToString:@(durationTime).integerValue];
}

- (void)playerManager:(BXGPlayerManager *)playerManager rateDidChange:(float)rate {
    
    [self closePopMaskView];
    
    [self.selectSpeedBtn setTitle:[NSString stringWithFormat:@"%0.2f倍速",rate] forState:UIControlStateNormal];
}

- (void)playerManager:(BXGPlayerManager *)playerManager hideComponentsView:(BOOL)isHide {
    if(isHide) {
        self.isStatusBarHidden = true;
        [self closePopMaskView];
    }else {
        self.isStatusBarHidden = false;
    }
}

#pragma mark - BXGPlayerListManagerDelegate
- (void)playerListManager:(BXGPlayerListManager *)manager playingVideo:(BXGVODPlayerVideoModel *)video index:(NSInteger)index {
    [self closePopMaskView];
}


- (void)playerListManager:(BXGPlayerListManager *)manager doneWithVideo:(BXGVODPlayerVideoModel *)video index:(NSInteger)index; // 播放完毕
{
    
}

- (BOOL)playerListManager:(BXGPlayerListManager *)manager willPlayVideo:(BXGVODPlayerVideoModel *)video index:(NSInteger)index; {
    
    return true;
}


- (void)playerListManager:(BXGPlayerListManager *)manager stopWithPlayVideo:(BXGVODPlayerVideoModel *)video index:(NSInteger)index; {
    
}// 手动或异常中断

- (void)playerListManager:(BXGPlayerListManager *)manager doneWithPlayList:(NSArray<BXGVODPlayerVideoModel *> *)playList; {
    
}

#pragma mark - BXGPlayerSelectVideoView delegate 选集功能

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.playerListManager.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BXGSelectionVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGSelectionVideoCell" forIndexPath:indexPath];
    
    cell.cellTitle = [NSString stringWithFormat:@"%02zd_%@",indexPath.row + 1,self.playerListManager.videos[indexPath.row].name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Weak(weakSelf);
    
    [self.playerListManager playOnListWithIndex:indexPath.row];
    [tableView selectRowAtIndexPath:indexPath animated:false scrollPosition:UITableViewScrollPositionNone];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf closePopMaskView];
    });
}

#pragma mark - BXGNotificationDelegate
// 监听网络状态
-(void)catchRechbility:(BXGReachabilityStatus)status; {
    
    if(BXGReachabilityStatusReachabilityStatusNotReachable == status) {
        
        [[BXGHUDTool share]showHUDWithString:kBXGToastNonNetworkTip];
    }else {
        
        [self allowCellularWatchAlert:status confirmHandler:^{
            // 继续
        } cancleHandler:^{
            // 已经执行退出操作
        }];
    }
}

- (BOOL)allowCellularWatchAlert:(BXGReachabilityStatus)status confirmHandler:(void(^)())confirmHandler cancleHandler:(void(^)())cancleHandler{
    
    Weak(weakSelf);
    
    if(status == BXGReachabilityStatusReachabilityStatusReachableViaWWAN && ![BXGUserDefaults share].isAllowCellularWatch) {
        
        BXGAlertController *vc = [BXGAlertController confirmWithTitle:@"你正在使用3G/4G网络观看视频，是否继续？" message:nil confirmHandler:^{
            [BXGUserDefaults share].isAllowCellularWatch = true;
            if(confirmHandler){
                confirmHandler();
            }
        } cancleHandler:^{
            [self dismissViewControllerAnimated:true completion:nil];
            if(cancleHandler){
                cancleHandler();
            }
        }];
        
        [weakSelf presentViewController:vc animated:true completion:nil];
        return false;
    }else {
        return true;
    }
}

@end
