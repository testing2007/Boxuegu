//
//  BXGUserAgreementController.m
//  Boxuegu
//
//  Created by RW on 2017/4/13.
//  Copyright © 2017年 itcast. All rights reserved.
//
#import "BXGUserAgreementVC.h"
#import <WebKit/WebKit.h>

@interface BXGUserAgreementVC ()

@end

@implementation BXGUserAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"协议服务";
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
    webview.scrollView.delegate = nil;//连续点击服务协议进入后,协议内容还未加载出来(看上去有空白), 滑动UIWebView出现崩溃现象
    
    // *** Setting
    separateView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    webview.backgroundColor = [UIColor whiteColor];
    NSURL *url = [[BXGNetWorkTool sharedTool] h5ForAgreement];
//    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[[BXGNetWorkTool sharedTool] h5ForAgreement]]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
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
