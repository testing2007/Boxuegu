//
//  BXGMeFeedBackViewController.m
//  Boxuegu
//
//  Created by RW on 2017/4/14.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMeFeedbackVC.h"
#import "BXGMeViewModel.h"

#import "BXGMeFeedbackTextView.h"

@interface BXGMeFeedbackVC () <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic,weak) UILabel *placeHolderLabel;
@property (nonatomic,weak) UITextView *thanksTextView;
@property (nonatomic, weak) UITextField *contactTextField;
@property (nonatomic, weak) UIButton *submitBtn;
@property (nonatomic, weak) UILabel *counterLabel;

@property (nonatomic, weak) BXGMeViewModel *viewModel;
@end

@implementation BXGMeFeedbackVC

#pragma mark - Getter Setter

-(BXGMeViewModel *)viewModel {

    if(!_viewModel){
    
        _viewModel = [BXGMeViewModel share];
    }
    return _viewModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    
    [self installUI];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self.view addGestureRecognizer:tapGesture];
}


- (void)tapView:(UITapGestureRecognizer *)tap {
    
    [self.view endEditing:true];
}


-(void)installUI {
 
    UIView *separateView = [UIView new];
    [self.view addSubview:separateView];
    separateView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(K_NAVIGATION_BAR_OFFSET);
        make.height.offset(9);
        make.left.right.offset(0);
    }];
    
    
    UITextView *thanksTextView = [self installFeedBackTextView];
    [self.view addSubview:thanksTextView];
    [thanksTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separateView.mas_bottom).offset(15);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(140);
    }];
    // [thanksTextView layoutIfNeeded];
    thanksTextView.delegate = self;
    thanksTextView.returnKeyType = UIReturnKeyNext;

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITextField *contactTextField = [self installContactTextField];
    [self.view addSubview:contactTextField];
    [contactTextField sizeToFit];
    [contactTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(thanksTextView.mas_bottom).offset(30 - 2);
        make.height.offset(16 + 2 + 2);
        make.left.equalTo(thanksTextView);
    }];
    contactTextField.delegate = self;
    contactTextField.returnKeyType = UIReturnKeyDone;
    
    UIView *splitLine = [self installSplitLineView];
    [self.view addSubview:splitLine];
    [splitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(contactTextField.mas_bottom).offset(15 - 2);
        make.left.equalTo(thanksTextView);
        make.right.equalTo(thanksTextView);
        make.height.offset(1);
    }];
    
    
    
    UIButton *submitButton = [self makeSubmitButton];
    [self.view addSubview:submitButton];
    self.submitBtn = submitButton;
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(splitLine.mas_bottom).offset(53);
        make.left.equalTo(thanksTextView);
        make.right.equalTo(thanksTextView);
        make.height.offset(40);
        
    }];
    
    
    UILabel *counterLabel = [UILabel new];
    self.counterLabel = counterLabel;
    [self.view addSubview:counterLabel];
    counterLabel.text = @"400";
    // counterLabel.textAlignment = NSTextAlignmentRight;
    counterLabel.textAlignment = NSTextAlignmentCenter;
    [counterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.thanksTextView).offset(0);
        make.bottom.equalTo(self.thanksTextView);
        make.height.offset(10 + 10 + 15);
        make.width.offset(40);
    }];
    counterLabel.font = [UIFont bxg_fontRegularWithSize:15];
    counterLabel.textColor = [UIColor colorWithHex:0x999999];
}

- (UITextView *)installFeedBackTextView {

    UITextView *feedBackTextView = [BXGMeFeedbackTextView new];
    feedBackTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    feedBackTextView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    // feedBackTextView.contentInset =
    UILabel *placeHolderLabel = [UILabel new];
    
    // feedBackTextView.textContainerInset = UIEdgeInsetsMake(-2, 0, 0, 0);
    
    
    self.placeHolderLabel = placeHolderLabel;
    self.thanksTextView = feedBackTextView;
    
    // thanksTextView.layer.borderWidth = 1.0 / [[UIScreen mainScreen] scale];
    feedBackTextView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    feedBackTextView.layer.cornerRadius = 4;
    
    
    feedBackTextView.delegate = self;
    feedBackTextView.font = [UIFont bxg_fontRegularWithSize:16];
    feedBackTextView.textColor = [UIColor colorWithHex:0x333333];
    // thanksTextView
    placeHolderLabel.font = [UIFont bxg_fontRegularWithSize:16];
    placeHolderLabel.text = @"感谢你为我们提出的宝贵意见和建议";
    
    [feedBackTextView addSubview:placeHolderLabel];
    placeHolderLabel.textColor = [UIColor colorWithHex:0xbbbbbb];
    
    [placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(9);
        make.left.offset(15);
    }];
    
    return feedBackTextView;
}

- (UITextField *)installContactTextField {
    
    UITextField *contactTextField = [UITextField new];
    self.contactTextField = contactTextField;
    // contactTextField.placeholder = @"请输入你的手机号，我们会尽快与您联系";
    contactTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入你的手机号码,方便答疑解惑!" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0xcccccc], NSFontAttributeName: [UIFont bxg_fontRegularWithSize:16]}];
    contactTextField.keyboardType = UIKeyboardTypeNumberPad;
    contactTextField.font = [UIFont bxg_fontRegularWithSize:16];
    return contactTextField;
    
    
}
- (UIView *)installSplitLineView {

    UIView * view = [UIView new];
    view.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    return view;
}

- (UIButton *)makeSubmitButton {
    
    UIButton *submitButton = [UIButton new];
    submitButton.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    submitButton.layer.cornerRadius = 20;
    [submitButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    
    [submitButton addTarget:self action:@selector(clickSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    return submitButton;
    
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // NSLog(@"text:%@",text);
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1 && textView.text.length == 1)
    {
        self.placeHolderLabel.hidden = NO;
    }
    //[text isEqualToString:@""] 表示输入的是退格键
    if (![text isEqualToString:@""] )
    {
        self.placeHolderLabel.hidden = YES;
    }else {
    
        if(self.thanksTextView.text){
            
//            if(self.thanksTextView.text.length > 1) {
//            
//                self.counterLabel.text = @(400 - self.thanksTextView.text.length + 1).description;
//            }else {
//            
//                self.counterLabel.text = @"400";
//            }
            
        }
        return true;
    }
    
    //range.location == 0 && range.length == 1 表示输入的是第一个字符
    
    
    if([text isEqualToString:@"\n"]){
    
        if(textView.text.length ==0) {
            self.placeHolderLabel.hidden = NO;
        }
        [self.contactTextField becomeFirstResponder];
        return NO;
    }
    if((self.thanksTextView.text.length + text.length) > 400){
        
        [[BXGHUDTool share] showHUDWithString:@"请输入少于400个字!"];
        return false;
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if([string isEqualToString:@"\n"]){
    
        [self.submitBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        return false;
    }
    if ([string isEqualToString:@""])
    {
        return true;
    }
    
    if(self.contactTextField.text.length > 11 - 1){
        
        return NO;
    }
    return true;
}


#pragma mark - Response
//判断是否有emoji
-(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    return returnValue;
}
/**
 点击提交触发事件
 */
- (void)clickSubmitBtn:(UIButton *)sender {

    // 判断是否空
    [[BXGBaiduStatistic share] statisticEventString:wdyjkktj andParameter:nil];
    NSString *text = self.thanksTextView.text;
    if(text){
        
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    if([text isEqualToString:@""]){
    
        [[BXGHUDTool share] showHUDWithString:@"请输入不少于5个字!"];
        self.thanksTextView.text = @"";
        [self.thanksTextView becomeFirstResponder];
        return;
    }
    if([self stringContainsEmoji:text]) {
        
        [[BXGHUDTool share] showHUDWithString:kBXGToastNoSupportEmoji];
        return;
    }
    
    
//    if([BXGVerifyTool verifyFeedbackMin:self.thanksTextView.text]){
//    
//        [[BXGHUDTool share] showHUDWithString:@"请输入不少于5个字"];
//        [self.thanksTextView becomeFirstResponder];
//        
//        return;
//    }
//    
//    if(![BXGVerifyTool verifyFeedbackMax:self.thanksTextView.text]){
//        
//        [[BXGHUDTool share] showHUDWithString:@"请输入少于120个字"];
//        [self.thanksTextView becomeFirstResponder];
//        return;
//    }
    
    if(self.thanksTextView.text.length < 5){
        
        [[BXGHUDTool share] showHUDWithString:@"请输入不少于5个字!"];
        [self.thanksTextView becomeFirstResponder];
        
        return;
    }
    
    if(self.thanksTextView.text.length > 400){
        
        [[BXGHUDTool share] showHUDWithString:@"请输入少于400个字!"];
        [self.thanksTextView becomeFirstResponder];
        return;
    }
    
    
    if([self.contactTextField.text isEqualToString:@""]){
    
        //[[BXGHUDTool share] showHUDWithString:@"请输入联系方式不能为空"];
        // [self.contactTextField becomeFirstResponder];
        // return;
    }else {
    
        if(![BXGVerifyTool verifyPhoneNumber:self.contactTextField.text]){
            
            [[BXGHUDTool share] showHUDWithString:kBXGToastPhoneNumberError];
            [self.contactTextField becomeFirstResponder];
            return;
        }
    }

    sender.enabled = false;
    
    __weak typeof (self) weakSelf = self;
    [[BXGHUDTool share] showLoadingHUDWithString:@""];
    [self.viewModel requestFeedBackWithText:self.thanksTextView.text andPhoneNumber:self.contactTextField.text andFinished:^(id responseObject) {
        
        // 提示提交成功
        [[BXGHUDTool share] showHUDWithString:@"提交成功!"];
        sender.enabled = true;
        
        // 回到首页
        [weakSelf.navigationController popViewControllerAnimated:true];
    } Failed:^(NSError *error) {
        
        [[BXGHUDTool share] showHUDWithString:@"提交失败!"];
        sender.enabled = true;
    }];
}


- (void)textViewDidChangeSelection:(UITextView *)textView {

    self.counterLabel.text =  @(400 - textView.text.length).description;
}

@end
