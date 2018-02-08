//
//  BXGUserResetPswVC.m
//  Boxuegu
//
//  Created by HM on 2017/6/2.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGUserResetPswVC.h"
#import "BXGUserViewModel.h"
#import "BXGRoundedBtn.h"

@interface BXGUserResetPswVC () <UITextFieldDelegate>
@property (nonatomic, weak)UITextField *userMobileField;
@property (nonatomic, weak)UITextField *codeField;

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, weak) UIButton *registBtn;
@property(nonatomic, weak) UITextField * userPswTextField;
@property(nonatomic, weak) UIImageView * pswKeyImageView;
@property (nonatomic, weak) UIButton *finishBtn;
@end

@implementation BXGUserResetPswVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 基本设置
    self.title = @"重设密码";
    
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
    
    // userPswTextField
    UITextField *userPswTextField = [UITextField new];
    [userPswTextField addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:userPswTextField];
    userPswTextField.placeholder = @"请设置登录密码，6-18位";
    userPswTextField.font = [UIFont bxg_fontRegularWithSize:16];
    [userPswTextField sizeToFit];
    
    [userPswTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(15);
        make.right.offset(-15 - 18 - 5);
        
        make.height.offset(16 + 20);
    }];
    userPswTextField.secureTextEntry = true;
    userPswTextField.clearButtonMode = UITextFieldViewModeAlways;
    userPswTextField.returnKeyType = UIReturnKeyJoin;
    userPswTextField.delegate = self;
    self.userPswTextField = userPswTextField;
    
    // pswKeyBtn
    //    UIButton *pswKeyBtn = [UIButton new];
    //    [self.contentView addSubview:pswKeyBtn];
    //    [pswKeyBtn setImage:[UIImage imageNamed:@"不看密码"] forState:UIControlStateNormal];
    //    [pswKeyBtn setImage:[UIImage imageNamed:@"看密码"] forState:UIControlStateSelected];
    //    [pswKeyBtn addTarget:self action:@selector(clickPswKeyBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    pswKeyBtn.selected = true;
    //    [pswKeyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.offset(-15);
    //        make.left.equalTo(userPswTextField.mas_right).offset(5);
    //        make.height.offset(13 + 2);
    //        make.width.offset(18);
    //        make.centerY.equalTo(userPswTextField);
    //    }];
    
    
    UIButton *pswKeyBtn = [UIButton new];
    [self.contentView addSubview:pswKeyBtn];
    [pswKeyBtn addTarget:self action:@selector(clickPswKeyBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [pswKeyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.left.equalTo(userPswTextField.mas_right).offset(0);
        make.height.equalTo(userPswTextField);
        make.centerY.equalTo(userPswTextField);
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
        make.centerY.equalTo(userPswTextField);
    }];
    self.pswKeyImageView = pswKeyImageView;
    
    
    // bottomSplitLine
    UIView *bottomSplitLine = [UIView new];
    [self.view addSubview:bottomSplitLine];
    bottomSplitLine.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [bottomSplitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userPswTextField.mas_bottom).offset(10 - 10);
        make.left.offset(15);
        make.right.offset(0);
        make.height.offset(1);
    }];
    
    // finishBtn
    BXGRoundedBtn *finishBtn = [BXGRoundedBtn buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:finishBtn];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
//    finishBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
//    [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(bottomSplitLine.mas_bottom).offset(53);
        make.height.offset(40);
    }];
    //finishBtn.layer.cornerRadius = 20;
    //[finishBtn.layer masksToBounds];
    //finishBtn.backgroundColor = [UIColor colorWithHex:0xFF38ADFF];
    [finishBtn addTarget:self action:@selector(clickTofinishBtn:) forControlEvents:UIControlEventTouchUpInside];
    finishBtn.enabled =false;
    self.finishBtn = finishBtn;
}

#pragma mark - Response

- (void)clickTofinishBtn:(UIButton *)sender{
    // requestResetPasswordWithPhoneNumber
    
    NSString *mobileString = self.mobile;
    NSString *pswString = self.userPswTextField.text;
    
    // 1.密码不能为空
    if(pswString.length <= 0) {
        
        [[BXGHUDTool share] showHUDWithString:@"请输入密码!"];
        return;
    }
    
    // 2.验证密码格式
    if(![BXGVerifyTool verifyPswFormat:pswString]){
        [[BXGHUDTool share] showHUDWithString:@"密码格式错误，请重新输入!"];
        return;
    }
    
    // 4.验证手机号或动态码是否存在
    if(self.mobile.length <= 0){
        
        [[BXGHUDTool share] showHUDWithString:@"重置失败!"];
        return;
    }
    
    [[BXGHUDTool share]showLoadingHUDWithString:nil];
    [[BXGUserViewModel share] requestResetPassWord:pswString mobile:mobileString Finished:^(BOOL success, NSString * _Nullable errorMessage) {
        
            if(success) {
            
                [[BXGHUDTool share] showHUDWithString:@"重置成功!"];
            }else {
            
                if(errorMessage){
                    
                    [[BXGHUDTool share] showHUDWithString:errorMessage];
                
                }else {
                
                    [[BXGHUDTool share] showHUDWithString:@"未知错误!"];
                }
            }
        [self.navigationController popToRootViewControllerAnimated:true];
        
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//            
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        });
        
        
        
    }];
    
    
}

//注意：事件类型是：`UIControlEventEditingChanged`
-(void)passConTextChange:(UITextField *)sender{
    
    if([BXGVerifyTool verifyPswFormat:sender.text]) {
        
        self.finishBtn.enabled = true;
        
    }else {
        
        self.finishBtn.enabled = false;
    }
    
    
    
    
    
    
    
}


- (void)clickPswKeyBtn:(UIButton *)sender {
    
    self.pswKeyImageView.highlighted = !self.pswKeyImageView.highlighted;
    self.userPswTextField.secureTextEntry = self.pswKeyImageView.highlighted;
    NSString *str = self.userPswTextField.text;
    self.userPswTextField.text = @" ";
    self.userPswTextField.text =str;
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    
    if([string isEqualToString:@"\n"]) {
        
        if(textField == self.userPswTextField) {

            [self.finishBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        return YES;
    }
    
    NSString *text;
    if(![string isEqualToString:@""]) {
    
        text = [self.userPswTextField.text stringByAppendingString:string];
        
        
        
    }else {
    
        if(self.userPswTextField.text.length > 0){
        
            text = [self.userPswTextField.text substringWithRange:NSMakeRange(0, self.userPswTextField.text.length - 1)];
        }
    }
    
    if([BXGVerifyTool verifyPswFormat:text]) {
        
        self.finishBtn.enabled = true;
        
    }else {
        
        self.finishBtn.enabled = false;
    }
    
    //得到输入框的内容
    NSString * textfieldContent = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.userPswTextField && textField.isSecureTextEntry ) {
        textField.text = textfieldContent;
        return NO;
    }
    return YES;
}


@end
