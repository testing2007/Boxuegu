//
//  BXGUserVerificationController.m
//  Boxuegu
//
//  Created by Renying Wu on 2017/4/13.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGUserRegistVC.h"
#import "BXGUserSettingVC.h"
#import "BXGUserAgreementVC.h"
#import "BXGUserViewModel.h"
#import "BXGUserLogoView.h"
#import "BXGHUDTool.h"
#import "BXGVerifyTool.h"
#import "BXGUserNormalTextField.h"
#import "BXGUserVCodeTextField.h"

@interface BXGUserRegistVC () <UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, weak) UIButton *registBtn;

@property (nonatomic, strong) UIView *headerFrameView;
@property (nonatomic, strong) UIView *centerFrameView;
@property (nonatomic, strong) UIView *bottomFrameView;

@property (nonatomic, weak) BXGUserNormalTextField *mobileTF;
@property (nonatomic, weak) BXGUserVCodeTextField *vcodeTF;

@property (nonatomic, strong) BXGUserViewModel *viewModel;
@end

@implementation BXGUserRegistVC

#pragma mark - Getter Setter

- (BXGUserViewModel *)viewModel {

    if(!_viewModel){
        
        _viewModel = [BXGUserViewModel share];
    }
    return _viewModel;
}

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageName = @"手机号注册";
    [self installUI];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self installObservers];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unInstallObservers];
    [self resignFirstResponder];
}

- (void)dealloc {
    [self.vcodeTF uninstall];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

#pragma mark - UI

- (void)installUI{
    
    self.automaticallyAdjustsScrollViewInsets = false;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回-黑"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBackBtn:)];
    
    UIScrollView *scrollview = [UIScrollView new];
    scrollview.contentSize = self.view.bounds.size;
    self.scrollview = scrollview;
    [self.view addSubview:scrollview];
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
        make.height.width.equalTo(self.view);
    }];
    
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(scrollview);
        make.height.width.equalTo(scrollview);
    }];
    
    self.title = @"手机号注册";
    self.navigationItem.title = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.delegate = self;
    
    //[self installNavigationBar];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self.view addGestureRecognizer:tapGesture];
    
    
    self.scrollview.contentSize = self.view.bounds.size;
    self.scrollview.contentInset = UIEdgeInsetsMake(0, 0, 160, 0);
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollview.showsVerticalScrollIndicator = false;
    self.scrollview.showsHorizontalScrollIndicator = false;
    self.scrollview.scrollEnabled = false;
    
    UIView *logoView = self.headerFrameView;
    [self.contentView addSubview: logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(K_STATUS_BAR_OFFSET); // x 适配
        make.left.right.offset(0);
        make.height.offset(IS_IPHONE_5?200:260); // 设置适配
        make.width.offset([UIScreen mainScreen].bounds.size.width);
    }];
    
    UIView *centerView = self.centerFrameView;
    [self.contentView addSubview: centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoView.mas_bottom).offset(0);
        make.left.right.offset(0);
    }];
    
    UIView *bottomFrameView = self.bottomFrameView;
    [self.contentView addSubview: bottomFrameView];
    [bottomFrameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(-kBottomHeight);
        make.height.offset(IS_IPHONE_5?160:170); // 设置适配
    }];
}

// TODO: 头部视图
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

// TODO: 底部视图
- (UIView *)bottomFrameView {
    if(_bottomFrameView == nil) {
        _bottomFrameView = [UIView new];
        
        // 1.服务协议按钮
        UILabel *agreementLabel = [UILabel new];
        [_bottomFrameView addSubview:agreementLabel];
        
        NSMutableAttributedString *atString = [[NSMutableAttributedString alloc]initWithString:@"点击注册即表示同意《博学谷服务协议》"];
        
        [atString addAttributes:@{
                                  NSFontAttributeName: [UIFont bxg_fontRegularWithSize:12],
                                  } range:NSMakeRange(0, 18)];
        
        [atString addAttributes:@{
                                  NSForegroundColorAttributeName: [UIColor colorWithHex:0x999999]
                                  } range:NSMakeRange(0, 9)];
        
        [atString addAttributes:@{
                                  NSForegroundColorAttributeName: [UIColor colorWithHex:0x666666]
                                  } range:NSMakeRange(9, 9)];
        
        [agreementLabel setAttributedText:atString];
        agreementLabel.textAlignment = NSTextAlignmentCenter;
        [agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.right.offset(-15);
            make.height.offset(12 + 20);
            make.bottom.offset(-30 + 10);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAgreementTextLabel:)];
        [agreementLabel addGestureRecognizer:tap];
        agreementLabel.userInteractionEnabled = true;
    }
    return _bottomFrameView;
}

// TODO: 中间视图
- (UIView *)centerFrameView {
    if(_centerFrameView == nil) {
        
        Weak(weakSelf)
        _centerFrameView = [UIView new];
        
        // 1.手机号输入框
        BXGUserNormalTextField *userInputTextField = [BXGUserNormalTextField new];
        userInputTextField.tagName = @"手机号:";
        userInputTextField.placeholder = @"请输入您手机号";
        userInputTextField.keyBoardType = UIKeyboardTypeNumberPad;
        [_centerFrameView addSubview:userInputTextField];
        [userInputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.offset(-10);
            make.height.offset(kBXGUserTextFieldHeight);
        }];
        
        // 2.动态码输入框
        BXGUserVCodeTextField *userInputTextField2 = [BXGUserVCodeTextField new];
        [_centerFrameView addSubview:userInputTextField2];
        [userInputTextField2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(userInputTextField.mas_bottom).offset(kBXGUserTextFieldTopOffset);
            make.height.offset(kBXGUserTextFieldHeight); //
        }];
        userInputTextField2.tagName = @"动态码:";
        userInputTextField2.placeholder = @"请输入动态码";
        userInputTextField2.clickBlock = ^{
            [weakSelf onClickGetCodeBtn:nil];
        };
        
//        BXGUserNormalTextField *userInputTextField2 = [BXGUserNormalTextField new];
//        [_centerFrameView addSubview:userInputTextField2];
//        [userInputTextField2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.offset(0);
//            make.top.equalTo(userInputTextField.mas_bottom).offset(kBXGUserTextFieldTopOffset);
//            make.height.offset(kBXGUserTextFieldHeight); //
//        }];
//        userInputTextField2.tagName = @"动态码:";
//        userInputTextField2.placeholder = @"请输入动态码";
//        userInputTextField2.clickBlock = ^{
//            [weakSelf onClickGetCodeBtn:nil];
//        };
        
        // 3.下一步按钮
        UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_centerFrameView addSubview:registBtn];
        [registBtn setTitle:@"下一步" forState:UIControlStateNormal];
        registBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
        [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.right.offset(-15);
            make.top.equalTo(userInputTextField2.mas_bottom).offset(29);
            make.height.offset(40);
        }];
        registBtn.layer.cornerRadius = 20;
        [registBtn.layer masksToBounds];
        registBtn.backgroundColor = [UIColor colorWithHex:0xFF38ADFF];
        [registBtn addTarget:self action:@selector(clickRegistBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.registBtn = registBtn;
        
        // 4.中间分割线
        UIView *centerSplitLineView = [UIView new];
        [centerSplitLineView setBackgroundColor:[UIColor colorWithHex:0xD8D8D8]];
        [_centerFrameView addSubview:centerSplitLineView];
        [centerSplitLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.equalTo(registBtn.mas_bottom).offset(17);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(10);
            make.bottom.equalTo(centerSplitLineView.superview).offset(-20);
        }];
        
        // 5.跳转到登录按钮
        UIButton *toLoginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_centerFrameView addSubview:toLoginBtn];

        [toLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.equalTo(centerSplitLineView.mas_left).offset(-25);
            make.top.equalTo(registBtn.mas_bottom).offset(0);
            make.height.offset(44);
        }];
        [toLoginBtn addTarget:self action:@selector(onClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *toLoginBtnTitleLabel = [UILabel new];
        toLoginBtnTitleLabel.text = @"用户登录 ";
        toLoginBtnTitleLabel.font = [UIFont bxg_fontRegularWithSize:14];
        toLoginBtnTitleLabel.textColor = [UIColor colorWithHex:0x999999];
        
        [toLoginBtn addSubview:toLoginBtnTitleLabel];
        [toLoginBtnTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.centerY.offset(0);
        }];
        
        // 6.跳转到服务协议按钮
        UIButton *toAgreementBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_centerFrameView addSubview:toAgreementBtn];

        [toAgreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.left.equalTo(centerSplitLineView.mas_right).offset(25);
            make.top.equalTo(registBtn.mas_bottom).offset(0);
            make.height.offset(44);
        }];
        [toAgreementBtn addTarget:self action:@selector(tapAgreementTextLabel:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *toAgreementBtnLabel = [UILabel new];
        toAgreementBtnLabel.text = @"服务协议 ";
        toAgreementBtnLabel.font = [UIFont bxg_fontRegularWithSize:14];
        toAgreementBtnLabel.textColor = [UIColor colorWithHex:0x999999];
        
        [toAgreementBtn addSubview:toAgreementBtnLabel];
        [toAgreementBtnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.centerY.offset(0);
        }];
        
        // 7.添加手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
        [self.view addGestureRecognizer:tapGesture];
        
        // 8.添加接口
        self.mobileTF = userInputTextField;
        self.vcodeTF = userInputTextField2;
    }
    return _centerFrameView;
}

#pragma mark - Response

// TODO: 事件 - 触碰界面事件
- (void)tapView:(UITapGestureRecognizer *)tap {
    // 隐藏键盘
    [self.view endEditing:true];
}

// TODO: 事件 - 中部服务协议
- (void)clickAgreementBtn {
    
    UIViewController *vc = [BXGUserAgreementVC new];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:true];
}

// TODO: 事件 - 底部服务协议
- (void)tapAgreementTextLabel:(UITapGestureRecognizer*)ges {
    
    UIViewController *vc = [BXGUserAgreementVC new];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:true];
}

// TODO: 事件 - 注册
- (void)clickRegistBtn:(UIButton *)sender {
    
    [[BXGBaiduStatistic share] statisticEventString:regist_nextstep_04 andParameter:nil];
    __weak typeof (self) weakSelf = self;
    NSString *mobileStirng = self.mobileTF.text;
    NSString *vCodeString = self.vcodeTF.text;
    
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
    
    // 5.请求注册
    [[BXGHUDTool share] showLoadingHUDWithString:@"请稍后..." andView:weakSelf.view];
    [self.viewModel checkVerificationCodeForRegist:vCodeString mobile:mobileStirng andFinished:^(BOOL success) {
        [[BXGHUDTool share] closeHUD];
        if(success) {
            BXGUserSettingVC *vc = [BXGUserSettingVC new];
            vc.mobile = mobileStirng;
            vc.code = vCodeString;
            vc.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:vc animated:true];
        }
    } Failed:^(id error) {
        // 提示失败原因
        [[BXGHUDTool share] showHUDWithString:error];
    }];
}

// TODO: 事件 - 跳转到登录
- (void)onClickLoginBtn:(UIButton *)sender {
    
    // 1.返回到登录界面 (使用模态返回)
    [self.view endEditing:true];
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

// TODO: 事件 - 获取验证码
- (void)onClickGetCodeBtn:(UIButton *)sender {
    Weak(weakSelf);
    NSString *mobile = self.mobileTF.text;
    
    // 1.百度统计
    [[BXGBaiduStatistic share] statisticEventString:regist_sendcode_05 andParameter:nil];
    
    // 2.验证手机号是否为空
    if (self.mobileTF.text.length <= 0){
        [[BXGHUDTool share] showHUDWithString:kBXGToastPhoneNumberEmpty];
        return;
    }
    
    // 3.验证手机号格式
    if(![BXGVerifyTool verifyPhoneNumber:mobile]) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastPhoneNumberError];
        return;
    }
    
    // 4.请求发送验证码
    [self.vcodeTF startCount];
    [weakSelf.viewModel requestSendCodeForRegistWithMobile:mobile Finished:^(BOOL su_Nonnullccess) {
        [[BXGHUDTool share] showHUDWithString:@"短信发送成功"];
    } Failed:^(id error) {
        [[BXGHUDTool share] showHUDWithString:error];
        [weakSelf.vcodeTF stopCount];
    }];
}

- (void)onClickBackBtn:(UIButton *)sender {
    
    [[BXGBaiduStatistic share] statisticEventString:regist_return_sjhzc_06 andParameter:nil];
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
//    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Notification

- (void)installObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}

- (void)unInstallObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 响应 键盘将要
- (void)keyBoardWillHide:(NSNotification *)noti {
    // 获取键盘高度
    [self.scrollview setContentOffset:CGPointMake(0, 0) animated:true];
//    self.scrollview.contentOffset = CGPointMake(0, 0);
}

// 响应 键盘将要
- (void)keyBoardWillShow:(NSNotification *)noti {
    
    NSValue *rectValue = noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect rect = rectValue.CGRectValue;
    CGFloat offset = (self.centerFrameView.frame.origin.y + self.centerFrameView.frame.size.height) - rect.origin.y;
    
    if(offset < 0) {
        offset = 0;
    }
    
//    self.scrollview.contentOffset = CGPointMake(0, offset);
    [self.scrollview setContentOffset:CGPointMake(0, offset) animated:true];
}

#pragma mark - Function

- (void)popController {
    [self.navigationController popViewControllerAnimated:true];
}
@end
