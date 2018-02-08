//
//  UIViewController+MOPopWindow.m
//  MOPopWindow
//
//  Created by mynSoo on 2017/1/7.
//  Copyright © 2017年 mynSoo. All rights reserved.
//

#import "UIViewController+MOPopWindow.h"




@interface  UIViewController() <UIViewControllerAnimatedTransitioning>

@end

@implementation UIViewController (MOPopWindow)

-(void)installTransition
{
    self.modalPresentationStyle = UIModalPresentationCustom;
}

-(void)mo_presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion
{

    MOPopWindowController *popWindowController = [[MOPopWindowController alloc]initWithContentView:viewControllerToPresent.view motion:BottomPop];
    
    [popWindowController addChildViewController:viewControllerToPresent];
    
    [self installTransition];
    
    [self mo_presentLastViewController:popWindowController completion:completion];
    
}

-(void)mo_presentContentView:(UIView *)contentView animated: (BOOL)flag completion:(void (^)(void))completion
{
    
    MOPopWindowController *popWindowController = [[MOPopWindowController alloc]initWithContentView:contentView motion:BottomPop];
    
    [self installTransition];
    
    [self mo_presentLastViewController:popWindowController completion:completion];
}

-(void)mo_presentViewController:(UIViewController *)viewControllerToPresent option:(MotionType)motion completion:(void (^)(void))completion
{
    
    MOPopWindowController *popWindowController = [[MOPopWindowController alloc]initWithContentView:viewControllerToPresent.view motion:motion];
    
    [popWindowController addChildViewController:viewControllerToPresent];
    
    popWindowController.type = motion;
    
    [self installTransition];

    [self mo_presentLastViewController:popWindowController completion:completion];
}

-(void)mo_presentContentView:(UIView *)contentView option:(MotionType)motion completion:(void (^)(void))completion
{
    
    MOPopWindowController *popWindowController = [[MOPopWindowController alloc]initWithContentView:contentView motion:motion];
    
    popWindowController.type = motion;
    
    [self installTransition];
    
    [self mo_presentLastViewController:popWindowController completion:completion];
    
}

- (void)mo_presentLastViewController:viewController completion:(void (^)(void))completion
{
    if(self.presentedViewController)
    {
        [self.presentedViewController mo_presentLastViewController:viewController completion:completion];
    }
    else
    {
        [self presentViewController:viewController animated:true completion:completion];
    }
    
}
- (void)mo_dismissLastCompletion:(void (^)(void))completion
{
    if(self.presentedViewController)
    {
        [self.presentedViewController mo_dismissLastCompletion:completion];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:completion];
    }
}

- (void)mo_dissmissCurrentCompletion:(void (^)(void))completion
{
    [self dismissViewControllerAnimated:YES completion:completion];
}

- (void)rw_presentContentView:(UIView *)contentView restrainBlock:(void(^)(UIView *view))restrainBlock tapMaskBlock:(void(^)())tapMaskBlock completion:(void (^)(void))completion; {// version 2.0 {
    
    RWPopWindowController *popWindowController = [[RWPopWindowController alloc] init];
    popWindowController.restrainBlock = restrainBlock;
    popWindowController.tapMaskView = tapMaskBlock;
    //    if(restrainBlock){
    //
    //        self.restrainBlock(popWindowController.view)
    //    }
    //    popWindowController.type = motion;
    
    [self installTransition];
    
    [self mo_presentLastViewController:popWindowController completion:completion];
}

- (void)rw_presentContentView:(UIView *)contentView restrainBlock:(void(^)(UIView *view))restrainBlock tapMaskBlock:(void(^)())tapMaskBlock completion:(void (^)(void))completion andShouldAutorotate:(BOOL)shouldAutorotate{

    RWPopWindowController *popWindowController = [[RWPopWindowController alloc] init];
    popWindowController.restrainBlock = restrainBlock;
    popWindowController.tapMaskView = tapMaskBlock;
    
    if(!shouldAutorotate){
    
        popWindowController.isCustomAutorotate = true;
        popWindowController.customSupportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
        popWindowController.customShouldAutorotate = false;
    }
    
    [self installTransition];
    
    [self mo_presentLastViewController:popWindowController completion:completion];
}


@end
