//
//  BXGStudyPlayerDownloadVC.m
//  Boxuegu
//
//  Created by HM on 2017/6/2.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudyPlayerDownloadVC.h"

@interface BXGStudyPlayerDownloadVC ()

@end

@implementation BXGStudyPlayerDownloadVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self installUI];
}

#pragma mark - Install UI

- (void)installUI {
    
    self.title = @"下载";
    
    // 两个按钮
    UIButton *videoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    
    [self.view addSubview:videoBtn];
    
    [videoBtn setTitle:@"点击下载" forState:UIControlStateNormal];
    
    [videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.offset(15);
        make.height.offset(100);
        make.right.offset(-15);
    }];
    
    [videoBtn addTarget:self action:@selector(clickVideoBtnBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - Response

- (void)clickVideoBtnBtn:(UIButton *)sender{
    
    RWLog(@"点击下载");
    
    [self.navigationController popViewControllerAnimated:true];
    
}



@end
