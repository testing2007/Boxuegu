//
//  BXGMeAboutViewController.m
//  Boxuegu
//
//  Created by HM on 2017/4/14.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMeAboutVC.h"
#import <WebKit/WebKit.h>
#import "BXGUserCenter.h"


@interface BXGMeAboutVC () <UIWebViewDelegate>
@property (nonatomic, copy) NSString *shortVersion;
@end

@implementation BXGMeAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"关于";
    self.view.backgroundColor = [UIColor whiteColor];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info.plist" ofType:nil];
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithContentsOfFile:path];
    self.shortVersion = infoDict[@"CFBundleShortVersionString"];
    
    [self installUI];

}

- (void)installUI {

    self.automaticallyAdjustsScrollViewInsets = false;
    
    UIView *separateView = [UIView new];
    [self.view addSubview:separateView];
    separateView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.height.offset(9);
        make.left.right.offset(0);
    }];
    
    // WKWebView *webView = [WKWebView new];
    UIWebView *webView = [UIWebView new];
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(separateView.mas_bottom).offset(0);
    }];
    
    NSURL *url = [[BXGNetWorkTool sharedTool] h5ForAppAbout];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    webView.delegate = self;

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return true;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if(self.shortVersion) {
    
        NSString *evaluatingString = [NSString stringWithFormat:@"document.getElementsByTagName('h3')[0].innerHTML = '博学谷 %@';",self.shortVersion];
        
        [webView stringByEvaluatingJavaScriptFromString:evaluatingString];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}
@end
