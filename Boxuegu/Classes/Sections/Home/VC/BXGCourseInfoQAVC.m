//
//  BXGCourseInfoQAVC.m
//  boxuegu
//
//  Created by RenyingWu on 2017/10/17.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "BXGCourseInfoQAVC.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>

@interface BXGCourseInfoQAVC () <UIScrollViewDelegate>
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, strong) NSString *courseId;
@end

@implementation BXGCourseInfoQAVC

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
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 解决iOS8.0 webView.scrollView.delegate = self; 崩溃问题
    self.webView.scrollView.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.webView.scrollView.delegate = self;
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
    webView.scrollView.delegate = self;
    
    // Layout
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.bottom.offset(0);
    }];
    self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
}

#pragma mark - Data

- (void)loadData {
    // 加载数据
    NSURL *url = [[BXGNetWorkTool sharedTool] h5ForCourseQAWithCourseId:self.courseId];
//    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
//    [self.webView loadRequest:request];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
    [self.webView loadRequest:request];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.foldDelegate checkFoldWithScrollView:scrollView];
}
@end
