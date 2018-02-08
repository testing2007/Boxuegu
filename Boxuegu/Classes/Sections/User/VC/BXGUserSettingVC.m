//
//  BXGUserSettingController.m
//  Boxuegu
//
//  Created by RW on 2017/4/13.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGUserSettingVC.h"
#import "BXGHUDTool.h"
#import "BXGUserViewModel.h"
#import "BXGVerifyTool.h"

@interface BXGUserSettingVC () <UITextFieldDelegate>

@property (nonatomic, weak) UITextField *nickNameTF;
@property (nonatomic, weak) UITextField *pswTF;
@property (nonatomic, weak) UIButton *finishBtn;
@property (nonatomic, weak) UIImageView *pswKeyImageView;
@end

@implementation BXGUserSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置密码和用户名";
    self.pageName = @"设置密码和用户名";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self installUI];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)tapView:(UITapGestureRecognizer *)tap {
    
    [self.view endEditing:true];
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}
#pragma mark - 搭建布局

- (void)installUI {
    
    UIView *separateView = [UIView new];
    [self.view addSubview:separateView];
    separateView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.height.offset(9);
        make.left.right.offset(0);
    }];

    // userIdTextField
    UITextField *nickNameTextField = [UITextField new];
    [self.view addSubview:nickNameTextField];
    nickNameTextField.placeholder = @"请设置您的用户名";
    nickNameTextField.font = [UIFont bxg_fontRegularWithSize:16];
    [nickNameTextField sizeToFit];
    [nickNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separateView.mas_bottom).offset(20 - 10);
        make.left.offset(15);
        make.right.offset(-15 - 18 - 5);
        make.height.offset(16 + 20);
    }];
    nickNameTextField.delegate =self;
    
    nickNameTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.nickNameTF = nickNameTextField;
    // topSplitLine
    UIView *topSplitLine = [UIView new];
    [self.view addSubview:topSplitLine];
    topSplitLine.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [topSplitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nickNameTextField.mas_bottom).offset(10 - 10);
        make.left.offset(15);
        make.right.offset(0);
        make.height.offset(1);
    }];
    nickNameTextField.returnKeyType = UIReturnKeyNext;
    
    // userPswTextField
    UITextField *pswSettingTextField = [UITextField new];
    [self.view addSubview:pswSettingTextField];
    pswSettingTextField.placeholder = @"请输设置您的密码";
    pswSettingTextField.font = [UIFont bxg_fontRegularWithSize:16];
    [pswSettingTextField sizeToFit];
    [pswSettingTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topSplitLine.mas_bottom).offset(25 -10);
        make.left.offset(15);
        make.right.equalTo(nickNameTextField.mas_right);
        make.height.offset(16 + 20);
    }];
    pswSettingTextField.secureTextEntry = true;
    pswSettingTextField.clearButtonMode = UITextFieldViewModeAlways;
    pswSettingTextField.delegate = self;
    pswSettingTextField.returnKeyType = UIReturnKeyDone;
    self.pswTF = pswSettingTextField;
    pswSettingTextField.delegate =self;
    UIButton *pswKeyBtn = [UIButton new];
    [self.view addSubview:pswKeyBtn];
    [pswKeyBtn addTarget:self action:@selector(clickPswKeyBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [pswKeyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.left.equalTo(pswSettingTextField.mas_right).offset(0);
        make.height.equalTo(pswSettingTextField);
        make.centerY.equalTo(pswSettingTextField);
    }];
    
    
    UIImageView *pswKeyImageView= [UIImageView new];
    [pswKeyBtn addSubview:pswKeyImageView];
    pswKeyImageView.image = [UIImage imageNamed:@"不看密码"];
    pswKeyImageView.highlightedImage = [UIImage imageNamed:@"看密码"];
    pswKeyImageView.highlighted = true;
    [pswKeyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(18);
        make.height.offset(13);
        make.right.offset(-15);
        make.centerY.equalTo(pswSettingTextField);
    }];

    self.pswKeyImageView = pswKeyImageView;
    
    // bottomSplitLine
    UIView *bottomSplitLine = [UIView new];
    [self.view addSubview:bottomSplitLine];
    bottomSplitLine.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [bottomSplitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pswSettingTextField.mas_bottom).offset(10 - 10);
        make.left.offset(15);
        make.right.offset(0);
        make.height.offset(1);
    }];
    
    // finishBtn
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:finishBtn];
    [finishBtn setTitle:@"完成注册" forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(bottomSplitLine.mas_bottom).offset(53);
        make.height.offset(40);
    }];
    finishBtn.layer.cornerRadius = 20;
    [finishBtn.layer masksToBounds];
    finishBtn.backgroundColor = [UIColor colorWithHex:0xFF38ADFF];
    [finishBtn addTarget:self action:@selector(clickFinishButton) forControlEvents:UIControlEventTouchUpInside];
    self.finishBtn = finishBtn;
    
}

#pragma mark - 响应

- (void)clickFinishButton {
    
    NSString *nickNameString = self.nickNameTF.text;
    NSString *pswString = self.pswTF.text;
    [[BXGBaiduStatistic share] statisticEventString:regist_done_07 andParameter:nil];
    
    // 1.昵称不能为空
    if(nickNameString.length <= 0) {

        [[BXGHUDTool share] showHUDWithString:kBXGToastUserNameEmpty];
        return;
    }
    
    if(![BXGVerifyTool verifyUserNameFormat:nickNameString]) {
        
        [[BXGHUDTool share] showHUDWithString:kBXGToastUserIdFormatError];
        return;
    }
    
    // 2.密码不能为空
    if(pswString.length <= 0) {
    
        [[BXGHUDTool share] showHUDWithString:kBXGToastPswEmpty];
        return;
    }
    
    // 3.验证密码格式
    if(![BXGVerifyTool verifyPswFormat:pswString]){
        [[BXGHUDTool share] showHUDWithString:kBXGToastPswFormatError];
        return;
    }

    // 4.验证手机号或动态码是否存在
    if(self.mobile.length <= 0 || self.code.length <= 0){
        
        [[BXGHUDTool share] showHUDWithString:@"注册异常!"];
        return;
    }

    
    // 请求注册 / 完成回到登录界面
    [[BXGUserViewModel share] requestPhoneRegistWithUserName:self.nickNameTF.text passWord:self.pswTF.text mobile:self.mobile code:self.code Finished:^(id responseObject) {
        
        if(responseObject && responseObject[@"success"] != [NSNull null]){
        
            if([responseObject[@"success"] boolValue]) {
                
                [[BXGHUDTool share] showHUDWithString:@"注册成功!"];
                [self dismissViewControllerAnimated:true completion:nil];
                return;
            }
        }
        [[BXGHUDTool share] showHUDWithString:@"注册失败!"];
        [self dismissViewControllerAnimated:true completion:nil];
        
    } Failed:^(NSError *error) {
        [[BXGHUDTool share] showHUDWithString:kBXGToastLodingError];
    }];
}

- (void)clickPswKeyBtn:(UIButton *)sender {
    
    self.pswKeyImageView.highlighted = !self.pswKeyImageView.highlighted;
    self.pswTF.secureTextEntry = self.pswKeyImageView.highlighted;
    
    NSString *str = self.pswTF.text;
    self.pswTF.text = @" ";
    self.pswTF.text =str;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString * textfieldContent = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.pswTF && textField.isSecureTextEntry ) {
        
        
        
        if([string isEqualToString:@"\n"]){
            
            [self.finishBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            return false;
        }else {
        
            textField.text = textfieldContent;
        }
        return NO;
    }else {
        
        
        if([string isEqualToString:@"\n"]){
            
            if(textField == self.nickNameTF) {
                
                [self.pswTF becomeFirstResponder];
                return false;
            }else {
                
                [self.finishBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
                return false;
            }
        }
        return true;
    }
}


@end
