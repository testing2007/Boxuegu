//
//  BXGPlayerSeekView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGPlayerSeekView : UIView
@property (nonatomic, assign) NSInteger firstSec;
- (void)currentTime:(NSInteger)currentSec andDurationTime:(NSInteger)durationTime andOffset:(NSInteger)offset;
//- (void)currentTime:(NSInteger)currentSec andDurationTime:(NSInteger)durationTime;
- (void)currentTime:(NSInteger)currentSec andDurationTime:(NSInteger)durationTime andSeekTime:(NSInteger)seekTime;
@end
