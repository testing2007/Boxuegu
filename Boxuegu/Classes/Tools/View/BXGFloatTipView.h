
//
//  BXGFloatTipView.h
//  Boxuegu
//
//  Created by apple on 2017/11/2.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGBasePlayerVC.h"

#define kCloseFloatTipViewInterval 6

typedef void(^CloseTipViewBlockType)();
typedef void(^TouchUpInsideBlockType)(BXGBasePlayerVC *vc) ;

@interface BXGFloatTipView : UIView

@property (nonatomic, weak) UILabel *recentLabel;
@property (nonatomic, weak) UILabel *markLabel;
@property (nonatomic, weak) UILabel *startMarkLabel;

@property (nonatomic, copy) CloseTipViewBlockType closeTipViewBlock;
@property (nonatomic, copy) TouchUpInsideBlockType touchUpInsideBlock;

@property (nonatomic, strong) NSTimer *closeFloatTipViewTimer;

- (void)loadContent:(id)info;
- (void)launchCloseFloatTipViewTimer;

- (void)closeTipView;

@end
