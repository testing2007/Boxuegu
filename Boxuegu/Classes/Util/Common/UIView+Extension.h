//
//  UIView+Extension.h
//  Boxuegu
//
//  Created by apple on 17/6/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

//吸顶动画显示
-(void)sinkMessageAnimationDuration:(NSTimeInterval)timeDuration delayTimeInterval:(NSTimeInterval)delayTimeInterval;

-(UIViewController*)findOwnerVC;

@end
