//
//  RWPopWindowController.h
//  demo-PopView
//
//  Created by RenyingWu on 2017/7/20.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RWPopWindowController : UIViewController <UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>

@property (nonatomic, copy) void(^restrainBlock)(UIView *view);
@property (nonatomic, copy) void(^tapMaskView)();

- (instancetype)initWithRestrainBlock:(void(^)(UIView *view))restrainBlock;

@property (nonatomic, assign) BOOL isCustomAutorotate;
@property (nonatomic, assign) BOOL customShouldAutorotate;
@property (nonatomic, assign) UIInterfaceOrientationMask customSupportedInterfaceOrientations;

@end
