//
//  BXGUserForgetVC.m
//  Boxuegu
//
//  Created by HM on 2017/6/2.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGUserForgetVC.h"
#import "BXGUserResetPswVC.h"
#import "BXGUserViewModel.h"
#import "BXGUserDefaults.h"
#import "BXGRoundedBtn.h"

#define kGetVCodeCountdownTime 90
#define kGetVCodeString @"获取动态码"

@interface BXGUserForgetVC () <UITextFieldDelegate>

/// UserViewModel
@property (nonatomic, weak) BXGUserViewModel *viewModel;

/// 获取动态码计数器
@property (nonatomic, strong) NSTimer *checkDateTimer;

/// 获取动态码倒计时时间
@property (nonatomic, strong) NSDate *lastGetVCodeDate;

/// 获取动态码按钮
@property (nonatomic, weak) UIButton *getVCodeBtn;

@property (nonatomic, weak)UITextField *userMobileField;
@property (nonatomic, weak)UITextField *codeField;

@property (nonatomic, weak) UIScrollView *scrollview;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, weak) UIButton *nextBtn;


@end

@implementation BXGUserForgetVC

#pragma mark - Getter Setter

- (BXGUserViewModel *)viewModel {
    
    if(!_viewModel){
        
        _viewModel = [BXGUserViewModel share];
    }
    return _viewModel;
}

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
#pragma mark 状态栏样式
    // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
#pragma mark 动态码初始化部分

    [self checkCurrentDate];
    // 设置 Timer
    self.checkDateTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(checkCurrentDate) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:self.checkDateTimer forMode:NSRunLoopCommonModes];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    // 移除 Timer
    [self.checkDateTimer invalidate];
    [self resignFirstResponder];
}

#pragma mark - Operation

- (void)checkCurrentDate {
    
    if(self.lastGetVCodeDate){
        
        NSTimeInterval preTimeInterval = [self.lastGetVCodeDate timeIntervalSinceNow];
        NSInteger countdown = kGetVCodeCountdownTime + (NSInteger)preTimeInterval;
        
        if(countdown >= 0) {
            
            // 更新 按钮时间
            [self.getVCodeBtn setTitle:[@(countdown).description stringByAppendingString:@" S"] forState:UIControlStateNormal];
            self.getVCodeBtn.enabled = false;
            return;
        }
    }
    
    [self.getVCodeBtn setTitle:kGetVCodeString forState:UIControlStateNormal];
    self.getVCodeBtn.enabled = true;
    
    
    //getVCodeBtn
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 基本设置
    self.title = @"找回密码";
    self.pageName = @"找回密码页";
    
    // UI
    UIScrollView *scrollview = [UIScrollView new];
    

    self.scrollview = scrollview;
    
    self.automaticallyAdjustsScrollViewInsets = false;
    scrollview.contentInset = UIEdgeInsetsMake(1, 0, 1, 0);
    
    [self.view addSubview:scrollview];
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.left.bottom.right.offset(0);
        make.height.width.equalTo(self.view);
    }];
    
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [scrollview addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(9);
        make.left.bottom.right.equalTo(scrollview);
        make.width.equalTo(scrollview);
        make.height.offset([UIScreen mainScreen].bounds.size.height - K_NAVIGATION_BAR_OFFSET - 9);
    }];    
    self.view.backgroundColor = [UIColor whiteColor];
    
     [self installUI];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.scrollview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollview.showsVerticalScrollIndicator = false;
    self.scrollview.showsHorizontalScrollIndicator = false;

}

- (void)tapView:(UITapGestureRecognizer *)tap {
    
    [self.view endEditing:true];
}

#pragma mark - 搭建界面

- (void)popController {
    
    [self.navigationController popViewControllerAnimated:true];
}

/**
 界面布局
 */
- (void)installUI{

    // -- userMobileField
    UITextField *userMobileField = [UITextField new];
    userMobileField.delegate = self;
    self.userMobileField = userMobileField;
    [self.contentView addSubview:userMobileField];
    [self.userMobileField addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    userMobileField.placeholder = @"请输入已注册的手机号";
    userMobileField.font = [UIFont bxg_fontRegularWithSize:16];
    [userMobileField sizeToFit];
    [userMobileField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(9 + 10);
        make.left.offset(15);
        // make.right.offset(-15);
        make.right.offset(-15 - 18 - 5);
        make.height.offset(16 + 20);
    }];
    userMobileField.clearButtonMode = UITextFieldViewModeAlways;
    userMobileField.keyboardType = UIKeyboardTypeNumberPad;
    
    // 任何情况下，再次登录帐户输入框自动填写上次登录帐户名，登录记录持续保持；
    //NSString *lastUserID = [[BXGUserDefaults share] lastUserID];
//    if(lastUserID) {
//    
//        userMobileField.text = lastUserID;
//    }

    // topSplitLine
    UIView *topSplitLine = [UIView new];
    [self.contentView addSubview:topSplitLine];
    topSplitLine.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [topSplitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userMobileField.mas_bottom).offset(10 - 10);
        make.left.offset(15);
        make.right.offset(0);
        make.height.offset(1);
    }];
    
    // codeTextField
    UITextField *codeTextField = [UITextField new];
    [self.contentView addSubview:codeTextField];
    codeTextField.placeholder = @"请输入动态码";
    codeTextField.font = [UIFont bxg_fontRegularWithSize:16];
    [codeTextField sizeToFit];
    [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topSplitLine.mas_bottom).offset(25 - 10);
        make.left.offset(15);
        make.width.offset(200);
        make.height.offset(16 + 20);
    }];
    
    
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeField = codeTextField;

    codeTextField.delegate = self;
    // bottomSplitLine
    UIView *bottomSplitLine = [UIView new];
    [self.contentView addSubview:bottomSplitLine];
    bottomSplitLine.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [bottomSplitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeTextField.mas_bottom).offset(10 - 10);
        make.left.offset(15);
        make.right.offset(0);
        make.height.offset(1);
    }];
    // getCodeBtn
    UIButton *getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getVCodeBtn = getCodeBtn;
    [self.contentView addSubview:getCodeBtn];
    [getCodeBtn addTarget:self action:@selector(clickGetVCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [getCodeBtn setTitleColor:[UIColor colorWithHex:0xFF38ADFF] forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[UIColor colorWithHex:0xFF38ADFF] forState:UIControlStateDisabled];
    [getCodeBtn setTitle:@"" forState:UIControlStateNormal];
    getCodeBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:12];
    getCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // [getCodeBtn sizeToFit];
    [getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        // make.right.offset(-15);
        // make.bottom.equalTo(bottomSplitLine.mas_top).offset(-16);
        make.height.equalTo(codeTextField);
        make.centerY.equalTo(codeTextField);
        make.centerX.equalTo(userMobileField.mas_right).offset(-15);
    }];
    
    // registerbtn
    BXGRoundedBtn *nextBtn = [BXGRoundedBtn buttonWithType:UIButtonTypeSystem withTitle:@"下一步"];
    [self.contentView addSubview:nextBtn];
    
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
     nextBtn.enabled = false;
    //nextBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    //[nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(bottomSplitLine.mas_bottom).offset(29);
        make.height.offset(40);
    }];
    //nextBtn.layer.cornerRadius = 20;
    //[nextBtn.layer masksToBounds];
    // nextBtn.tintColor = [UIColor colorWithHex:0xFF38ADFF];
    //nextBtn.backgroundColor = [UIColor colorWithHex:0xFF38ADFF];
    //nextBtn.backgroundColor = [UIColor colorWithHex:0xCCCCCC];
    [nextBtn addTarget:self action:@selector(clickToNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn = nextBtn;
    
    // ---- tip label
    
    UILabel *tipLabel = [UILabel new];
    [self.contentView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15 + 12);
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(nextBtn.mas_bottom).offset(15);
    }];
    
    tipLabel.font = [UIFont bxg_fontRegularWithSize:12];
    tipLabel.textColor = [UIColor colorWithHex:0x999999];
    tipLabel.text = @"提示：其他方式（邮箱）修改密码请到博学谷官网";
}

#pragma mark - 控件设置

#pragma mark - 响应

//注意：事件类型是：`UIControlEventEditingChanged`
-(void)passConTextChange:(UITextField *)sender{
    
    if([BXGVerifyTool verifyPhoneNumber:sender.text]) {
        
        self.nextBtn.enabled = true;
        
    }else {
        
        self.nextBtn.enabled = false;
    }
}
#pragma mark - TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    

    if([string isEqualToString:@"\n"]){
        
        if(self.codeField == textField) {
            
            // [self.registBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return true;
}


#pragma mark - Response

- (void)clickGetVCodeBtn:(UIButton *)sender{

    RWLog(@"获取动态码操作");
    RWLog(@"clickGetCodeBtn");
    
    sender.enabled = false;
    if(self.lastGetVCodeDate){
        
        NSTimeInterval preTimeInterval = [self.lastGetVCodeDate timeIntervalSinceNow];
        NSInteger countdown = kGetVCodeCountdownTime + (NSInteger)preTimeInterval;
        
        if(countdown >= 0) {
            
            return;
        }
        
    }

    NSString *mobileStirng = self.userMobileField.text;
    
    if (self.userMobileField.text.length <= 0){
        
        [[BXGHUDTool share] showHUDWithString:@"请输入已注册的手机号"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            sender.enabled = true;
            self.lastGetVCodeDate = nil;
        });
        return;
    }
    
    if(![BXGVerifyTool verifyPhoneNumber:mobileStirng]) {
        
        [[BXGHUDTool share] showHUDWithString:kBXGToastPhoneNumberError];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            sender.enabled = true;
            
        });
        self.lastGetVCodeDate = nil;
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    NSString *mobile = weakSelf.userMobileField.text;
    self.lastGetVCodeDate = [NSDate new];
    
    [weakSelf.viewModel requestSendCodeForResetPswWithMobile:mobile Finished:^(BOOL success, NSString *errorMessage) {
        
        if(success) {
        
            [[BXGHUDTool share] showHUDWithString:@"短信发送成功"];
            
        }else {
        
            if(errorMessage) {
            
                [[BXGHUDTool share] showHUDWithString:errorMessage];
                
            }else {
            
                [[BXGHUDTool share] showHUDWithString:@"未知错误"];
            }
            
            self.lastGetVCodeDate = nil;

        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            sender.enabled = true;
            
        });
    }];
}



- (void)clickToNextBtn:(UIButton *)sender{
    
    RWLog(@"下一步操作");
    __weak typeof (self) weakSelf = self;
    NSString *mobileStirng = self.userMobileField.text;
    NSString *vCodeString = self.codeField.text;
    
    // 1.前端验证是否合法
    if (mobileStirng.length <= 0) {
        
        [[BXGHUDTool share] showHUDWithString:kBXGToastPhoneNumberEmpty];
        return;
    }
    
    // 2.验证手机号格式
    if(![BXGVerifyTool verifyPhoneNumber:mobileStirng]) {
        
        [[BXGHUDTool share] showHUDWithString:kBXGToastPhoneNumberError];
        return;
    }
    
    // 3.动态码是否为空
    if(vCodeString.length <= 0) {
        
        [[BXGHUDTool share] showHUDWithString:kBXGToastCodeEmpty];
        return;
    }
    
    // 4.动态码是否不合法
    
    if(![BXGVerifyTool verifyCodeFormat:vCodeString]) {
        
        [[BXGHUDTool share] showHUDWithString:kBXGToastCodeFormatError];
        return;
    }
    
    
    [[BXGHUDTool share] showLoadingHUDWithString:@"请稍后..." andView:weakSelf.view];
    [self.viewModel checkVerificationCodeForResetPsw:vCodeString mobile:mobileStirng andFinished:^(BOOL success) {
        
        if(success) {
            [[BXGHUDTool share] closeHUD];
            
            BXGUserResetPswVC *vc = [BXGUserResetPswVC new];
            vc.mobile = self.userMobileField.text;
            [self.navigationController pushViewController:vc animated:true];
            
        }else {
            [[BXGHUDTool share] showHUDWithString:@"未知错误"];
        }
    } Failed:^(id error) {
        
        // 提示网络失败
        [[BXGHUDTool share] showHUDWithString:error];
    }];
}

@end
