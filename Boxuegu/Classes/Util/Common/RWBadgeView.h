//
//  RWBadgeView.h
//  RWBadgeView
//
//  Created by RW on 2017/6/16.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TabbarItemNums 2.0
@interface UITabBar(BadgeView)
- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
@end

@interface RWBadgeView : UIView

@property (nonatomic, assign) NSInteger badgeNumber;
@property (nonatomic, assign) NSInteger badgeFontSize;

@end
