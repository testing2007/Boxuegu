//
//  BXGLivePlayerVC.m
//  SetupCCLive
//
//  Created by RenyingWu on 2018/1/4.
//  Copyright © 2018年 Renying Wu. All rights reserved.
//

#import "BXGLivePlayerVC.h"
#import "BXGLivePlayerView.h"
#import "Masonry.h"
#import "BXGLiveManager.h"
#import "RWTabView.h"
#import "UIColor+Extension.h"
#import "BXGLiveBottomChatView.h"
#import "BXGLiveChatView.h"

#define kTopOffset 0

#define absoluteWidth ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height)

#define absoluteHeight ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)

@interface BXGLivePlayerVC () <BXGLiveManagerDelegate>
@property (nonatomic, assign) BOOL isVer;
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) BXGLiveManager *liveManager;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL isStatusBarHidden;



@property (nonatomic, strong) MYBottomChatView *chatInputView;
@end

@implementation BXGLivePlayerVC
#pragma mark - life cycle

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

#pragma mark - Observers

- (void)installObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboadWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboadWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(catchDeviceOrientationChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)uninstallObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboadWillShow:(NSNotification *)noti {
    NSValue *value = noti.userInfo[@"UIKeyboardBoundsUserInfoKey"];
    CGRect rect = value.CGRectValue;
    
//    [self.offsetView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(rect.size.height);
//    }];
}

- (void)keyboadWillHide:(NSNotification *)noti {
//    [self.offsetView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(0);
//    }];
}


//- (void)keyboadWillShow:(NSNotification *)noti {
//    NSValue *value = noti.userInfo[@"UIKeyboardBoundsUserInfoKey"];
//    CGRect rect = value.CGRectValue;
//
//    [self.offsetView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(rect.size.height);
//    }];
//}
//
//- (void)keyboadWillHide:(NSNotification *)noti {
//    [self.offsetView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(0);
//    }];
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self installUI];
    [self install];
    if (@available(iOS 11.0, *)) {
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
}



- (void)installUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    BXGLivePlayerView *playerView = [[BXGLivePlayerView alloc]init];
    [self.view addSubview:playerView];
//    playerView.backgroundColor = [UIColor orangeColor];
    
    // 竖屏约束
    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kTopOffset);
        make.left.right.offset(0);
        make.height.offset(100.0 / 200 * absoluteWidth);
    }];
    self.playerView = playerView;
    
    
//    UITextField *textField = [[UITextField alloc]init];
//    [self.view addSubview:textField];
//    [self.view insertSubview:textField belowSubview:playerView];
//    [textField setInputView:self.emojiView];
//    textField.backgroundColor = [UIColor whiteColor];
    
    // 竖屏约束
//    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.offset(0);
//        make.left.right.offset(0);
//        make.height.offset(absoluteHeight - 100.0 / 200 * absoluteWidth - kTopOffset - 50);
//    }];
    
    UIView *contentView = self.contentView;
    [self.view insertSubview:contentView belowSubview:playerView];
    contentView.backgroundColor = [UIColor whiteColor];

    
    
//    UIView *offsetView = self.offsetView;
//    [self.view insertSubview:offsetView belowSubview:playerView];
//    [offsetView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.offset(0);
//        make.height.offset(0);
//    }];
//
//    UIView *chatInputView = self.chatInputView;
//    [self.view insertSubview:chatInputView belowSubview:playerView];
//    [chatInputView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.offsetView.mas_top); // 需要适配iPhoneX
//        make.left.right.offset(0);
//        make.height.offset(54);
//    }];
    
    // 竖屏约束
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.right.offset(0);
        make.top.offset(100.0 / 200 * absoluteWidth + kTopOffset);
    }];
    
    
    
    
    
    self.playerView = playerView;
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    

//    self.isVer = !self.isVer;
//    if(self.isVer) {
//        [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.view);
//            make.width.offset(absoluteHeight);
//            make.height.offset(absoluteWidth);
//        }];
//
//        CGAffineTransform transform = CGAffineTransformRotate(self.playerView.transform, M_PI_2);
//
//        [UIView animateWithDuration:0.5 animations:^{
//            [self.view layoutIfNeeded];
//            [[BXGLiveManager share] framev:self.playerView];
//            self.playerView.transform = transform;
//
//        }];
//    }else {
//        // 竖屏约束
//        [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.offset(kTopOffset);
//            make.left.right.offset(0);
//            make.height.offset(100.0 / 200 * absoluteWidth);
//        }];
//        [UIView animateWithDuration:0.5 animations:^{
//            self.playerView.transform = CGAffineTransformIdentity;
//            [self.view layoutIfNeeded];
//            [[BXGLiveManager share] framev:self.playerView];
//        }];
//    }
}
- (UIView *)contentView {
    if(_contentView == nil) {
        _contentView =  [UIView new];
        
        __weak typeof(self) weakSelf = self;
        
        UIViewController *chatVC = [BXGLiveChatView new];
        UIView *chatView = chatVC.view;
        [self addChildViewController:chatVC];
        
        RWTabView *tab = [[RWTabView alloc]initWithTitles:@[@"聊天",@"简介"] andDetailViews:@[chatView,[UIView new]]];
        tab.DidChangedIndex = ^(RWTabView *tab, NSInteger index, NSString *title, UIView *view) {
            [weakSelf.view endEditing:true];
        };
        [_contentView addSubview:tab];
        [tab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.offset(0);
        }];
    }
    return _contentView;
}

- (void)UIDeviceOrientationLandscapeRight {
    
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.offset(absoluteHeight);
        make.height.offset(absoluteWidth);
    }];
    
    CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI_2);
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        [[BXGLiveManager share] framev:self.playerView];
        self.playerView.transform = transform;
        
    }];
}
- (void)UIDeviceOrientationLandscapeLeft {
    
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.offset(absoluteHeight);
        make.height.offset(absoluteWidth);
    }];
    
    CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        [[BXGLiveManager share] framev:self.playerView];
        self.playerView.transform = transform;
        
    }];
    
}
- (void)UIDeviceOrientationPortrait {
    // 竖屏约束
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(kTopOffset);
        make.left.right.offset(0);
        make.height.offset(100.0 / 200 * absoluteWidth);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        self.playerView.transform = CGAffineTransformIdentity;
        [self.view layoutIfNeeded];
        [[BXGLiveManager share] framev:self.playerView];
    }];
    // 显示时间栏
    
}
- (void)UIDeviceOrientationPortraitUpsideDown {
    
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.offset(absoluteHeight);
        make.height.offset(absoluteWidth);
    }];
    
    CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
        [[BXGLiveManager share] framev:self.playerView];
        self.playerView.transform = transform;
    }];
}

- (void)install {
    
    _liveManager = [BXGLiveManager share];
    [_liveManager install];
//    [_liveManager installLiveView:self.playerView];
    [_liveManager addDelegate:self];
    [_liveManager requestPlay];
}


- (void)catchDeviceOrientationChange:(NSNotification *)noti {
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationUnknown:{
            
            [self UIDeviceOrientationPortrait];
            self.isStatusBarHidden = false;
        }break;
        case UIDeviceOrientationPortrait:{
            [self UIDeviceOrientationPortrait];
            self.isStatusBarHidden = false;
        }break;
        case UIDeviceOrientationPortraitUpsideDown:{
            
//            [self UIDeviceOrientationPortraitUpsideDown];
        }break;
        case UIDeviceOrientationLandscapeLeft:{
            
            [self UIDeviceOrientationLandscapeLeft];
            self.isStatusBarHidden = true;
        }break;
        case UIDeviceOrientationLandscapeRight:{ // 摄像头在右边
            
            [self UIDeviceOrientationLandscapeRight];
            self.isStatusBarHidden = true;
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

@end
