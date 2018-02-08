//
//  BXGCourseInfoDetailVC.m
//  boxuegu
//
//  Created by RenyingWu on 2017/10/17.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "BXGCourseInfoDetailVC.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>

@interface BXGCourseInfoDetailVC () <UIScrollViewDelegate,WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, strong) NSString *courseId;
@end

@implementation BXGCourseInfoDetailVC

#pragma mark - Override
- (instancetype)initWithCourseId:(NSString *)courseId; {
    self = [super init];
    if(self){
        _courseId = courseId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self installUI];
    self.webView.scrollView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

#pragma mark - UI

- (void)installUI {
    // Define
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:webView];
    self.webView = webView;
    
    // Config
    if (@available(iOS 11.0, *)) {
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    // Layout
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.bottom.offset(0);
    }];
    
    [self loadData];
}

- (void)dealloc
{
    // 解决iOS8.0 webView.scrollView.delegate = self; 崩溃问题
    self.webView.scrollView.delegate = nil;
}

#pragma mark - Data

- (void)loadData {
    // 加载数据

//    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
//    [self.webView loadRequest:request];
    NSURL *url = [[BXGNetWorkTool sharedTool] h5ForCourseDetailsWithCourseId:self.courseId];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
    [self.webView loadRequest:request];
    self.webView.navigationDelegate = self;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.foldDelegate checkFoldWithScrollView:scrollView];
}
@end
