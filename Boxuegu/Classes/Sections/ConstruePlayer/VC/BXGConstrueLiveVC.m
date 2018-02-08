//
//  BXGConstrueLiveVC.m
//  Boxuegu
//
//  Created by wurenying on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGConstrueLiveVC.h"
#import "BXGLivePlayerView.h"
#import "BXGLiveManager.h"
#import "RWTabView.h"

#import "BXGLiveBottomChatView.h"
#import "BXGLiveChatView.h"
#import "BXGConstrueIntroduceView.h"
#import "BXGConstrueLiveViewModel.h"
#import "BXGConstrueChatView.h"
#import "BXGConstrueLivePlayerView.h"
#import "BXGConstrueIntroduceModel.h"

@interface BXGConstrueLiveVC () <BXGLiveManagerDelegate,BXGNotificationDelegate,BXGPlayerViewDelegate>
@property (nonatomic, assign) BOOL isVer;
@property (nonatomic, strong) BXGConstrueLivePlayerView *playerView;
@property (nonatomic, strong) BXGLiveManager *liveManager;
@property (nonatomic, strong) UIView *contentView;


// state
@property (nonatomic, assign) BOOL isStatusBarHidden;

// ViewModel
@property (nonatomic, strong) BXGConstrueLiveViewModel *viewModel;
// UI
@property (nonatomic, strong) BXGConstrueIntroduceView *introduceView;
@property (nonatomic, strong) BXGConstrueChatView *chatView;
@end

@implementation BXGConstrueLiveVC

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)dealloc {
    
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self installUI];
    Weak(weakSelf);
    BXGReachabilityStatus status = [BXGNetWorkTool sharedTool].getReachState;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    if([self allowCellularWatchAlert:status confirmHandler:^{
        [weakSelf loadIntroduce];
    } cancleHandler:^{
        
    }]){
        [weakSelf loadIntroduce];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false];
    [self uninstallObservers];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true];
    [self installObservers];
}

#pragma mark - getter setter

- (BXGConstrueLiveViewModel *)viewModel {
    
    if(_viewModel == nil) {
        
        _viewModel = [BXGConstrueLiveViewModel new];
    }
    return _viewModel;
}

- (BXGConstrueIntroduceView *)introduceView {
    
    if(_introduceView == nil) {
        
        _introduceView = [BXGConstrueIntroduceView new];
    }
    return _introduceView;
}

- (BXGConstrueChatView *)chatView {
    Weak(weakSelf);
    
    if(_chatView == nil) {
        
        _chatView = [BXGConstrueChatView new];
        _chatView.sendMessageBlock = ^(NSString *msg) {
            
            [weakSelf sendMessage:msg];
        };
    }
    return _chatView;
}

- (BXGConstrueLivePlayerView *)playerView {
    Weak(weakSelf);
    if(_playerView == nil) {
        
        _playerView = [BXGConstrueLivePlayerView new];
        _playerView.changePlayerViewSizeBlock = ^(BOOL isFUllScreen) {
            
            if(isFUllScreen){
                
                [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
                weakSelf.isStatusBarHidden = true;
            }else {
                [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
                weakSelf.isStatusBarHidden = false;
            }
        };
    }
    return _playerView;
}

#pragma mark - method

- (void)sendMessage:(NSString *)msg {
    if(msg.length <= 0) {
        [[BXGHUDTool share] showHUDWithString:@"聊天内容不能为空"];
    }else {
        [self.liveManager chatMessage:msg];
    }
}

#pragma mark - Observers

- (void)installObservers {
    
    [self.playerView addDelegate:self];
    [BXGNotificationTool addObserverForReachability:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(catchDeviceOrientationChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)uninstallObservers {
    
    
    [BXGNotificationTool removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.playerView removeDelegate:self];
    [self.liveManager removeDelegate:self];
    
    [self.liveManager unintall];
    if(self.playerView) {
        
        if(self.playerView.superview) {
            [self.playerView removeFromSuperview];
            
        }
        self.playerView = nil;
    }
    
    if(_contentView) {
        
        if(_contentView.subviews.firstObject) {
            [_contentView.subviews.firstObject removeFromSuperview];
        }
        
        if(_contentView.superview) {
            [_contentView removeFromSuperview];
            
        }
        _contentView = nil;
    }
    
    
    self.viewModel = nil;
    self.introduceView = nil;
    self.chatView = nil;
}

# pragma mark - ui

- (void)installUI {
    
    // 背景层
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *maskView = [UIView new];
    [self.view addSubview:maskView];
    maskView.backgroundColor = [UIColor blackColor];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.bottom.offset(0);
    }];

    BXGConstrueLivePlayerView *playerView = self.playerView;
    [self.view addSubview:playerView];
    
    // 竖屏约束
    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(K_IS_IPHONE_X) {
            make.top.offset(K_STATUS_BAR_OFFSET);
        }else {
            make.top.offset(0);
        }
        
        make.left.right.offset(0);
        make.height.offset(422.0 / 750.0 * K_ABSOLUTE_SCREEN_WIDTH);
    }];
    
    UIView *contentView = self.contentView;
    [self.view insertSubview:contentView belowSubview:playerView];
    contentView.backgroundColor = [UIColor whiteColor];
    
    // 竖屏约束
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.offset(-K_BOTTOM_SAFE_OFFSET);
        make.bottom.offset(0);
        make.left.offset(0);
        make.width.offset(K_ABSOLUTE_SCREEN_WIDTH);
        make.top.equalTo(playerView.mas_bottom);
        
    }];
    
    self.playerView = playerView;
}

- (UIView *)contentView {
    Weak(weakSelf);
    
    if(_contentView == nil) {
        _contentView =  [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        BXGConstrueChatView *chatView = self.chatView;
        BXGConstrueIntroduceView *introduceView = self.introduceView;
        
        RWTabView *tab = [[RWTabView alloc]initWithTitles:@[@"聊天",@"简介"] andDetailViews:@[chatView,introduceView]];
        [_contentView addSubview:tab];
        tab.DidChangedIndex = ^(RWTabView *tab, NSInteger index, NSString *title, UIView *view) {
            [weakSelf.view endEditing:true];
        };

        [tab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.offset(0);
        }];
        tab.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        tab.bounces = false;
    }
    return _contentView;
}

- (void)loadIntroduce {
    Weak(weakSelf);
    NSString *planId = self.planId;

    [[BXGHUDTool share] showLoadingHUDWithString:nil];
    [self.viewModel loadConstrueIntroducePlanId:planId Finished:^(BXGConstrueIntroduceModel *model, NSString *msg) {
        [[BXGHUDTool share] closeHUD];
        if(model) {
            weakSelf.introduceView.model = model;
            [weakSelf.liveManager installRoomId:model.liveRoom];
            [weakSelf install];
        }else {
            [[BXGHUDTool share] showHUDWithString:@"获取直播信息失败,请稍后重试!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[BXGHUDTool share] closeHUD];
                 [weakSelf.navigationController popViewControllerAnimated:true];
            });
            
        }
    }];
    
}

- (BXGLiveManager *)liveManager {
    
    if(_liveManager == nil) {
        
        _liveManager = [BXGLiveManager share];
    }
    return _liveManager;
}

- (void)UIDeviceOrientationLandscapeRight {
    
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];
    
    [self.view layoutIfNeeded];
    [[BXGLiveManager share] framev:self.playerView];
    self.contentView.hidden = true;
    [self.view endEditing:true];
    self.playerView.isFullScreen = true;
    
}
- (void)UIDeviceOrientationLandscapeLeft {
    
//    self.playerView.isFullScreen = true;
//
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];
    
    [self.view layoutIfNeeded];
    [[BXGLiveManager share] framev:self.playerView];
    self.contentView.hidden = true;
    [self.view endEditing:true];
    self.playerView.isFullScreen = true;
//    self.isStatusBarHidden = true;
    
    

//    [[BXGLiveManager share] framev:self.playerView];
//    self.contentView.hidden = true;
    
}
- (void)UIDeviceOrientationPortrait {
    
//    self.playerView.isFullScreen = false;
//
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if(K_IS_IPHONE_X) {
            make.top.offset(K_STATUS_BAR_OFFSET);
        }else {
            make.top.offset(0);
        }
        make.left.right.offset(0);
        make.height.offset(422.0 / 750.0 * K_ABSOLUTE_SCREEN_WIDTH);
    }];
    
    [self.view layoutIfNeeded];
    [[BXGLiveManager share] framev:self.playerView];
    self.contentView.hidden = false;
    self.playerView.isFullScreen = false;
}

- (void)UIDeviceOrientationPortraitUpsideDown {
    
}

- (void)install {
    
//    _liveManager = [BXGLiveManager share];
    [_liveManager install];
    //    [_liveManager installLiveView:self.playerView.playerView];
    [_liveManager addDelegate:self];
    [_liveManager requestPlay];
}

- (void)catchDeviceOrientationChange:(NSNotification *)noti {
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationUnknown:{
            
            [self UIDeviceOrientationPortrait];
            
        }break;
        case UIDeviceOrientationPortrait:{
            
            [self UIDeviceOrientationPortrait];
            
        }break;
        case UIDeviceOrientationPortraitUpsideDown:{
            
        }break;
        case UIDeviceOrientationLandscapeLeft:{

            [self UIDeviceOrientationLandscapeLeft];
            
        }break;
        case UIDeviceOrientationLandscapeRight:{ // 摄像头在右边
            
            
            [self UIDeviceOrientationLandscapeRight];
            
        }break;
        case UIDeviceOrientationFaceUp:{
            NSLog(@"平面上");
        }break;
        case UIDeviceOrientationFaceDown:{
            NSLog(@"扣死");
        }break;
        default:{
            NSLog(@"");
        }break;
    }
}

#pragma mark - UIStatusBarStyle

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setIsStatusBarHidden:(BOOL)isStatusBarHidden {
    _isStatusBarHidden = isStatusBarHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden {
    return self.isStatusBarHidden;
}

#pragma mark - BXGLiveManagerDelegate

- (void)liveManager:(BXGLiveManager *)liveManager dialogArray:(NSArray<BXGLiveDialogModel *> *)dialogArray {
    self.chatView.modelArray = dialogArray;
}
- (void)liveManager:(BXGLiveManager *)liveManager state:(BXGLiveManagerState)state msg:(NSString *)msg {
    Weak(weakSelf);
    if(state == BXGLiveManagerStateUnknownError) {
        [[BXGHUDTool share] showHUDWithString:@"获取直播信息失败,请稍后重试!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[BXGHUDTool share] closeHUD];
            [weakSelf.navigationController popViewControllerAnimated:true];
        });
    }
    
}

- (void)liveManager:(BXGLiveManager *)liveManager kickOut:(BOOL)isKickOut {
    Weak(weakSelf);
    [[BXGHUDTool share] showHUDWithString:@"您已被踢出直播间"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[BXGHUDTool share] closeHUD];
        [weakSelf.navigationController popViewControllerAnimated:true];
    });
}

#pragma mark - supportedInterfaceOrientations

- (BOOL)shouldAutorotate {
    
    return true;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationPortraitUpsideDown | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}


#pragma mark - BXGNotificationDelegate
// 监听网络状态
-(void)catchRechbility:(BXGReachabilityStatus)status; {
    
    Weak(weakSelf);
    
    if(BXGReachabilityStatusReachabilityStatusNotReachable == status) {
        
        [[BXGHUDTool share]showHUDWithString:kBXGToastNonNetworkTip];
    }else {
        
        [weakSelf allowCellularWatchAlert:status confirmHandler:^{
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
            [weakSelf.navigationController popViewControllerAnimated:true];
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
#pragma mark - BXGPlayerViewDelegate

- (void)playerView:(BXGPlayerView *)playerView hideComponentsView:(BOOL)isHidden {
    self.isStatusBarHidden = isHidden;
}

@end
