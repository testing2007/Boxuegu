//
//  BXGStudyFeedbackVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudyFeedbackVC.h"
#import <WebKit/WebKit.h>

@interface BXGStudyFeedbackVC ()

@end

@implementation BXGStudyFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.title = @"学习反馈";
    self.pageName = @"学习反馈详情";
    // *** Components
    UIView *separateView = [UIView new];
    [self.view addSubview:separateView];
    
    WKWebView *webview = [[WKWebView alloc]init];
    [self.view addSubview:webview];
    
    // *** Setting
    separateView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    webview.backgroundColor = [UIColor whiteColor];
    
    if(self.link) {
        NSURL *url = [NSURL URLWithString:self.link];
        if(url){
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
            [webview loadRequest:request];
        }
    }

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
