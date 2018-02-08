//
//  UIView+Pop.h
//  Boxuegu
//
//  Created by apple on 2017/10/30.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CancelBlockType)(void);
@interface UIView (Pop)


/**
 显示在windows上, 可以设备背景透明度.

 @param alpha 默认 0.2 传 -1 代表默认值
 */
- (void)showInWindowAndBgAlpha:(CGFloat)alpha
                andCancelBlock:(CancelBlockType)cancelBlock
         andMaskViewConstraint:(void (^)(MASConstraintMaker *make))constraint;


/**
 隐藏视图
 */
- (void)hideView;

@property(nonatomic, copy) CancelBlockType cancelBlock;

@end
