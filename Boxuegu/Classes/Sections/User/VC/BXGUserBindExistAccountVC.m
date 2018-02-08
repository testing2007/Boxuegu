//
//  BXGUserBindExistAccountVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGUserBindExistAccountVC.h"
#import "BXGUserNormalTextField.h"
#import "BXGUserPasswordTextField.h"
#import "BXGRoundedBtn.h"
#import "BXGUserBindNewAccountVC.h"
#import "BXGSocialManager.h"

@interface BXGUserBindExistAccountVC ()
@property (nonatomic, weak) BXGUserNormalTextField *userTF;
@property (nonatomic, weak) BXGUserPasswordTextField *passwordTF;
@end

@implementation BXGUserBindExistAccountVC

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定已有账号";
    [self installUI];
}

- (void)dealloc {
    
}

#pragma mark - UI

- (void)installUI {
    
    // 1.头部分界视图
    UIView *spView = [UIView new];
    spView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [self.view addSubview:spView];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(40);
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
    }];
    
    // 2.头部提示视图
    UILabel *label = [[UILabel alloc]init];
    [spView addSubview:label];
    NSString *text = @"如曾注册过博学谷账号请绑定原账号";
    label.text = text;
    label.font = [UIFont bxg_fontRegularWithSize:14];
    label.textColor = [UIColor colorWithHex:0x666666];
    [label sizeToFit];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(spView);
        make.left.offset(15);
    }];
    
    // 3.账号输入框
    BXGUserNormalTextField *userTF = [BXGUserNormalTextField new];
    userTF.tagName = @"账　号:";
    userTF.placeholder = @"请输入手机号/邮箱";
    [self.view addSubview:userTF];
    [userTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(spView.mas_bottom).offset(kBXGUserTextFieldTopOffset);
        make.height.offset(kBXGUserTextFieldHeight);
    }];
    
    // 4.密码输入框
    BXGUserPasswordTextField *passwordTF = [BXGUserPasswordTextField new];
    [self.view addSubview:passwordTF];
    passwordTF.tagName = @"密　码:";
    passwordTF.placeholder = @"请输入密码";
    [passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(userTF.mas_bottom).offset(kBXGUserTextFieldTopOffset);
        make.height.offset(kBXGUserTextFieldHeight); //
    }];
    
    // 5.绑定并登录按钮
    BXGRoundedBtn *bindExistAccountBtn = [BXGRoundedBtn buttonWithType:UIButtonTypeSystem withTitle:@"绑定并登录"];
    [self.view addSubview:bindExistAccountBtn];
    
    bindExistAccountBtn.enabled = true;
    [bindExistAccountBtn addTarget:self action:@selector(onClickBindExistAccountBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bindExistAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(passwordTF.mas_bottom).offset(30);
        make.height.offset(40);
    }];
    
    // 6.提示视图
    UILabel *tipLabel = [[UILabel alloc]init];
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(bindExistAccountBtn.mas_bottom).offset(25);
    }];
    tipLabel.numberOfLines = 0;
    NSString *text1 = @"*";
    NSString *text2 = @"绑定账号后，已购买课程才能同步学习，同时可收到课程服务的相关通知信息。";
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",text1,text2]];
    
    tipLabel.font = [UIFont bxg_fontRegularWithSize:12];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xFF554C] range:NSMakeRange(0, text1.length)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x999999] range:NSMakeRange(text1.length, text2.length)];
    tipLabel.attributedText = string;
    
    // 7.跳转到绑定新账号视图
    UIButton *toBindNewBtn = [UIButton new];
    [toBindNewBtn addTarget:self action:@selector(onClickForBindNewAccountBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toBindNewBtn];
    toBindNewBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:14];
    [toBindNewBtn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [toBindNewBtn sizeToFit];
    [toBindNewBtn setTitle:@"绑定新账号" forState:UIControlStateNormal];
    [toBindNewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(25);
        make.centerX.offset(0);
    }];
    
    // 8.设置接口
    self.userTF = userTF;
    self.passwordTF = passwordTF;
    
    // 9.关闭键盘事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapView:(UITapGestureRecognizer *)tap {
    [self.view endEditing:true];
}
#pragma mark - Response

// TODO: 跳转到新账号绑定事件
- (void)onClickForBindNewAccountBtn:(UIButton *)sender {

    BXGUserBindNewAccountVC *vc = [BXGUserBindNewAccountVC new];
    vc.socialModel = self.socialModel;
    [self.navigationController pushViewController:vc animated:true];
}

// TODO: 绑定已有账号事件
- (void)onClickBindExistAccountBtn:(UIButton *)sender {
    
    Weak(weakSelf);
    [[BXGBaiduStatistic share] statisticEventString:kBXGStatSocialEventTypeSocialBindId andLabel:@"绑定已有账号"];
    
    // 1.判断是否填写 手机号
    if(self.userTF.text.length <= 0) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastUserNameEmpty];
        return;
    }
    
    // 2.判断是手机号格式正确
    if( ![BXGVerifyTool verifyEmail:self.userTF.text] && ![BXGVerifyTool verifyPhoneNumber:self.userTF.text]){
        [weakSelf.hudTool showHUDWithString:kBXGToastUserIdFormatError View:weakSelf.view];
        return;
    }
    
    // 3.判断密码为空
    if(self.passwordTF.text.length <= 0) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastPswEmpty];
        return;
    }
    
    // 4.判断密码是否格式错误
    if(![BXGVerifyTool verifyPswFormat:self.passwordTF.text]) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastPswFormatError];
        return;
    }
    
    // 5.打开HUD
    [[BXGHUDTool share] showLoadingHUDWithString:nil];
    
//    NSString *thirdId = self.socialModel.uid;
    NSString *userName = self.userTF.text;
    NSString *password = self.passwordTF.text;
    BXGSocialModel *socialModel = self.socialModel;
//    BXGSocialPlatformType type = self.socialModel.type;
    
    // 6.请求接口
    [[BXGUserCenter share] bindExistAccountWithSocialModel:socialModel UserName:userName Password:password Finished:^(BOOL succeed, NSString * _Nullable message) {
        if(succeed) {
            // 成功 HUD 打印 登录成功
            [[BXGHUDTool share] showHUDWithString:@"绑定成功,正在登录"];
            [weakSelf.navigationController dismissViewControllerAnimated:true completion:nil];
        }else {
            // 失败 HUD 打印 MSG
            [[BXGHUDTool share] showHUDWithString:message];
        }
    }];
}
@end
