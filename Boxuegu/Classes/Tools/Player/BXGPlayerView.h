//
//  BXGPlayerView.h
//  RWPlayer
//
//  Created by RenyingWu on 2017/12/12.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGPlayerGestrueView.h"

@class BXGPlayerView;

@protocol BXGPlayerViewDelegate
- (void)playerView:(BXGPlayerView *)playerView hideComponentsView:(BOOL)isHidden;
@end

@interface BXGPlayerView : UIView

// UI
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *mediaView;
@property (nonatomic, strong) UIView *floatView;
@property (nonatomic, strong) BXGPlayerGestrueView *gestrueView;
@property (nonatomic, strong) UIView *componentsView;
@property (nonatomic, strong) UIView *maskView;

// Delegate
- (void)addDelegate:(id<BXGPlayerViewDelegate>)delegate;
- (void)removeDelegate:(id<BXGPlayerViewDelegate>)delegate;

// method

// 开始布局
- (void)installUI;
- (void)setHideComponentsView:(BOOL)hide;

@end
