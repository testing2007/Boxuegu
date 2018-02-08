//
//  BXGLivePlayerView.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/19.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGLivePlayerView.h"
#import "BXGLivePlayerFloatView.h"
#import "BXGLivePlayerGestureView.h"
#import "BXGLiveManager.h"

@interface BXGLivePlayerView() <BXGLiveManagerDelegate>
@property (nonatomic, strong) BXGLiveManager *liveManager;
@end

@implementation BXGLivePlayerView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        BXGPlayerGestrueView *gestrueView = [BXGLivePlayerGestureView new];
        self.gestrueView = gestrueView;
        
        BXGLivePlayerFloatView *floatView = [BXGLivePlayerFloatView new];
        self.floatView = floatView;
        self.mediaView = [self.liveManager generatePlayerView];
    }
    return self;
}

- (void)dealloc {
    
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if(self.superview) {
        
        [self.liveManager addDelegate:self];
    }else {
        [self.liveManager removeDelegate:self];
        [self.mediaView removeFromSuperview];
        
        self.mediaView = nil;
        [self.floatView removeFromSuperview];
        self.floatView = nil;
    }
}

#pragma mark - getter setter

- (BXGLiveManager *)liveManager {
    
    if(_liveManager == nil) {
        
        _liveManager = [BXGLiveManager share];
        
    }
    return _liveManager;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.liveManager framev:self.mediaView];
}
@end
