//
//  BXGBaseViewController.m
//  Boxuegu
//
//  Created by HM on 2017/5/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewController.h"
#import "UIImage+Extension.h"
#import "BXGUserLoginVC.h"
#import "BXGUserCenter.h"
#import "BXGBaiduStatistic.h"

@interface BXGBaseViewController ()

@end

@implementation BXGBaseViewController

#pragma mark - Getter Setter

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

-(BOOL)isNeedPresentLoginBlock:(void (^)())completion
{
    if(![BXGUserCenter share].userModel)
    {
        BXGUserLoginVC *loginVC = [BXGUserLoginVC new];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:loginVC];
        //[self presentViewController:nvc animated:YES completion:nil];
        [self presentViewController:nvc animated:YES completion:completion];
        return YES;
    }
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if(self.pageName.length > 0) {
        
        [[BXGBaiduStatistic share] pageviewStartWithName:self.pageName];
        return;
    }
    if(self.title.length > 0) {
        
        [[BXGBaiduStatistic share] pageviewStartWithName:self.title];
        return;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if(self.pageName.length > 0) {
        
        [[BXGBaiduStatistic share] pageviewEndWithName:self.pageName];
        return;
    }
    if(self.title.length > 0) {
        
        [[BXGBaiduStatistic share] pageviewEndWithName:self.title];
        return;
    }
}

- (CGFloat)topOffset {
    if(self.navigationController) {
        // 判断是否是iPhoneX
         return 64;
    }else {
        return 0;
    }
}

- (BXGMainTabBarController *)mainViewController {
    return (BXGMainTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}
@end
