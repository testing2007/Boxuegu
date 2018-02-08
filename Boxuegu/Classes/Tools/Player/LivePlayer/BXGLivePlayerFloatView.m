//
//  BXGLivePlayerFloatView.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/19.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGLivePlayerFloatView.h"
#import "BXGLiveManager.h"

@interface BXGLivePlayerFloatView() <BXGLiveManagerDelegate>
@property (nonatomic, strong) BXGLiveManager *liveManager;
@property (nonatomic, strong) UIView *bufferingView;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation BXGLivePlayerFloatView

#pragma mark - init

- (BXGLiveManager *)liveManager {
    
    if(_liveManager == nil) {
        
        _liveManager = [BXGLiveManager share];
        
    }
    return _liveManager;
}

- (void)didMoveToSuperview {
    if(self.superview) {
        [self.liveManager addDelegate:self];
    }else {
        [self.liveManager removeDelegate:self];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
    }
    return self;
}

- (void)dealloc {
    
    //    [self.liveManager removeDelegate:self];
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

- (UILabel *)tipLabel {
    
    if(_tipLabel == nil) {
        
        _tipLabel = [UILabel new];
        _tipLabel.font = [UIFont bxg_fontRegularWithSize:15];
        _tipLabel.textColor = [UIColor whiteColor];
    }
    return _tipLabel;
}

- (UIView *)tipView {
    
    if(_tipView == nil) {
        
        _tipView = [UIView new];
        _tipView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.2];
        UILabel *tipLabel = self.tipLabel;
        tipLabel.numberOfLines = 0;
        [_tipView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_tipView);
        }];
    }
    return _tipView;
}

- (void)removeFloatView {
    
    if(_tipLabel) {
        
        if(_tipLabel.superview) {
            [_tipLabel removeFromSuperview];
        }
        _tipLabel = nil;
    }
    
    if(_tipView) {
        if(_tipView.superview) {
            [_tipView removeFromSuperview];
        }
        _tipView = nil;
    }
    
    if(_bufferingView) {
        if(_bufferingView.superview) {
            [_bufferingView removeFromSuperview];
        }
        _bufferingView = nil;
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

#pragma mark - BXGLiveManagerDelegate

- (void)liveManager:(BXGLiveManager *)liveManager state:(BXGLiveManagerState)state msg:(NSString *)msg {
    switch (state) {
            
        case BXGLiveManagerStateLoading: {
            [self removeFloatView];
            [self buffering:true];
        }break;
        case BXGLiveManagerStateLive: {
            [self removeFloatView];
        }break;
        case BXGLiveManagerStateStop: {
            [self removeFloatView];
            [self addSubview:self.tipView];
            [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.top.offset(0);
            }];
            self.tipLabel.text = @"直播已结束";
        }break;
        case BXGLiveManagerStateNotStarted: {
            [self removeFloatView];
            [self addSubview:self.tipView];
            [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.top.offset(0);
            }];
            self.tipLabel.text = @"直播等待中";
        }break;
        case BXGLiveManagerStateNetworkError: {
            [self removeFloatView];
            [self addSubview:self.tipView];
            [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.top.offset(0);
            }];
            self.tipLabel.text = kBXGToastNoNetworkError;
        }break;
        case BXGLiveManagerStateUnknownError: {
            [self removeFloatView];
            [self addSubview:self.tipView];
            [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.top.offset(0);
            }];
            self.tipLabel.text = msg;
        }break;
    }
}

- (void)liveManager:(BXGLiveManager *)liveManager changeMode:(BXGLiveManagerPlayMode)mode {
    
}


//- (void)liveManager:(BXGLiveManager *)liveManager channelCount:(NSInteger)chanelCount;
//- (void)liveManager:(BXGLiveManager *)liveManager currentChannel:(NSInteger)currentChannel;
//- (void)liveManager:(BXGLiveManager *)liveManager qualityArray:(NSArray *)qualityArray;
//- (void)liveManager:(BXGLiveManager *)liveManager userCount:(NSInteger)userCount;
//- (void)liveManager:(BXGLiveManager *)liveManager announcement:(NSString *)announcement;
//- (void)liveManager:(BXGLiveManager *)liveManager dialogArray:(NSArray<BXGLiveDialogModel *> *)dialogArray;
//- (void)liveManager:(BXGLiveManager *)liveManager introduce:(NSString *)introduce;
//- (void)liveManager:(BXGLiveManager *)liveManager state:(BXGLiveManagerState)state msg:(NSString *)msg;
//- (void)liveManager:(BXGLiveManager *)liveManager kickOut:(BOOL)isKickOut;

// 音视频切换
//- (void)liveManager:(BXGLiveManager *)liveManager changeMode:(BXGLiveManagerPlayMode)mode;

// TODO: 禁言待调整
//- (void)liveManager:(BXGLiveManager *)liveManager message:(NSString *)message;

@end

