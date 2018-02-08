//
//  BXGMainTabBarController.m
//  Boxuegu
//
//  Created by RW on 2017/4/12.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMainTabBarController.h"
#import "BXGBaseNaviController.h"
#import "BXGUserLoginVC.h"
#import "BXGMessageTool.h"
#import "BXGUserCenter.h"
#import "BXGHomeRootVC.h"
#import "BXGCategoryRootVC.h"
#import "BXGMeOrderVC.h"
#import "BXGStudyRootVC.h"

@interface BXGMainTabBarController () <BXGNotificationDelegate,UITabBarControllerDelegate>
@end

@implementation BXGMainTabBarController

#pragma mark - Override

- (void)dealloc {
    [BXGNotificationTool removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.设置界面
    [self installUI];
    
    // 2.创建子控制器
    [self createChildController];
    
    // 3.添加监听器
    [BXGNotificationTool addObserverForServerError:self];
    [BXGNotificationTool addObserverForUserLogin:self];
    [BXGNotificationTool addObserverForUserExpired:self];
    
    // 4.设置默认选项卡
    self.selectedIndex = 0;
}

#pragma mark - UI

- (BXGBaseNaviController *)rootNavigationVCWithType:(BXGRootNavigationType)type; {
    if(self.viewControllers.count > type) {
        return self.viewControllers[type];
    }else {
        return nil;
    }
}

- (void)installUI {
    // 1.去掉Tabbar的背景层
    [self.tabBar setShadowImage: [UIImage new]];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    [self.tabBar setBackgroundImage:[UIImage new]];
    
    self.tabBar.tintColor = [UIColor colorWithHex:0x38ADFF];
    // 2.添加TabBar顶部分割线
    UIView *spview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
    spview.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [self.tabBar addSubview:spview];
    self.delegate = self;
    // self.tabBar.delegate = self;
    self.tabBar.translucent = false;
    // 3.设置默认选项卡
    self.selectedIndex = 0;
}

/// 创建并添加子控制器
- (void)createChildController {
    [self addChildViewControllerWithClassName:@"BXGHomeRootVC" title: @"首页" iconName: @"标签栏-首页"];
    [self addChildViewControllerWithClassName:@"BXGCategoryRootVC" title: @"分类" iconName: @"标签栏-分类"];
//     [self addChildViewControllerWithClassName:@"BXGCommunityRootVC" title: @"博学圈" iconName: @"标签栏-学习圈"];
    [self addChildViewControllerWithClassName:@"BXGStudyRootVC" title: @"课程" iconName: @"标签栏-课程"];
//    [self addChildViewControllerWithClassName:@"BXGRWTestVC" title: @"测试" iconName: @"标签栏-个人"];
    [self addChildViewControllerWithClassName:@"BXGMeRootVC" title: @"我的" iconName: @"标签栏-个人"];
}

/// 添加子控制器的 Base 方法
- (void)addChildViewControllerWithClassName:(NSString *) className title:(NSString *) title iconName:(NSString *)iconName {
    Class class = NSClassFromString(className);
    NSAssert(class, @"incorrect class name");
    UIViewController *vc = [[class alloc]init];
    vc.title = title;
    BXGBaseNaviController *nav = [[BXGBaseNaviController alloc]initWithRootViewController:vc];
    vc.tabBarItem.image = [[UIImage imageNamed:[iconName stringByAppendingString:@"-未选中"]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:[iconName stringByAppendingString:@"-选中"]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:nav];
}

#pragma mark - 自定义设备旋转

- (BOOL)shouldAutorotate {
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.selectedViewController.supportedInterfaceOrientations;
}

#pragma mark - BXGNotificationDelegate
/// 监听: 用户信息过期 (老)
- (void)catchServerError {
    
    if([BXGUserDefaults share].userModel) {
        
        [BXGUserDefaults share].userModel = nil;
        [BXGNotificationTool postNotificationForUserLogin:false];
        BXGUserLoginVC *vc = [BXGUserLoginVC new];
        vc.view.backgroundColor = [UIColor whiteColor];
        BXGBaseNaviController *nav = [[BXGBaseNaviController alloc]initWithRootViewController:vc];
        for(NSInteger i = 0; i < self.childViewControllers.count; i++) {
        
            if([self.childViewControllers[i] isKindOfClass:[UINavigationController class]]) {
            
            [self.childViewControllers[i] popToRootViewControllerAnimated:false];
            }
        }
        [self.childViewControllers.firstObject presentViewController:nav animated:true completion:nil];
    }
}

/// 监听: 用户信息过期 (新)
- (void)catchUserExpired {
    
    if([BXGUserDefaults share].userModel) {
        
        [BXGUserDefaults share].userModel = nil;
        [BXGNotificationTool postNotificationForUserLogin:false];
        BXGUserLoginVC *vc = [BXGUserLoginVC new];
        vc.view.backgroundColor = [UIColor whiteColor];
        BXGBaseNaviController *nav = [[BXGBaseNaviController alloc]initWithRootViewController:vc];
        for(NSInteger i = 0; i < self.childViewControllers.count; i++) {
            
            if([self.childViewControllers[i] isKindOfClass:[UINavigationController class]]) {
                
                [self.childViewControllers[i] popToRootViewControllerAnimated:false];
            }
        }
        [self.childViewControllers.firstObject presentViewController:nav animated:true completion:nil];
    }
    [BXGMessageTool share].countOfNewMessage = 0;
}

/// 监听: 用户登录登出
- (void)catchUserLoginNotificationWith:(BOOL)isLogin {
    if(isLogin) {
        [[BXGMessageTool share] loadAllNewMessageCountWithFinishedBlock:nil];
    }
    else {
        [BXGMessageTool share].countOfNewMessage = 0;
        [BXGUserCenter share].bannerType = BannerType_Unknow;
    }
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController; {
    NSInteger index = NSNotFound;
    for (NSInteger i = 0; i <tabBarController.viewControllers.count; i++) {
        if(tabBarController.viewControllers[i] == viewController) {
            index = i;
            break;
        }
    }
    // 指定项需要登录
    switch(index) {
        case BXGRootNavigationTypeHome:{
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatMainTabEventTypeHome andLabel:nil];
        }break;
        case BXGRootNavigationTypeCategory:{
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatMainTabEventTypeCategory andLabel:nil];
        }break;
        case BXGRootNavigationTypeCommunity:{
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatMainTabEventTypeCommunity andLabel:nil];
        }break;
        case BXGRootNavigationTypeMe:{
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatMainTabEventTypeMe andLabel:nil];
        }break;
        case BXGRootNavigationTypeStudy:{
            [[BXGBaiduStatistic share] statisticEventString:kBXGStatMainTabEventTypeStudy andLabel:nil];
            if(![BXGUserCenter share].userModel) {
                BXGUserLoginVC *loginVC = [BXGUserLoginVC new];
                BXGBaseNaviController *nav = [[BXGBaseNaviController alloc]initWithRootViewController:loginVC];
                [self presentViewController:nav animated:true completion:nil];
            }
        }break;
    }
}

#pragma mark - 跳转方法
- (void)pushToMeOrderDoneVC {
    [self pushToMeOrderVCWithSelectedType:BXGMeOrderSelectedTypeDone];
}
- (void)pushToMeOrderFailedVC {
    [self pushToMeOrderVCWithSelectedType:BXGMeOrderSelectedTypeWaitingPay];
}

- (void)pushToMeOrderVCWithSelectedType:(BXGMeOrderSelectedType)type {
    self.selectedIndex = BXGRootNavigationTypeMe;
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        if([self.childViewControllers[i] isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)self.childViewControllers[i];
            [nav popToRootViewControllerAnimated:false];
        }
    }
    
    // 跳转到订单
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UINavigationController *nav = (UINavigationController *)self.childViewControllers[BXGRootNavigationTypeMe];
        BXGMeOrderVC *orderVC = [BXGMeOrderVC new];
        orderVC.selectedType = type;
        [nav pushViewController:orderVC animated:false needLogin:true];
        BXGStudyRootVC *vc = self.childViewControllers[BXGRootNavigationTypeStudy].childViewControllers.firstObject;
        if([vc isKindOfClass:BXGStudyRootVC.class]) {
            [vc refresh];
        }
    });
}

- (void)pushToStudyRootVC {
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        if([self.childViewControllers[i] isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)self.childViewControllers[i];
            [nav popToRootViewControllerAnimated:true];
        }
    }
    
    //避免底部出现黑块现象,所以加了一个延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BXGStudyRootVC *vc = self.childViewControllers[BXGRootNavigationTypeStudy].childViewControllers.firstObject;
        if([vc isKindOfClass:BXGStudyRootVC.class]) {
            [vc refresh];
        }
        self.selectedIndex = BXGRootNavigationTypeStudy;
    });
}

- (void)pushToHomeRootVC {
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        if([self.childViewControllers[i] isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)self.childViewControllers[i];
            [nav popToRootViewControllerAnimated:true];
        }
    }
    //避免底部出现黑块现象,所以加了一个延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.selectedIndex = BXGRootNavigationTypeHome;
    });
}

+ (BXGMainTabBarController *)mainViewController {
    return (BXGMainTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}
@end
