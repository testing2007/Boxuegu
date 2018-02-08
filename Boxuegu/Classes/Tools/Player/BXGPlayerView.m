//
//  BXGPlayerView.m
//  RWPlayer
//
//  Created by RenyingWu on 2017/12/12.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "BXGPlayerView.h"
#import "BXGPlayerManager.h"
#import "BXGPlayerGestrueView.h"

@interface BXGPlayerView()

// ui
@property (nonatomic, strong) UIView *componentsTapView;
@property (nonatomic, strong) UIView *gestureTapView;

@property (nonatomic, strong) NSMutableArray<BXGPlayerViewDelegate> *delegates;
@property (nonatomic, strong) NSTimer *playerTimer;
@property (nonatomic, strong) NSDate *lastOperationDate;
@end

@implementation BXGPlayerView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)installHideComponentsTimer {
    
    self.playerTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(playerTimerAction) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:self.playerTimer forMode:NSRunLoopCommonModes];
    self.lastOperationDate = [NSDate new];
}

- (void)uninstallHideComponentsTimer {
    
    [self.playerTimer invalidate];
    self.playerTimer = nil;
}


- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if(self.superview) {
        
        [self installHideComponentsTimer];
    }else {
        [self uninstallHideComponentsTimer];
        [self.delegates removeAllObjects];
        self.delegates = nil;
    }
}

- (void)dealloc {
        
}

#pragma mark - delegates

// 懒加载
- (NSMutableArray<BXGPlayerViewDelegate> *)delegates {
    
    if(_delegates == nil) {
        
        _delegates = [NSMutableArray<BXGPlayerViewDelegate> new];
    }
    return _delegates;
}

// 添加代理
- (void)addDelegate:(id<BXGPlayerViewDelegate>)delegate {
    
    // 1.空则返回
    if(delegate == nil) {
        
        return;
    }
    
    // 2.重复则返回
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if(self.delegates[i] == delegate) {
            return;
        }
    }
    
    // 3.添加代理
    [self.delegates addObject:delegate];
}

// 移除代理
- (void)removeDelegate:(id<BXGPlayerViewDelegate>)delegate {
    
    // 1.空则返回
    if(delegate == nil) {
        
        return;
    }
    
    // 2.重复则删除
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if(self.delegates[i] == delegate) {
            [self.delegates removeObject:delegate];
            return;
        }
    }
}

#pragma mark - ui

- (UIView *)componentsTapView {
    
    if(_componentsTapView == nil) {
        
        _componentsTapView = [UIView new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapGesture:)];
        [_componentsTapView addGestureRecognizer:tap];
    }
    return _componentsTapView;
}

- (UIView *)gestureTapView {
    
    if(_gestureTapView == nil) {
        
        _gestureTapView = [UIView new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapGesture:)];
        [_gestureTapView addGestureRecognizer:tap];
    }
    return _gestureTapView;
}

#pragma mark - response

- (void)onTapGesture:(UITapGestureRecognizer *)tap {
    if(self.componentsView.hidden) {
        [self setHideComponentsView:false];
    }else {
        [self setHideComponentsView:true];
    }
}

- (void)playerTimerAction; {
    
    if(self.lastOperationDate) {
        if([self.lastOperationDate timeIntervalSinceNow] <= -4) {
            
            [self setHideComponentsView:true];
            self.lastOperationDate = nil;
        }
    }
}

#pragma mark - ui

- (UIView *)backgroundView {
    
    if(_backgroundView == nil) {
        
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [UIColor blackColor];
    }
    return _backgroundView;
}

- (UIView *)mediaView {
    
    if(_mediaView == nil) {
        
        _mediaView = [UIView new];
    }
    return _mediaView;
}

- (UIView *)floatView {
    
    if(_floatView == nil) {
        
        _floatView = [UIView new];
    }
    return _floatView;
}

- (BXGPlayerGestrueView *)gestrueView {
    
    if(_gestrueView == nil) {
        
        _gestrueView = [BXGPlayerGestrueView new];
    }
    return _gestrueView;
}

- (void)responseGestrueView {
    
    self.lastOperationDate = [NSDate new];
}

- (UIView *)componentsView {
    
    if(_componentsView == nil) {
        
        _componentsView = [UIView new];
    }
    return _componentsView;
}

- (UIView *)maskView {
    
    if(_maskView == nil) {
        
        _maskView = [UIView new];
    }
    return _maskView;
}

#pragma mark - getter setter

- (void)setHideComponentsView:(BOOL)hide {
    
    if(hide) {
        
        self.gestureTapView.hidden = false;
        self.componentsView.hidden = true;

    }else {
        
        self.gestureTapView.hidden = true;
        self.componentsView.hidden = false;
    }
    
    for (NSInteger i = 0; i < self.delegates.count; i++) {
        
        if([self.delegates[i] respondsToSelector:@selector(playerView:hideComponentsView:)]) {
            
            [self.delegates[i] playerView:self hideComponentsView:hide];
        }
    }
}

#pragma mark - method

- (void)installUI {
    
    UIView *backgroundView = self.backgroundView;
    UIView *mediaView = self.mediaView;
    UIView *floatView = self.floatView;
    BXGPlayerGestrueView *gestrueView = self.gestrueView;
    UIView *componentsView = self.componentsView;
    UIView *componentsTapView = self.componentsTapView;
    UIView *gestureTapView = self.gestureTapView;
    
    [self addSubview:backgroundView];
    [self addSubview:mediaView];
    [self addSubview:floatView];
    [self addSubview:gestrueView];
    [gestrueView addSubview:gestureTapView];
    [gestrueView addSubview:componentsView];
    [componentsView insertSubview:componentsTapView atIndex:0];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    [mediaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    [floatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    [gestrueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    [componentsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    [componentsTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    [gestureTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];

    [self defaultConfig];
}

- (void)defaultConfig {
    
    Weak(weakSelf);
    
    if(!weakSelf.gestrueView.responseBlock) {
        weakSelf.gestrueView.responseBlock = ^(UIView *view) {
            [weakSelf responseGestrueView];
        };
    }
    
    [weakSelf setHideComponentsView:false];
}
@end
