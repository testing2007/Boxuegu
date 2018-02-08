//
//  BXGVODPlayerFloatView.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/18.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGVODPlayerFloatView.h"
#import "BXGPlayerManager.h"

@interface BXGVODPlayerFloatView() <BXGPlayerManagerDelegate>
@property (nonatomic, strong) BXGPlayerManager *playerManager;
@property (nonatomic, strong) UIView *bufferingView;
@end

@implementation BXGVODPlayerFloatView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
    }
    return self;
}

- (void)didMoveToSuperview {
    
    if(self.superview) {
        [self.playerManager addDelegate:self];
    }else {
        [self.playerManager removeDelegate:self];
    }
}

- (void)dealloc {
    
}

- (BXGPlayerManager *)playerManager {
    
    if(_playerManager == nil) {
        
        _playerManager = [BXGPlayerManager share];
    }
    return _playerManager;
}

- (UIView *)bufferingView {
    
    if(_bufferingView == nil) {
        
        _bufferingView = [UIView new];
        
        UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [aiView startAnimating];
//        _bufferingView.backgroundColor = [UIColor blackColor];
        _bufferingView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.2];
//        UILabel *titleLabel = [UILabel new];
//        titleLabel.text = @"正在加载";
//        titleLabel.font = [UIFont bxg_fontRegularWithSize:15];
//        titleLabel.textColor = [UIColor whiteColor];
        
        [_bufferingView addSubview:aiView];
        [aiView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_bufferingView);
        }];
//        [_bufferingView addSubview:titleLabel];
    }
    return _bufferingView;
}

- (void)removeFloatView {
    
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        [self.subviews[i] removeFromSuperview];
    }
}

- (void)buffering:(BOOL)isBuffering {
    
    if(isBuffering){
        
        [self addSubview:self.bufferingView];
        [self.bufferingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.offset(0);
        }];
        
        
        
    }else {
        
        [self removeFloatView];
        
        if(self.bufferingView.superview) {
            [self.bufferingView removeFromSuperview];
        }
        self.bufferingView = nil;
    }
}

// 1.正在缓冲

// 2.视频加载失败

// 3.无网络连接

// 4.正在加载

#pragma mark - BXGPlayerManagerDelegate

//- (void)playerManagerPlayStateDidChange:(BXGPlayerManager *)playerManager state:(BOOL)isPlaying; // done
//- (void)playerManagerVideoDidReachEnd:(BXGPlayerManager *)playerManager;
//- (void)playerManagerVideoDidFailed:(BXGPlayerManager *)playerManager didFailWithErrorMsg:(NSString *)errorMsg;
//- (void)playerManagerVideoReadyToPlay:(BXGPlayerManager *)playerManager; // 监听准备播放
//- (void)playerManagerVideoTimeDidChange:(BXGPlayerManager *)playerManager timeDidChange:(float)currentTime duration:(float)durationTime;
//- (void)playerManager:(BXGPlayerManager *)playerManager loadedTimeRangeDidChange:(float)duration;
- (void)playerManager:(BXGPlayerManager *)playerManager bufflingStateDidChange:(BOOL)isBuffling {
    [self buffering:isBuffling];
}




@end
