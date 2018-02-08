//
//  BXGTopicVC.m
//  Boxuegu
//
//  Created by apple on 2017/11/1.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGTopicVC.h"
#import <WebKit/WebKit.h>

@interface BXGTopicVC () <WKNavigationDelegate>

@end

@implementation BXGTopicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专题页面";
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
    if([BXGVerifyTool verifyHttpProtocolFormat:_urlString.absoluteString]) {
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:_urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
        [webview loadRequest:request];
        //    webview.navigationDelegate = self;
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

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//    NSString *url = navigationAction.request.URL.absoluteString;
//    BOOL tmpBool = false;
//    if(tmpBool) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }




@end
