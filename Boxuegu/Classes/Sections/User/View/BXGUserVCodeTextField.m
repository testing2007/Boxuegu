//
//  BXGUserVCodeTextField.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGUserVCodeTextField.h"
#define kGetVCodeCountdownTime 90
#define kGetVCodeString @"获取动态码"

@interface BXGUserVCodeTextField()

@property (nonatomic, weak) UILabel *tagLabel;
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UIView *extensionView;
@property (nonatomic, weak) UIButton *vcodeBtn;

///// 获取动态码计数器
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDate *lastDate;


@end

@implementation BXGUserVCodeTextField
//     设置 Timer
- (void)install {

    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeIntervalAction) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.vcodeBtn setTitle:kGetVCodeString forState:UIControlStateNormal];
}

- (void)timeIntervalAction {
    if(self.lastDate){

        NSTimeInterval preTimeInterval = [self.lastDate timeIntervalSinceNow];
        NSInteger countdown = kGetVCodeCountdownTime + (NSInteger)preTimeInterval;

        if(countdown >= 0) {

            // 更新 按钮时间
            [self.vcodeBtn setTitle:[@(countdown).description stringByAppendingString:@" S"] forState:UIControlStateNormal];
            self.vcodeBtn.enabled = false;
            return;
        }
    }

    [self.vcodeBtn setTitle:kGetVCodeString forState:UIControlStateNormal];
    self.vcodeBtn.enabled = true;
}

- (void)uninstall {
    if(self.timer) {
        [self.timer invalidate];
    }

}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        [self installUI];
        [self install];
    }
    return self;
}
- (void)setTagName:(NSString *)tagName {
    self.tagLabel.text = tagName;
}

- (NSString *)tagName {
    return self.tagLabel.text;
}
- (NSString *)placeholder {
    return self.textField.placeholder;
}

- (void)setPlaceholder:(NSString *)placeHolder {
    self.textField.placeholder = placeHolder;
}

- (NSString *)text {
    return self.textField.text;
}

- (void)setText:(NSString *)text {
    self.textField.text = text;
}
- (UIKeyboardType)keyBoardType {
    return self.textField.keyboardType;
}

- (void)setKeyBoardType:(UIKeyboardType)keyBoardType {
    self.textField.keyboardType = keyBoardType;
}

- (void)installUI {
    self.backgroundColor = [UIColor whiteColor];
    
//     tag label
    UILabel *tagLabel = [UILabel new];
    [self addSubview:tagLabel];
    tagLabel.text = @"动态码:";
    tagLabel.font = [UIFont bxg_fontRegularWithSize:16];
    tagLabel.textColor = [UIColor colorWithHex:0x666666];

    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(15);
        make.bottom.offset(0);
        make.width.offset(53);
    }];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [self addSubview:textField];

    textField.placeholder = @"请输入动态码";
    textField.font = [UIFont bxg_fontRegularWithSize:16];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tagLabel.mas_right).offset(15);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
    
    UIView *spView = [UIView new];
    spView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [self addSubview:spView];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.equalTo(tagLabel);
        make.height.offset(0.5);
        make.right.offset(0);
    }];
    

    // text field
    UIView *extensionView = [UIView new];
    [self addSubview:extensionView];
    [extensionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textField.mas_right);
        make.right.offset(-15);
        make.top.offset(0);
        make.width.offset(65);

        make.bottom.offset(0);
    }];
    [extensionView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    UIButton *getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [extensionView addSubview:getCodeBtn];
    [getCodeBtn addTarget:self action:@selector(clickGetVCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [getCodeBtn setTitleColor:[UIColor colorWithHex:0xFF38ADFF] forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[UIColor colorWithHex:0xFF38ADFF] forState:UIControlStateDisabled];
    [getCodeBtn setTitle:@"" forState:UIControlStateNormal];
    [getCodeBtn setTitle:kGetVCodeString forState:UIControlStateNormal];
    
    getCodeBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:12];

    [getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(textField);
        make.centerY.equalTo(textField);
        make.left.right.offset(0);
    }];
    [getCodeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    self.vcodeBtn = getCodeBtn;
    self.extensionView = extensionView;
    self.tagLabel = tagLabel;
    self.textField = textField;

}

#pragma mark - Response

- (void)clickGetVCodeBtn:(UIButton *)sender{
    
    if(self.clickBlock) {
        self.clickBlock();
    }
}

- (void)tap:(UITapGestureRecognizer *)tap {
    [self clickGetVCodeBtn:self.vcodeBtn];
}

//#pragma mark - Function
//
- (void)startCount {

    self.vcodeBtn.enabled = false;
    self.lastDate = [NSDate new];

    if(self.lastDate){

        NSTimeInterval preTimeInterval = [self.lastDate timeIntervalSinceNow];
        NSInteger countdown = kGetVCodeCountdownTime + (NSInteger)preTimeInterval;

        if(countdown >= 0) {

            // 更新 按钮时间
            [self.vcodeBtn setTitle:[@(countdown).description stringByAppendingString:@" S"] forState:UIControlStateNormal];
            self.vcodeBtn.enabled = false;
            return;
        }
    }
}
//
- (void)stopCount {

    self.vcodeBtn.enabled = true;
    self.lastDate = nil;
    [self.vcodeBtn setTitle:kGetVCodeString forState:UIControlStateNormal];
}

- (BOOL)becomeFirstResponder {
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.textField resignFirstResponder];
}

@end


