//
//  MODesViewController.m
//  MOPopWindow
//
//  Created by mynSoo on 2017/1/7.
//  Copyright © 2017年 mynSoo. All rights reserved.
//

#import "MOPopWindowController.h"
typedef enum
{
    TransitionTypePresent,
    TransitionTypeDismiss
}TransitionType;

@interface MOPopWindowController ()

@property (nonatomic, strong) UIView *mask;
@property (nonatomic, assign) TransitionType transitionType;
@property (nonatomic, assign) CGFloat damping;
@property (nonatomic, assign) CGFloat velocity;
@end

@implementation MOPopWindowController

- (BOOL)shouldAutorotate {
    return true;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.maskAlpha = 0.2;
        self.animationTime = 0.5;
        self.damping = 1;
        self.velocity = 1;
        self.type = BottomPop;
        
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    return self;
}

- (instancetype)initWithContentView:(UIView *)contentView motion:(MotionType)motion
{
    self = [self init];
    if(self)
    {
        self.type = motion;
        self.contentView = contentView;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.contentView)
    {
        [self.view addSubview:self.contentView];
        switch (self.type) {
            case BottomPop:
            {
                self.contentView.frame = CGRectOffset(self.contentView.frame, 0,[UIScreen mainScreen].bounds.size.height - self.contentView.frame.size.height);
            }break;
                
            case Fall:
            {
                self.contentView.frame = self.view.frame;
                self.damping = 0.5;
                self.velocity = 0.5;
            }break;
                
            default:
                self.contentView.frame = self.view.frame;
                break;
        }
    }
}


-(UIView *)mask
{
    if(!_mask)
    {
        UIView *mask = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        mask.backgroundColor = [UIColor blackColor];
        _mask = mask;
    }
    return _mask;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    
    // 获得控制器
    UIView *containerView = [transitionContext containerView];
    
    UIViewController * deVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController * sourceVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    deVC.view.userInteractionEnabled = YES;
    sourceVC.view.userInteractionEnabled = NO;
    
    
    // present
    if(self.transitionType == TransitionTypePresent)
    {
        
        [containerView addSubview:deVC.view];
        
        [sourceVC.view addSubview:self.mask];
        self.mask.alpha = 0;
        
        switch (self.type) {
            case BottomPop:
            {
                deVC.view.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height);
            }break;
            case Fall:
            {
                deVC.view.transform = CGAffineTransformMakeTranslation(0, -[UIScreen mainScreen].bounds.size.height);
            }break;
            default:
            {
            }break;
        }
    
        [UIView animateWithDuration:0.1 delay:0 usingSpringWithDamping:self.damping initialSpringVelocity:self.velocity options:UIViewAnimationOptionTransitionNone animations:^{
            
            self.mask.alpha = 0.4;
            
            deVC.view.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            
        }];
    }
    // dismiss
    else
    {
        self.mask.alpha = 0.4;
        
        // 动画时间
        [UIView animateWithDuration:0.1 animations:^{
            
            // sourceVC.view.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height);
            self.mask.alpha = 0.0;
            sourceVC.view.alpha = 0.0;
            
            //sourceVC.view.alpha = 0.2;
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
            [self.mask removeFromSuperview];
        }];
//        [transitionContext completeTransition:YES];
//        [self.mask removeFromSuperview];
    }
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;
{
    self.transitionType = TransitionTypePresent;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;
{
    self.transitionType = TransitionTypeDismiss;
    return self;
}

@end
