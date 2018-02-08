//
//  MODesViewController.h
//  MOPopWindow
//
//  Created by mynSoo on 2017/1/7.
//  Copyright © 2017年 mynSoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    BottomPop,
    Fall,
    Center
}MotionType;

@interface MOPopWindowController : UIViewController <UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>

@property (nonatomic ,strong) UIView *contentView;
@property (nonatomic, assign) CGFloat animationTime;
@property (nonatomic, assign) CGFloat maskAlpha;
@property (nonatomic, assign) MotionType type;

- (instancetype)initWithContentView:(UIView *)contentView motion:(MotionType)motion;

@end
