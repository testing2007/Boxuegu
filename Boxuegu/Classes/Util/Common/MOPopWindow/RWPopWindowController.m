//
//  RWPopWindowController.m
//  demo-PopView
//
//  Created by RenyingWu on 2017/7/20.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "RWPopWindowController.h"
#import "Masonry.h"

typedef enum
{
    TransitionTypePresent,
    TransitionTypeDismiss
}TransitionType;

@interface RWPopWindowController ()
@property (nonatomic, assign) TransitionType transitionType;
@property (nonatomic, strong) UIView *mask; // 强指针
@end

@implementation RWPopWindowController

- (BOOL)shouldAutorotate {
    
    
    if(self.isCustomAutorotate){
    
        return self.customShouldAutorotate;
    }
    
    if(self.parentViewController) {
    
        return [self.parentViewController shouldAutorotate];
    }else {
    
        return true;
    }
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if(self.isCustomAutorotate){
    
        return _customSupportedInterfaceOrientations;
    }
    
    if(self.parentViewController) {
        
        return [self.parentViewController supportedInterfaceOrientations];
    }else {
        
        return UIInterfaceOrientationMaskAll;
    }
}

- (instancetype)init {
    
    self = [super init];
    if(self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Mask View
    UIView *maskView = [UIView new];
    // maskView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:maskView];
    
//    self.view.translatesAutoresizingMaskIntoConstraints = false;
    maskView.translatesAutoresizingMaskIntoConstraints = false;
    // self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:maskView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem: maskView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:  maskView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:maskView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
//    [self.view layoutIfNeeded];
    
    
//    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.top.right.offset(0);
//    }];
    // Content View
    if(self.restrainBlock) {
    
        self.restrainBlock(maskView);
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMaskView:)];
    [maskView addGestureRecognizer:tap];
}

- (void)tapMaskView:(UITapGestureRecognizer *)tap {

    if(self.tapMaskView) {
    
        self.tapMaskView();
    }
}

- (instancetype)initWithRestrainBlock:(void(^)(UIView *view))restrainBlock; {

    self = [self init];
    
    self.restrainBlock = restrainBlock;
    return self;
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
        
        [containerView addSubview:self.mask];
        [containerView addSubview:deVC.view];
        self.mask.alpha = 0.0;
        containerView.alpha = 0.0;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.mask.alpha = 0.4;
            containerView.alpha = 1;
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
        }];
        
        

    }
    
    // dismiss
    else
    {
        self.mask.alpha = 0.4;
        containerView.alpha = 1;
        [UIView animateWithDuration:0.2 animations:^{
            
            self.mask.alpha = 0.0;
            containerView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [self.mask removeFromSuperview];
        }];
        
       
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
