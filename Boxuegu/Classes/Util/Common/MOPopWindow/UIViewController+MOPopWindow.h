//
//  UIViewController+MOPopWindow.h
//  MOPopWindow
//
//  Created by mynSoo on 2017/1/7.
//  Copyright © 2017年 mynSoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOPopWindowController.h"
#import "RWPopWindowController.h"

@interface UIViewController (MOPopWindow)  


/**
 弹出控制器

 @param viewControllerToPresent viewControllerToPresent description
 @param flag flag description
 @param completion completion description
 */
- (void)mo_presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion; // version 1.0.1

/**
 弹出页面

 @param contentView contentView description
 @param flag flag description
 @param completion completion description
 */
- (void)mo_presentContentView:(UIView *)contentView animated: (BOOL)flag completion:(void (^)(void))completion; // version 1.0.1


/**
 弹出控制器

 @param viewControllerToPresent viewControllerToPresent description
 @param motion motion description
 @param completion completion description
 */
- (void)mo_presentViewController:(UIViewController *)viewControllerToPresent option:(MotionType)motion completion:(void (^)(void))completion; // version 1.0.2

/**
 弹出页面

 @param contentView contentView description
 @param motion motion description
 @param completion completion description
 */
- (void)mo_presentContentView:(UIView *)contentView option:(MotionType)motion completion:(void (^)(void))completion; // version 1.0.2

/**
 弹回最上控制器 / 页面

 @param completion completion description
 */
- (void)mo_dismissLastCompletion:(void (^)(void))completion;
// version 1.0.3


/**
 弹回当前控制器

 @param completion completion description
 */
- (void)mo_dissmissCurrentCompletion:(void (^)(void))completion;
// version 1.0.3

//- (BOOL)shouldAutorotate {
//    
//    if(self.parentViewController) {
//        
//        return [self.parentViewController shouldAutorotate];
//    }else {
//        
//        return true;
//    }
//    
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    
//    if(self.parentViewController) {
//        
//        return [self.parentViewController supportedInterfaceOrientations];
//    }else {
//        
//        return UIInterfaceOrientationMaskAll;
//    }
//}

- (void)rw_presentContentView:(UIView *)contentView restrainBlock:(void(^)(UIView *view))restrainBlock tapMaskBlock:(void(^)())tapMaskBlock completion:(void (^)(void))completion;

- (void)rw_presentContentView:(UIView *)contentView restrainBlock:(void(^)(UIView *view))restrainBlock tapMaskBlock:(void(^)())tapMaskBlock completion:(void (^)(void))completion andShouldAutorotate:(BOOL)shouldAutorotate;



@end
