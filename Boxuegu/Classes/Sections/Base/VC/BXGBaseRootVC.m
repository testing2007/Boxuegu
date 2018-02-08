//
//  BXGBaseRootVC.m
//  Boxuegu
//
//  Created by HM on 2017/5/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseRootVC.h"

#import "UIImage+Extension.h"
#import "UIColor+Extension.h"

#import "BXGUserLoginVC.h"
#import "BXGMeMyMessageVC.h"

@interface BXGBaseRootVC ()
@property (nonatomic, weak) UIView *topContentView;
@end

@implementation BXGBaseRootVC

- (BOOL)shouldAutorotate {
    return true;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Getter Setter

- (BXGHUDTool *)hudTool {
    
    if(!_hudTool){
        
        _hudTool = [BXGHUDTool share];
    }
    return _hudTool;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets =false;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.topView = [UIView new];
    self.topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.topView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.offset(0);
        if(self.navigationController){
        
            make.top.offset(64);
        }else {
        
            make.top.offset(0);
        }
        
        make.height.offset(0);
    }];
    
//    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 20)];
//    topView.backgroundColor = [UIColor blackColor];
//    self.view.bounds = CGRectMake(0, -20, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // [self installStatusBar];
    [self installNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    // [[BXGHUDTool share] closeHUD];
    
}

#pragma mark - 自定义状态栏
- (void)installStatusBar {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - 自定义导航栏
- (void)installNavigationBar {
    
    
//    self.navigationController.navigationBar.bounds.size.height
//    self.statusbar
//    UIView *navibackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.navigationController.navigationBar.bounds.size.height + self.navigationController.navigationBar.frame.origin.y)];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
//    UIView *navibackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
        UIView *navibackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, K_NAVIGATION_BAR_OFFSET)];
    [self.view insertSubview:navibackgroundView belowSubview:self.view.subviews[0]];
    navibackgroundView.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    self.navibackgroundView = navibackgroundView;
}

- (void)installTranslucentNavigationBar{
    
    // NavigationBar 透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(BOOL)prefersStatusBarHidden {
    
    return false;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}





//- (void)installNavigationItems {
//    
//    
//    UIButton *checkItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//     
//    [checkItemBtn setImage:[UIImage imageNamed:@"导航栏-签到"] forState:UIControlStateNormal];
//    [checkItemBtn setTitle: @"签到" forState:UIControlStateNormal];
//    
//    
//    
//    
//    UIButton *rankItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rankItemBtn setImage:[UIImage imageNamed:@"导航栏-榜单"] forState:UIControlStateNormal];
//    [rankItemBtn setTitle: @"榜单" forState:UIControlStateNormal];
//    
//    UIButton *downlaodItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [downlaodItemBtn setImage:[UIImage imageNamed:@"导航栏-下载"] forState:UIControlStateNormal];
//    [downlaodItemBtn setTitle: @"下载" forState:UIControlStateNormal];
//    
//    UIButton *historyItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [historyItemBtn setImage:[UIImage imageNamed:@"导航栏-观看"] forState:UIControlStateNormal];
//    [historyItemBtn setTitle: @"观看" forState:UIControlStateNormal];
//    
//    [checkItemBtn addTarget:self action:@selector(onClickCheckItem) forControlEvents:UIControlEventTouchUpInside];
//    [rankItemBtn addTarget:self action:@selector(onClickRankItem) forControlEvents:UIControlEventTouchUpInside];
//    [downlaodItemBtn addTarget:self action:@selector(onClickHistoryItem) forControlEvents:UIControlEventTouchUpInside];
//    [historyItemBtn addTarget:self action:@selector(onClickDownloadItem) forControlEvents:UIControlEventTouchUpInside];
//    
//    checkItemBtn.bounds = CGRectMake(0, 0, 25, 25);
//    rankItemBtn.bounds = CGRectMake(0, 0, 25, 25);
//    downlaodItemBtn.bounds = CGRectMake(0, 0, 25, 25);
//    historyItemBtn.bounds = CGRectMake(0, 0, 25, 25);
//    
//    // 打卡 item
//    UIBarButtonItem *checkItem = [[UIBarButtonItem alloc]initWithCustomView:checkItemBtn];
//    
//    //
//    // 榜单 item
//    UIBarButtonItem *rankItem = [[UIBarButtonItem alloc]initWithCustomView:rankItemBtn];
//    
//    // 观看item
//    UIBarButtonItem *downlaodItem = [[UIBarButtonItem alloc]initWithCustomView:downlaodItemBtn];
//    
//    // 下载item
//    UIBarButtonItem *historyItem = [[UIBarButtonItem alloc]initWithCustomView:historyItemBtn];
//    
//    
//    
//    checkItemBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -checkItemBtn.imageView.bounds.size.width - 2.5, -checkItemBtn.imageView.bounds.size.height - 0, 0);
//    checkItemBtn.imageEdgeInsets = UIEdgeInsetsMake(-checkItemBtn.titleLabel.bounds.size.height - 0, 0, 0, -checkItemBtn.titleLabel.bounds.size.width);
//    checkItemBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:10];
//    [checkItemBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
//    
//    
//    rankItemBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -rankItemBtn.imageView.bounds.size.width - 2.5, -rankItemBtn.imageView.bounds.size.height - 0, 0);
//    rankItemBtn.imageEdgeInsets = UIEdgeInsetsMake(-rankItemBtn.titleLabel.bounds.size.height - 0, 0, 0, -rankItemBtn.titleLabel.bounds.size.width);
//    rankItemBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:10];
//    [rankItemBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
//    
//    downlaodItemBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -downlaodItemBtn.imageView.bounds.size.width - 2.5, -downlaodItemBtn.imageView.bounds.size.height - 0, 0);
//    downlaodItemBtn.imageEdgeInsets = UIEdgeInsetsMake(-downlaodItemBtn.titleLabel.bounds.size.height - 0, 0, 0, -downlaodItemBtn.titleLabel.bounds.size.width);
//    downlaodItemBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:10];
//    [downlaodItemBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
//    
//    historyItemBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -historyItemBtn.imageView.bounds.size.width - 2.5, -historyItemBtn.imageView.bounds.size.height - 0, 0);
//    historyItemBtn.imageEdgeInsets = UIEdgeInsetsMake(-historyItemBtn.titleLabel.bounds.size.height - 0, 0, 0, -historyItemBtn.titleLabel.bounds.size.width);
//    historyItemBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:10];
//    [historyItemBtn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
//    
//    
//    // 设置左item
//    // self.navigationItem.leftBarButtonItems = @[checkItem, rankItem];
//    
//    // 设置右ite
//    
//
//    
//}
- (void)actionToMessage
{
    RWLog(@"跳转到我的消息");
    BXGMeMyMessageVC *vc = [BXGMeMyMessageVC new];
    if(self.navigationController) {
    
        [self.navigationController pushViewController:vc animated:true needLogin:true];
    }
}


@end
