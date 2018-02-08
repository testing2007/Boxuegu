////
////  RWCountdownBtn.m
////  Boxuegu
////
////  Created by apple on 2018/1/15.
////  Copyright © 2018年 itcast. All rights reserved.
////
//
//#import "RWCountdownBtn.h"
//
//@interface RWCountdownBtn()
//@property (nonatomic, strong) NSTimer *checkDateTimer;
//@property (nonatomic, assign) NSInteger timeInterval;
//@end
//
//@implementation RWCountdownBtn
//
//- (instancetype)initWithTitle:(NSString*)title andTimeInterval:(NSInteger)timeInterval {
//    self = [super init];
////    self setTi
//}
//
//- (void)timeEnable:(BOOL)bEnable {
//    
//}
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/
//
//- (instancetype)initWithTitle:(NSString*)title andTimeInterval:(NSInteger)timeInterval {
//    self = [super init];
//    if(self) {
//        
//    }
//    return self;
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    
//    [super viewWillAppear:animated];
//    
//#pragma mark 状态栏样式
//    // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    
//#pragma mark 动态码初始化部分
//    
//    [self checkCurrentDate];
//    // 设置 Timer
//    self.checkDateTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(checkCurrentDate) userInfo:nil repeats:true];
//    [[NSRunLoop currentRunLoop] addTimer:self.checkDateTimer forMode:NSRunLoopCommonModes];
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    
//    [super viewDidDisappear:animated];
//    
//    // 移除 Timer
//    [self.checkDateTimer invalidate];
//    [self resignFirstResponder];
//}
//
//#pragma mark - Operation
//
//- (void)checkCurrentDate {
//    
//    if(self.lastGetVCodeDate){
//        
//        NSTimeInterval preTimeInterval = [self.lastGetVCodeDate timeIntervalSinceNow];
//        NSInteger countdown = kGetVCodeCountdownTime + (NSInteger)preTimeInterval;
//        
//        if(countdown >= 0) {
//            
//            // 更新 按钮时间
//            [self.getVCodeBtn setTitle:[@(countdown).description stringByAppendingString:@" S"] forState:UIControlStateNormal];
//            self.getVCodeBtn.enabled = false;
//            return;
//        }
//    }
//    
//    [self.getVCodeBtn setTitle:kGetVCodeString forState:UIControlStateNormal];
//    self.getVCodeBtn.enabled = true;
//    
//    
//    //getVCodeBtn
//}
//
//@end

