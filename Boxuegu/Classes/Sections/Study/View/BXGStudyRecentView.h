//
//  BXGStudyRecentView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/28.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BXGHistoryModel.h"
#import "BXGLearnedHistoryModel.h"
#import "BXGFloatTipView.h"

@class BXGBasePlayerVC;
typedef void(^TouchUpInsideBlockType)(BXGBasePlayerVC *vc) ;

@interface BXGStudyRecentView : BXGFloatTipView

@property (nonatomic, strong) BXGHistoryModel *model;
@property (nonatomic, strong) BXGLearnedHistoryModel *lmodel;

@property (nonatomic, copy) TouchUpInsideBlockType touchUpInsideBlock;

@end
