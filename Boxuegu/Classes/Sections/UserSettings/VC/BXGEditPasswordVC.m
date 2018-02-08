//
//  BXGEditPasswordVC.m
//  Boxuegu
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGEditPasswordVC.h"
#import "BXGUserPasswordTextField.h"
#import "BXGUserNormalTextField.h"
#import "BXGUserVCodeTextField.h"
#import "BXGRoundedBtn.h"
#import "BXGUserViewModel.h"

@interface BXGEditPasswordVC ()
@property (nonatomic, strong) NSString *cellphone;
@property (nonatomic, weak) BXGUserVCodeTextField *vcodeTF;
@property (nonatomic, weak) BXGUserPasswordTextField *passwordTF;
@property (nonatomic, weak) UIButton *confirmBtn;
@end

@implementation BXGEditPasswordVC

- (instancetype)initCellphone:(NSString*)cellphone
andFinishModifyPasswordBlockType:(FinishModifyPasswordBlockType)finishModifyPasswordBlock {
    self = [super init];
    if(self) {
        self.cellphone = cellphone;
        self.finishModifyPasswordBlock = finishModifyPasswordBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改密码";
    [self installUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_vcodeTF uninstall];
    [_vcodeTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
}

- (void)installUI {
    Weak(weakSelf);
    
    // 1.头部分视图
    UIView *spView = [UIView new];
    spView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [self.view addSubview:spView];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(9);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
    }];
    
    // 2.手机号输入框
    BXGUserNormalTextField *phoneTF = [BXGUserNormalTextField new];
    [self.view addSubview:phoneTF];
    phoneTF.tagName = @"手机号:";
    phoneTF.text = _cellphone;
    phoneTF.enable = NO;
//    phoneTF.userInteractionEnabled = NO;
//    phoneTF.keyBoardType = UIKeyboardTypeNumberPad;
    
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(spView.mas_bottom).offset(kBXGUserTextFieldTopOffset);
        make.height.offset(kBXGUserTextFieldHeight);
    }];

    // 3.动态码输入框
    BXGUserVCodeTextField *vcodeTF = [BXGUserVCodeTextField new];
    [self.view addSubview:vcodeTF];
    [vcodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneTF.mas_bottom).offset(kBXGUserTextFieldTopOffset);
        make.left.right.offset(0);
        make.height.offset(kBXGUserTextFieldHeight);
    }];
    vcodeTF.tagName = @"动态码:";
    vcodeTF.placeholder = @"请输入动态码";
    vcodeTF.clickBlock = ^{
        [weakSelf onClickGetVCodeBtn];
    };
    self.vcodeTF = vcodeTF;
    [self.vcodeTF becomeFirstResponder];

    // 4.密码输入框
    BXGUserPasswordTextField *passwordTF = [BXGUserPasswordTextField new];
    [self.view addSubview:passwordTF];
    passwordTF.tagName = @"密　码:";
    passwordTF.placeholder = @"请输入6-18位密码";
    [passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(vcodeTF.mas_bottom).offset(kBXGUserTextFieldTopOffset);
        make.height.offset(kBXGUserTextFieldHeight); //
    }];
    self.passwordTF = passwordTF;

    // 5.绑定并登录按钮
    BXGRoundedBtn *confirmBtn = [BXGRoundedBtn buttonWithType:UIButtonTypeSystem withTitle:@"确定"];
    [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    confirmBtn.enabled = true;
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(passwordTF.mas_bottom).offset(30);
        make.height.offset(40);
    }];
    self.confirmBtn = confirmBtn;
}

- (void)confirm:(UIButton *)sender{
    
    NSString *vCodeString = self.vcodeTF.text;
    
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
    
    NSString *vPassword = self.passwordTF.text;
    if(vPassword.length <= 0) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastPswEmpty];
        return ;
    }
    if(![BXGVerifyTool verifyPswFormat:vPassword]) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastPswFormatError];
        return;
    }
    
    if(_finishModifyPasswordBlock) {
        _finishModifyPasswordBlock(self.passwordTF.text, vCodeString);
    }
}

//获取动态码事件
- (void)onClickGetVCodeBtn {
    Weak(weakSelf);
    
    // 3.启动读条
    [self.vcodeTF startCount];
    
    // 4.发送动态码
    [[BXGUserViewModel share] loadAppRequestCodeWithMobile:_cellphone
                                                withIsBind:NO
                                                  Finished:^(BOOL success, NSString* errorMessage) {
                                                      if(success) {
                                                          [[BXGHUDTool share] showHUDWithString:@"短信发送成功"];
                                                      } else {
                                                          [[BXGHUDTool share] showHUDWithString:errorMessage];
                                                          [weakSelf.vcodeTF stopCount];
                                                      }
                                                  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
