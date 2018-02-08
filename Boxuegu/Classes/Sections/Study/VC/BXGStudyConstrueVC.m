//
//  BXGStudyConstrueVC.m
//  Boxuegu
//
//  Created by RW on 2017/5/17.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudyConstrueVC.h"
#import <WebKit/WebKit.h>
#import <MediaPlayer/MediaPlayer.h>


/**
 串讲直播页面控制器
 */
@interface BXGStudyConstrueVC ()

/// 状态栏和导航栏异常 - 临时解决方案计数器
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation BXGStudyConstrueVC

#pragma mark - Life Cycle
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self installUI];
    [self fix];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [self.timer invalidate];
    [super viewDidDisappear:animated];
}

#pragma mark - install UI

- (void)installUI {

    //self.model.chuanjiang_room_link = @"12312-a\你\\n\n\n381231938210938182030y1030123";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if(self.model){
        
        self.navigationItem.title = self.model.chuanjiang_name;
        
        WKWebView *webView = [WKWebView new];
        webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.top.offset(K_NAVIGATION_BAR_OFFSET + 9);
        }];
        
        if(self.model.chuanjiang_room_link){
            
//            NSString *urlString = [self.model.chuanjiang_room_link stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *url = [NSURL URLWithString:self.model.chuanjiang_room_link];
            if(!url){
                
                return;
            }
        
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
//            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [webView loadRequest: request];
        }
    }
}

#pragma mark - fix

// 状态栏和导航栏异常 - 临时解决方案
- (void)fix{

    NSTimer *timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(updataUI) userInfo:nil repeats:true];
    
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)updataUI{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if(self.navigationController)
    {
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44);
    }
}

@end
