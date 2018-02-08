//
//  BXGEditBindCellphoneVC.m
//  Boxuegu
//
//  Created by apple on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGEditBindCellphoneVC.h"
#import "BXGUserViewModel.h"
#import "BXGUserDefaults.h"
#import "BXGRoundedBtn.h"
#import "BXGUserNormalTextField.h"
#import "BXGUserVCodeTextField.h"

@interface BXGEditBindCellphoneVC ()<UITextFieldDelegate>

@property (nonatomic, weak) BXGUserViewModel *viewModel;

@property (nonatomic, weak) BXGUserNormalTextField *vphoneTF;
@property (nonatomic, weak) BXGUserVCodeTextField *vcodeTF;
@property (nonatomic, weak) UIButton *confirmBtn;

@end

@implementation BXGEditBindCellphoneVC

-(instancetype)initWithFinishModifyCellphoneBlock:(FinishModifyCellphoneBlockType)finishCellphoneBlock {
    self = [super init];
    if(self) {
        _finishCellphoneBlock = finishCellphoneBlock;
    }
    return self;
}

#pragma mark - Getter Setter

- (BXGUserViewModel *)viewModel {
    
    if(!_viewModel){
        
        _viewModel = [BXGUserViewModel share];
    }
    return _viewModel;
}

#pragma mark - Life Cycle

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.vcodeTF uninstall];
    [self.vphoneTF resignFirstResponder];
    [self.vcodeTF resignFirstResponder];
}

#pragma mark - Operation
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定手机号";

    [self installUI];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)tapView:(UITapGestureRecognizer *)tap {
    
    [self.view endEditing:true];
}

#pragma mark - 搭建界面
/**
 界面布局
 */
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
    phoneTF.placeholder = @"请输入要绑定的手机号";
    phoneTF.keyBoardType = UIKeyboardTypeNumberPad;
    
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(spView.mas_bottom).offset(kBXGUserTextFieldTopOffset);
        make.height.offset(kBXGUserTextFieldHeight);
    }];
    self.vphoneTF = phoneTF;
    [phoneTF becomeFirstResponder];
    
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
    
    // 5.绑定并登录按钮
    BXGRoundedBtn *confirmBtn = [BXGRoundedBtn buttonWithType:UIButtonTypeSystem withTitle:@"确定"];
    [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    confirmBtn.enabled = true;
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(vcodeTF.mas_bottom).offset(30);
        make.height.offset(40);
    }];
    self.confirmBtn = confirmBtn;
    
    UILabel *tipLabel = [UILabel new];
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15 + 12);
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(confirmBtn.mas_bottom).offset(15);
    }];
    
    tipLabel.font = [UIFont bxg_fontRegularWithSize:12];
    tipLabel.textColor = [UIColor colorWithHex:0x999999];
    tipLabel.text = @"提示：其他方式（邮箱）修改密码请到博学谷官网";
}



#pragma mark - Response

//获取动态码事件
- (void)onClickGetVCodeBtn {
    Weak(weakSelf);
    
    // 1.判断是否填写 手机号
    if(self.vphoneTF.text.length <= 0) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastPhoneNumberEmpty];
        return;
    }
    
    // 2.判断是手机号格式正确
    if(![BXGVerifyTool verifyPhoneNumber:self.vphoneTF.text]) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastPhoneNumberError];
        return;
    }

    // 3.启动读条
    [self.vcodeTF startCount];
    
    // 4.发送动态码
    [[BXGUserViewModel share] loadAppRequestCodeWithMobile:_vphoneTF.text
                                                withIsBind:YES
                                                  Finished:^(BOOL success, NSString* errorMessage) {
                                                      if(success) {
                                                          [[BXGHUDTool share] showHUDWithString:@"短信发送成功"];
                                                      } else {
                                                          [[BXGHUDTool share] showHUDWithString:errorMessage];
                                                          [weakSelf.vcodeTF stopCount];
                                                      }
                                                  }];
}


- (void)confirm:(UIButton *)sender{
    
    __weak typeof (self) weakSelf = self;
    NSString *mobileStirng = self.vphoneTF.text;
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
    
    if(_finishCellphoneBlock) {
        _finishCellphoneBlock(mobileStirng, vCodeString);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
