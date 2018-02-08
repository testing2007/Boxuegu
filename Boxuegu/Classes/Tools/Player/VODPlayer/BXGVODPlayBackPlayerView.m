//
//  BXGVODPlayBackPlayerView.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/2/1.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGVODPlayBackPlayerView.h"

#import "BXGVODPlayerGestrueView.h"
#import "BXGPlayerSeekView.h"
#import "BXGPlayerManager.h"
#import "BXGVODPlayerFloatView.h"

@interface BXGVODPlayBackPlayerView() <BXGPlayerManagerDelegate>

@property (nonatomic, strong) BXGPlayerSeekView *playerSeekView;
@property (nonatomic, strong) BXGPlayerManager *playerManager;
@end

@implementation BXGVODPlayBackPlayerView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        BXGVODPlayerGestrueView *gestrueView = [BXGVODPlayerGestrueView new];
        self.gestrueView = gestrueView;
        
        BXGVODPlayerFloatView *floatView = [BXGVODPlayerFloatView new];
        self.floatView = floatView;
        
        
        NSString *ccUserId = [BXGUserCenter share].userModel.cc_live_user_id;
        NSString *ccAPIKey = [BXGUserCenter share].userModel.cc_live_playback_key;
        
        self.mediaView = [self.playerManager generatePlayerViewWithCCUserId:ccUserId andCCAPIKey:ccAPIKey];
    }
    return self;
}
#pragma mark - life cycle

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if(self.superview) {
        [self.playerManager addDelegate:self];
    }else {
        [self.playerManager removeDelegate:self];
        [self.floatView removeFromSuperview];
        self.floatView = nil;
    }
}

- (void)dealloc {
    
}

#pragma mark - getter setter

- (BXGPlayerManager *)playerManager {
    
    if(_playerManager == nil) {
        
        _playerManager = [BXGPlayerManager share];
    }
    return _playerManager;
}

#pragma mark - ui

- (BXGPlayerSeekView *)playerSeekView {
    
    if(!_playerSeekView) {
        
        _playerSeekView = [BXGPlayerSeekView new];
    }
    return _playerSeekView;
}

#pragma mark - BXGPlayerManagerDelegate

- (void)playerManager:(BXGPlayerManager *)playerManager startSeekTime:(float)seekTime currentTime:(float)currentTime duration:(float)durationTime {
    
    [self.floatView addSubview:self.playerSeekView];
    [self.playerSeekView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    [self.playerSeekView currentTime:currentTime andDurationTime:durationTime andSeekTime:seekTime];
}

- (void)playerManager:(BXGPlayerManager *)playerManager seekingTime:(float)seekTime currentTime:(float)currentTime duration:(float)durationTime {
    
    [self.playerSeekView currentTime:currentTime andDurationTime:durationTime andSeekTime:seekTime];
}

- (void)playerManager:(BXGPlayerManager *)playerManager endSeekTime:(float)seekTime currentTime:(float)currentTime duration:(float)durationTime {
    
    [self.playerSeekView removeFromSuperview];
    self.playerSeekView = nil;
}
@end
