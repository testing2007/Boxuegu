//
//  BXGPayProtocolVC.m
//  Boxuegu
//
//  Created by apple on 2017/11/1.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPayProtocolVC.h"
#import <Webkit/Webkit.h>


@interface BXGPayProtocolVC ()

@end

@implementation BXGPayProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"博学谷用户付费协议";
    [self installUI];
}

#pragma mark - 搭建界面

- (void)installUI {
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    // *** Components
    UIView *separateView = [UIView new];
    [self.view addSubview:separateView];
    
    WKWebView *webview = [[WKWebView alloc]init];
    [self.view addSubview:webview];
    
    // *** Setting
    separateView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    webview.backgroundColor = [UIColor whiteColor];

    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[[BXGNetWorkTool sharedTool] h5ForPaymentAgreement] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
    [webview loadRequest:request];
    // *** Layout
    [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.height.offset(9);
        make.left.right.offset(0);
    }];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.offset(0);
        make.top.equalTo(separateView.mas_bottom).offset(0);
    }];
}

@end
