//
//  BXGUserLoginController.m
//  Boxuegu
//
//  Created by RW on 2017/4/13.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGUserLoginVC.h"

// 跳转
#import "BXGUserRegistVC.h"
#import "BXGUserForgetVC.h"

#import "BXGUserViewModel.h"
#import "BXGBaseNaviController.h"

// 子视图
#import "BXGUserLogoView.h"

#import "BXGDatabase.h"
#import "BXGResourceManager.h"
#import "BXGWXApiManager.h"


#import "BXGUserNormalTextField.h"
#import "BXGUserPasswordTextField.h"
#import "BXGUserVCodeTextField.h"

#import "BXGWXApiManager.h"

#import "BXGSocialManager.h"
#import "BXGUserBindExistAccountVC.h"

@interface BXGUserLoginVC () <UITextFieldDelegate,
                              UINavigationControllerDelegate>

#pragma mark Property - Components

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *headerFrameView;
@property (nonatomic, strong) UIView *centerFrameView;
@property (nonatomic, strong) UIView *socialFrameView;
@property (nonatomic, weak) BXGUserNormalTextField *userIdTextField; /// 账号框
@property (nonatomic, weak) BXGUserPasswordTextField *userPswTextField; /// 密码框
@property (nonatomic, weak) UIButton *loginBtn; /// 登录按钮
@property (nonatomic, strong) NSMutableArray *socialButtonArray;

#pragma mark Property - ViewModel
@property (nonatomic, strong) BXGUserViewModel *viewModel;
@end

@implementation BXGUserLoginVC

#pragma mark Getter Setter

- (BXGUserViewModel *)viewModel {

    if(!_viewModel) {
    
        _viewModel = [BXGUserViewModel share];
    }
    return _viewModel;
}

#pragma mark Override

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pageName = @"登录注册页";

    [self installUI];
    [self loadData];
//    [self installObeservers];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    self.navigationController.delegate = self;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unInstallObservers];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self installObeservers];
}


- (void)dealloc {
    
    [self unInstallObservers];
}

#pragma mark - Data
- (void)loadData {

    // 获取上次登录Id
    NSString *lastUserId = [self.viewModel loadLastUserID];
    if(lastUserId){
        self.userIdTextField.text = lastUserId;
    }
}

#pragma mark - UI

- (void)installUI{
    
    // 添返回键
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回-黑"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBackBtn:)];
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self.view addGestureRecognizer:tap];
    
    UIScrollView *scrollview = [UIScrollView new];
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.bottom.right.equalTo(scrollview);
        make.height.width.equalTo(scrollview);
    }];
    
    UIView *headerFrameView = self.headerFrameView;
    UIView *centerFrameView = self.centerFrameView;
    UIView *socialFrameView = self.socialFrameView;
    
    [self.view addSubview:scrollview];
    [self.contentView addSubview:headerFrameView];
    [self.contentView addSubview:centerFrameView];
    [self.contentView addSubview:socialFrameView];
    
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
    [headerFrameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_STATUS_BAR_OFFSET); // x 适配
        make.left.right.offset(0);
        if(IS_IPAD){
            make.height.offset(150); // 设置适配
        }else{
            make.height.offset(IS_IPHONE_5?200:260); // 设置适配
        }
        
        make.width.offset([UIScreen mainScreen].bounds.size.width);
    }];
    [centerFrameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(headerFrameView.mas_bottom).offset(0);
    }];
    [socialFrameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(-kBottomHeight);
        if(IS_IPAD){
            make.height.offset(150); // 设置适配
        }else{
            make.height.offset(IS_IPHONE_5?160:170); // 设置适配
        }
        
    }];
    
    self.scrollview = scrollview;
}

#pragma mark - UI Getter Setter

- (UIView *)headerFrameView {
    if(_headerFrameView == nil) {
        
        _headerFrameView = [UIView new];
        UIView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"登录注册-Logo"]];
        [_headerFrameView addSubview:logoView];
        [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.centerY.offset(0);
            make.width.offset(175);
            make.height.offset(70);
        }];
        
    }
    return _headerFrameView;
}

- (UIView *)centerFrameView {
    if(_centerFrameView == nil) {

        _centerFrameView = [UIView new];
        BXGUserNormalTextField *userInputTextField = [BXGUserNormalTextField new];
        userInputTextField.tagName = @"账　号:";
        userInputTextField.placeholder = @"请输入您手机号/邮箱";
        [_centerFrameView addSubview:userInputTextField];
        [userInputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.offset(-10);
            make.height.offset(kBXGUserTextFieldHeight);
        }];
    
        BXGUserPasswordTextField *userInputTextField2 = [BXGUserPasswordTextField new];
        [_centerFrameView addSubview:userInputTextField2];
        userInputTextField2.tagName = @"密　码:";
        userInputTextField2.placeholder = @"请输入密码";
        [userInputTextField2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(userInputTextField.mas_bottom).offset(kBXGUserTextFieldTopOffset);
            make.height.offset(kBXGUserTextFieldHeight); //
        }];
    
        // mark
        
        // loginBtn
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_centerFrameView addSubview:loginBtn];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        loginBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.right.offset(-15);
            make.top.equalTo(userInputTextField2.mas_bottom).offset(29);
            make.height.offset(40);
        }];
        self.loginBtn = loginBtn;
        loginBtn.layer.cornerRadius = 20;
        [loginBtn.layer masksToBounds];
        loginBtn.backgroundColor = [UIColor colorWithHex:0xFF38ADFF];
        [loginBtn addTarget:self action:@selector(onClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //中间分割线
        UIView *centerSplitLineView = [UIView new];
        [centerSplitLineView setBackgroundColor:[UIColor colorWithHex:0xD8D8D8]];
        [_centerFrameView addSubview:centerSplitLineView];
        [centerSplitLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.equalTo(loginBtn.mas_bottom).offset(17);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(10);
            make.bottom.equalTo(centerSplitLineView.superview).offset(-20);
        }];
        
        // to registBtn
        UIButton *toRegistBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_centerFrameView addSubview:toRegistBtn];
        [toRegistBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.equalTo(centerSplitLineView.mas_left).offset(-25);
            make.top.equalTo(loginBtn.mas_bottom).offset(0);
            make.height.offset(44);
        }];
        [toRegistBtn addTarget:self action:@selector(onClickRegistBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        // to registBtn label
        UILabel *toRegistBtnTitleLabel = [UILabel new];
        toRegistBtnTitleLabel.text = @"注册账号";
        toRegistBtnTitleLabel.font = [UIFont bxg_fontRegularWithSize:14];
        toRegistBtnTitleLabel.textColor = [UIColor colorWithHex:0x999999];
        
        [toRegistBtn sizeToFit];
        [toRegistBtn addSubview:toRegistBtnTitleLabel];
        
        [toRegistBtnTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.centerY.offset(0);
        }];
        
        // to forgetBtn
        UIButton *toforgetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [toforgetBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        [_centerFrameView addSubview:toforgetBtn];
        [toforgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(centerSplitLineView.mas_right).offset(25);
            make.top.equalTo(loginBtn.mas_bottom).offset(0);
            make.right.offset(0);
            make.height.equalTo(toRegistBtn.mas_height);
        }];
        
        [toforgetBtn addTarget:self action:@selector(onClickForgetBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *toforgetBtnTitleLabel = [UILabel new];
        toforgetBtnTitleLabel.text = @"忘记密码";
        toforgetBtnTitleLabel.font = [UIFont bxg_fontRegularWithSize:14];
        toforgetBtnTitleLabel.textColor = [UIColor colorWithHex:0x999999];
        
        [toforgetBtn sizeToFit];
        [toforgetBtn addSubview:toforgetBtnTitleLabel];
        
        [toforgetBtnTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.offset(0);
            make.centerY.offset(0);
            
        }];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
        [self.view addGestureRecognizer:tapGesture];
        
        self.userIdTextField = userInputTextField;
        self.userPswTextField = userInputTextField2;
    }
    return _centerFrameView;
}

- (UIView *)socialFrameView {
    if(_socialFrameView == nil) {
        
        _socialFrameView = [UIView new];
        
        UILabel *markLabel = [UILabel new];
        [_socialFrameView addSubview:markLabel];
        markLabel.text = @"使用第三方登录";
        markLabel.font = [UIFont bxg_fontRegularWithSize:14];
        markLabel.textColor = [UIColor colorWithHex:0x999999];
        [markLabel sizeToFit];
        [markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(40);
            make.centerX.offset(0);
        }];
        
        // 按钮控件
        NSMutableArray *buttonArray = [NSMutableArray new];
        // QQ
        UIButton *qqBtn = [UIButton buttonWithType:0];
        [qqBtn setImage:[UIImage imageNamed:@"登录注册-QQ"] forState:UIControlStateNormal];
        qqBtn.tag = BXGSocialPlatformTypeQQ;
        
        [buttonArray addObject:qqBtn];
        
        if([BXGWXApiManager isWXAppInstalled]) {
            UIButton *wechatBtn = [UIButton buttonWithType:0];
            wechatBtn.tag = BXGSocialPlatformTypeWeChat;
            [wechatBtn setImage:[UIImage imageNamed:@"登录注册-微信"] forState:UIControlStateNormal];
            [buttonArray addObject:wechatBtn];
        }
        
        // 微博
        UIButton *weiboBtn = [UIButton buttonWithType:0];
        [weiboBtn setImage:[UIImage imageNamed:@"登录注册-微博"] forState:UIControlStateNormal];
        [buttonArray addObject:weiboBtn];
        weiboBtn.tag = BXGSocialPlatformTypeWeibo;
        UIView *btnView = [UIView new];
        [_socialFrameView addSubview:btnView];
        self.socialButtonArray = buttonArray;
        [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(markLabel.mas_bottom).offset(10);
            make.centerX.offset(0);
        }];
        UIView *lastView = nil;
        for (NSInteger i = 0; i < buttonArray.count; i++) {
            UIButton *view = buttonArray[i];
            [btnView addSubview:view];
            [view addTarget:self action:@selector(socialLogin:) forControlEvents:UIControlEventTouchUpInside];
            if(i == 0){
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset(0);
                }];
            }else {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastView.mas_right).offset(45);
                }];
            }
            
            view.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(34);
                make.width.offset(34);
                make.top.offset(0);
                make.bottom.offset(0);
            }];
            
            if(i == buttonArray.count-1) {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(0);
                }];
            }
            lastView = view;
        }
        
        // 获取上次三方登录信息
        
        BXGSocialPlatformType socialType = [BXGUserCenter share].lastSocialType;
        switch (socialType) {
            default:{
                
            } // break
            case BXGSocialPlatformTypeNone: {
                
            }break;
            case BXGSocialPlatformTypeWeChat: {
                
            }break;
            case BXGSocialPlatformTypeQQ: {
                
            }break;
            case BXGSocialPlatformTypeWeibo: {
                
            }break;
        }
        
        // 显示三方登录标记
        
        UIButton *socialBtn = nil;
        for (NSInteger i = 0; i < self.socialButtonArray.count; i++) {
            UIButton *view = self.socialButtonArray[i];
            if(socialType == view.tag && socialType != BXGSocialPlatformTypeNone) {
                socialBtn = view;
                break;
            }
        }
        if(socialBtn) {
            UIImageView *lastLoginMark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"登录注册-上次登录"]];
            [_socialFrameView addSubview:lastLoginMark];
            [lastLoginMark mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(socialBtn);
                make.top.equalTo(socialBtn.mas_bottom).offset(5);
                make.width.offset(75);
                make.height.offset(30);
            }];
        }
        
    }
    return _socialFrameView;
}

#pragma mark - Response

// TODO: 界面被点击
- (void)tapView:(UITapGestureRecognizer *)tap {
    
    [self.view endEditing:true];
}

- (void)onClickBackBtn:(UIButton *)sender {
    
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (void)onClickForgetBtn:(UIButton *)sender {

    [[BXGBaiduStatistic share] statisticEventString:forget_password_02 andParameter:nil];
    BXGUserForgetVC *vc = [BXGUserForgetVC new];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)onClickRegistBtn:(UIButton *)sender {
    
    [[BXGBaiduStatistic share] statisticEventString:load_regist_03 andParameter:nil];
    UIViewController *vc = [BXGUserRegistVC new];
    BXGBaseNaviController *nav = [[BXGBaseNaviController alloc]initWithRootViewController:vc];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)onClickLoginBtn:(UIButton *)sender {
    
    __weak typeof (self) weakSelf = self;
    NSString *mobileString = self.userIdTextField.text;
    NSString *codeStirng = self.userPswTextField.text;
    
    // 1.百度统计
    [[BXGBaiduStatistic share] statisticEventString:load_icon_01 andParameter:nil];
    
    // 2.验证账号是否为空
    if(self.userIdTextField.text.length <= 0) {
        
        [weakSelf.hudTool showHUDWithString:kBXGToastUserNameEmpty];
        return;
    }
    
    // 3.验证账号格式
    if(![BXGVerifyTool verifyEmail:self.userIdTextField.text] && ![BXGVerifyTool verifyPhoneNumber:self.userIdTextField.text]){
        
        [weakSelf.hudTool showHUDWithString:kBXGToastUserIdFormatError];
        return;
    }

    // 4.验证密码是否为空
    if(self.userPswTextField.text.length <= 0) {

        [weakSelf.hudTool showHUDWithString:kBXGToastPswEmpty];
        return;
    }
    
    // 5.验证密码是否为空
    if(![BXGVerifyTool verifyPswFormat:self.userPswTextField.text]) {
        
        [weakSelf.hudTool showHUDWithString:kBXGToastPswFormatError];
        return;
    }
    
    // 6.验证是否有网络
    if ([[BXGNetWorkTool sharedTool] getReachState] < BXGReachabilityStatusReachabilityStatusReachableViaWWAN){
    
        [weakSelf.hudTool showHUDWithString:kBXGToastNoNetworkError];
        return;
    }
    
    // 7.请求登录
    [weakSelf.hudTool showLoadingHUDWithString:@"登录中..." andView:weakSelf.view];
    [[BXGUserCenter share] signInWithUserName:mobileString passWord:codeStirng Finished:^(BXGUserModel *userModel, NSString *msg) {
        [weakSelf.hudTool closeHUD];
        [weakSelf.view endEditing:true];
        if(userModel){
            [weakSelf.hudTool showHUDWithString:@"登录成功"];
            [weakSelf.navigationController dismissViewControllerAnimated:true completion:nil];
        }else {
            [weakSelf.hudTool showHUDWithString:msg];
        }
    }];
}

#pragma mark - Notification

- (void)installObeservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}

- (void)unInstallObservers {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 响应 键盘将要
- (void)keyBoardWillHide:(NSNotification *)noti {
    // 获取键盘高度
    Weak(weakSelf);;
    [self.scrollview setContentOffset:CGPointMake(0, 0) animated:true];
//    weakSelf.scrollview.contentOffset = CGPointMake(0, 0);
}

// 响应 键盘将要
- (void)keyBoardWillShow:(NSNotification *)noti {
    Weak(weakSelf);;
    NSValue *rectValue = noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect rect = rectValue.CGRectValue;
    CGFloat offset = (weakSelf.centerFrameView.frame.origin.y + weakSelf.centerFrameView.frame.size.height) - rect.origin.y;
    
    if(offset < 0) {
        offset = 0;
    }
    if(weakSelf.scrollview){
//        weakSelf.scrollview.contentOffset = self.scrollview.contentOffset;
        [weakSelf.scrollview setContentOffset:CGPointMake(0, offset) animated:true];

//        weakSelf.scrollview.contentOffset = CGPointMake(0, offset);
    }
    
    
    
    
}

#pragma mark - Function

- (void)socialLogin:(UIButton *)sender {
    Weak(weakSelf);
    
    // 提前判断
    switch (sender.tag) {
        case BXGSocialPlatformTypeNone: {
            
        } break;
        case BXGSocialPlatformTypeWeChat: {
            if(![BXGWXApiManager isWXAppInstalled]) {
                [[BXGHUDTool share] showHUDWithString:@"未安装微信,请安装后再试"];
                return;
            }
        }break;
        case BXGSocialPlatformTypeQQ: {
            
        }break;
        case BXGSocialPlatformTypeWeibo: {
            
        }break;
        default:{
            
        }break;
    }
    
    // 调用登录接口
    [[BXGSocialManager share] getAuthWithUserInfoWithType:sender.tag Finished:^(BOOL success, NSString *msg, BXGSocialModel *model) {
        [[BXGHUDTool share] closeHUD];
        if(success && model) {
            // 成功
            [[BXGHUDTool share] showLoadingHUDWithString:nil];
            [[BXGUserCenter share] loginWithSocialModel:model Finished:^(NSInteger status, BXGSocialModel * _Nullable socialModel, NSString * _Nullable message) {
                if(status == 1002) {
                    [[BXGHUDTool share] closeHUD];
                    BXGUserBindExistAccountVC *vc = [BXGUserBindExistAccountVC new];
                    vc.socialModel = model;
                    [weakSelf.navigationController pushViewController:vc animated:true];
                }else if(status == 200){
                    [[BXGHUDTool share] showHUDWithString:@"登录成功"];
                    [weakSelf.navigationController dismissViewControllerAnimated:true completion:nil];
                }else {
                    [[BXGHUDTool share] showHUDWithString:message];
                }
            }];
        } else  {
            [[BXGHUDTool share] showHUDWithString:msg];
        }
    } andReturnBlock:^{
        [[BXGHUDTool share] showLoadingHUDWithString:nil];
    } andCancelBlock:^{
        [[BXGHUDTool share] showHUDWithString:@"授权取消"];
    }];
}
@end
