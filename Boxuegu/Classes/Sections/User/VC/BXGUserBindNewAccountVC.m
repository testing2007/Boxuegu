//
//  BXGUserBindNewAccountVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGUserBindNewAccountVC.h"
#import "BXGUserNormalTextField.h"
#import "BXGUserPasswordTextField.h"
#import "BXGUserVCodeTextField.h"
#import "BXGRoundedBtn.h"
#import "BXGUserBindExistAccountVC.h"
#import "BXGAcceptProtocolView.h"
#import "BXGUserViewModel.h"
#import "BXGUserAgreementVC.h"
#import "BXGSocialManager.h"

@interface BXGUserBindNewAccountVC ()
@property (nonatomic, weak) BXGUserVCodeTextField *vcodeTF;
@property (nonatomic, weak) BXGUserNormalTextField *mobileTF;
@property (nonatomic, weak) BXGUserPasswordTextField *passwordTF;
@property (nonatomic, weak) UIButton *bindNewAccountBtn;
@end

@implementation BXGUserBindNewAccountVC

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定新账号";
    [self installUI];
}

- (void)dealloc {
    [self.vcodeTF uninstall];
}

#pragma mark - UI

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
    phoneTF.placeholder = @"请输入手机号";
    phoneTF.keyBoardType = UIKeyboardTypeNumberPad;
    
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
    
    // 5.绑定并登录按钮
    BXGRoundedBtn *bindNewAccountBtn = [BXGRoundedBtn buttonWithType:UIButtonTypeSystem withTitle:@"绑定并登录"];
    [self.view addSubview:bindNewAccountBtn];
    bindNewAccountBtn.enabled = true;

    [bindNewAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(passwordTF.mas_bottom).offset(30);
        make.height.offset(40);
    }];
    [bindNewAccountBtn addTarget:self action:@selector(onClickForBindNewAccountBtn:) forControlEvents:UIControlEventTouchUpInside];
    BXGAcceptProtocolView *protocal = [[BXGAcceptProtocolView alloc] init];
    protocal.protocolName = @"博学谷用户服务协议";
    [self.view addSubview:protocal];
    
    [protocal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(16);
        make.top.equalTo(bindNewAccountBtn.mas_bottom).offset(25);
    }];
    // 事件绑定
    protocal.selectedBlock = ^(BOOL isSelected) {
        [weakSelf onClickForAceeptProtocol:isSelected];
    };
    protocal.readProtocolBlock = ^{
        [weakSelf onClickReadProtocol];
    };
    
    // 6.提示视图
    UILabel *tipLabel = [[UILabel alloc]init];
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(protocal.mas_bottom).offset(10);
    }];
    tipLabel.numberOfLines = 0;
    NSString *text1 = @"*";
    NSString *text2 = @"绑定账号后，已购买课程才能同步学习，同时可收到课程服务的相关通知信息。";
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",text1,text2]];
    
    tipLabel.font = [UIFont bxg_fontRegularWithSize:12];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFF554C] range:NSMakeRange(0, text1.length)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x999999] range:NSMakeRange(text1.length, text2.length)];
    tipLabel.attributedText = string;
    
    
    // 7.跳转绑定已有账号按钮
    UIButton *toBindExistBtn = [UIButton new];
    [toBindExistBtn addTarget:self action:@selector(onClickForBindExistAccountBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toBindExistBtn];
    toBindExistBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:14];
    [toBindExistBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [toBindExistBtn setTitle:@"绑定已有账号" forState:UIControlStateNormal];
    [toBindExistBtn sizeToFit];
    [toBindExistBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(25);
        make.centerX.offset(0);
    }];
    
    // 8.设置接口
    self.vcodeTF = vcodeTF;
    self.passwordTF = passwordTF;
    self.mobileTF = phoneTF;
    self.bindNewAccountBtn = bindNewAccountBtn;
    
    // 9.关闭键盘事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapView:(UITapGestureRecognizer *)tap {
    [self.view endEditing:true];
}

#pragma mark - RESPONSE

// TODO: 绑定新账号 事件
- (void)onClickForBindNewAccountBtn:(UIButton *)sender {
    Weak(weakSelf);
    
    [[BXGBaiduStatistic share] statisticEventString:kBXGStatSocialEventTypeSocialBindId andLabel:@"绑定新账号"];
    
    // 1.判断是否填写 手机号
    if(self.mobileTF.text.length <= 0) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastPhoneNumberEmpty];
        return;
    }
    
    // 2.判断是手机号格式正确
    if(![BXGVerifyTool verifyPhoneNumber:self.mobileTF.text]) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastPhoneNumberError];
        return;
    }
    
    // 3.判断动态码是否为空
    if(self.vcodeTF.text.length <= 0) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastCodeEmpty];
        return;
    }
    
    // 4.判断动态码是否格式错误
    if(![BXGVerifyTool verifyCodeFormat:self.vcodeTF.text]) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastCodeFormatError];
        return;
    }
    
    // 5.判断密码为空
    if(self.passwordTF.text.length <= 0) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastPswEmpty];
        return;
    }
    
    // 6.判断密码是否格式错误
    if(![BXGVerifyTool verifyPswFormat:self.passwordTF.text]) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastPswFormatError];
        return;
    }
    
    // 7. 请求接口
    NSString *mobile = self.mobileTF.text;
    NSString *password = self.passwordTF.text;
    NSString *vcode = self.vcodeTF.text;
    BXGSocialModel *socialModel = self.socialModel;
    
    // 7.1 加载HUD
    [[BXGHUDTool share] showLoadingHUDWithString:@"请求登录.."];
    [[BXGUserCenter share] bindNewAccountWithSocialModel:socialModel Mobile:mobile Password:password Code:vcode Finished:^(BOOL succeed, NSString * _Nullable message) {
        // 7.2 显示HUD
        if(succeed){
            [[BXGHUDTool share] showHUDWithString:@"绑定成功,正在登录"];
            [weakSelf.navigationController dismissViewControllerAnimated:true completion:nil];
        }else {
            [[BXGHUDTool share] showHUDWithString:message];
        }
    }];
}

// TODO: 跳转已存在账号页面
- (void)onClickForBindExistAccountBtn:(UIButton *)sender {
    
    // 1.跳转已存在账号页面
    [self.navigationController popViewControllerAnimated:true];
}

// TODO: 勾选 事件
- (void)onClickForAceeptProtocol:(BOOL)isSelected {
    if(isSelected) {
        self.bindNewAccountBtn.enabled = true;
    }else {
        self.bindNewAccountBtn.enabled = false;
    }
}

// TODO: 跳转服务 事件
- (void)onClickReadProtocol {
    // 1.跳转到服务协议页面
    BXGUserAgreementVC *vc = [[BXGUserAgreementVC alloc]init];
    [self.navigationController pushViewController:vc animated:true];
}

// TODO: 获取动态码事件
- (void)onClickGetVCodeBtn {
    Weak(weakSelf);
    
    // 1.判断是否填写 手机号
    if(self.mobileTF.text.length <= 0) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastPhoneNumberEmpty];
        return;
    }
    
    // 2.判断是手机号格式正确
    if(![BXGVerifyTool verifyPhoneNumber:self.mobileTF.text]) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastPhoneNumberError];
        return;
    }

    // 3.启动读条
    [self.vcodeTF startCount];
    
    // 4.发送动态码
    [[BXGUserViewModel share] requestSendCodeForRegistWithMobile:self.mobileTF.text Finished:^(BOOL success) {
        [[BXGHUDTool share] showHUDWithString:@"短信发送成功"];
    } Failed:^(id  _Nonnull errorMessage) {
        [[BXGHUDTool share] showHUDWithString:errorMessage];
        [weakSelf.vcodeTF stopCount];
    }];
}
@end
