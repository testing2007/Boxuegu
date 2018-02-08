//
//  BXGMeDownloadDetailVC.m
//  Boxuegu
//
//  Created by HM on 2017/6/2.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMeDownloadDetailVC.h"
#import "BXGMeOfflinePlayerVC.h"

@interface BXGMeDownloadDetailVC ()

@end

@implementation BXGMeDownloadDetailVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self installUI];
}

#pragma mark - Install UI

- (void)installUI {
    
    self.title = @"下载管理详情页";
    
    // 两个按钮
    UIButton *videoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    
    [self.view addSubview:videoBtn];
    
    [videoBtn setTitle:@"点击已完成项" forState:UIControlStateNormal];
    
    [videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(64);
        make.left.offset(15);
        make.height.offset(100);
        make.right.offset(-15);
    }];
    
    [videoBtn addTarget:self action:@selector(clickVideoBtnBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - Response

- (void)clickVideoBtnBtn:(UIButton *)sender{
    
    RWLog(@"点击已完成项");
    BXGMeOfflinePlayerVC *vc = [BXGMeOfflinePlayerVC new];
    [self.navigationController pushViewController:vc animated:true];
    
    // [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
