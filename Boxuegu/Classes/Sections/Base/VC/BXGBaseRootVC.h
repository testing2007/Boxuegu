//
//  BXGBaseRootVC.h
//  Boxuegu
//
//  Created by HM on 2017/5/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGBaseRootVC : BXGBaseViewController
@property (nonatomic, weak) BXGHUDTool *hudTool;
- (void)installTranslucentNavigationBar;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, weak) UIView *navibackgroundView;
- (void)installNavigationBar;
- (void)actionToMessage;



@end
