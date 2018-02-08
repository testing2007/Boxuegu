//
//  BXGConstrueLivePlayerView.h
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/15.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGLivePlayerView.h"

@interface BXGConstrueLivePlayerView : BXGLivePlayerView

@property (nonatomic, assign) BOOL isFullScreen;
@property (nonatomic, copy) void(^changePlayerViewSizeBlock)(BOOL isFUllScreen);

@end
