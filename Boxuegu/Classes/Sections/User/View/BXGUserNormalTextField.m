//
//  BXGUserInputTextField.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/14.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGUserNormalTextField.h"
@interface BXGUserNormalTextField()
@property (nonatomic, weak) UILabel *tagLabel;
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UIView *extensionView;



// psw
@property (nonatomic, weak) UIButton *pswKeyBtn;

@end
@implementation BXGUserNormalTextField

#pragma mark - Interface

// height

// tag

// place holder

// extension view

// keyboard type

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        [self installUI];
        
    }
    return self;
}

//@property (nonatomic, copy) NSString *tagName;
//@property (nonatomic, copy) NSString *placeHolder;
//@property (nonatomic, copy) NSString *text;
//@property (nonatomic, copy) NSString *keyBoardType;
//@property (nonatomic, assign) BXGUserInputTextFieldType *type;


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

- (void)setEnable:(BOOL)bEnable {
    self.textField.enabled = bEnable;
    if(!bEnable) {
        [self.textField setTextColor:[UIColor colorWithHex:0xCCCCCC]];
    } else {
        [self.textField setTextColor:[UIColor colorWithHex:0x000000]];
    }
}

- (UIKeyboardType)keyBoardType {
    return self.textField.keyboardType;
}

- (void)setKeyBoardType:(UIKeyboardType)keyBoardType {
    self.textField.keyboardType = keyBoardType;
}

- (void)installUI {
//    super inst
    UILabel *tagLabel = [UILabel new];
    tagLabel.text = @"动态码:";
    UITextField *textField = [UITextField new];
    textField.placeholder = @"请输入您的手机号";
    UIView *extensionView = [UIView new];
    UIView *spView = [UIView new];
    spView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    self.backgroundColor = [UIColor whiteColor];
    
    
    [self addSubview:tagLabel];
    [self addSubview:textField];
    [self addSubview:extensionView];
    [self addSubview:spView];
    
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.bottom.offset(0);
        make.width.offset(53);
        make.height.equalTo(tagLabel.superview);
    }];
    tagLabel.font = [UIFont bxg_fontRegularWithSize:16];
    tagLabel.textColor = [UIColor colorWithHex:0x666666];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tagLabel.mas_right).offset(15);
        make.centerY.equalTo(tagLabel);
        make.height.equalTo(textField.superview);
    }];
    
    [self.textField setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    textField.font = [UIFont bxg_fontRegularWithSize:16];
    [extensionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textField.mas_right);
        make.right.offset(-15);
        make.top.offset(0);
        make.width.offset(30);
        
        make.bottom.offset(0);
    }];
    
    
//    [self.extensionView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.equalTo(tagLabel);
        make.height.offset(0.5);
        
        make.right.offset(0);
    }];
    
    self.extensionView = extensionView;
    self.tagLabel = tagLabel;
    self.textField = textField;
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    textField.secureTextEntry = true;
//
//
//    UIButton *pswKeyBtn = [UIButton new];
//    pswKeyBtn.userInteractionEnabled = false;
//    self.pswKeyBtn = pswKeyBtn;
//    [self.extensionView addSubview:pswKeyBtn];
//
//    UIImageView *pswKeyImageView= [UIImageView new];
//    [pswKeyBtn addSubview:pswKeyImageView];
//    [pswKeyBtn setImage:[UIImage imageNamed:@"看密码"] forState:UIControlStateNormal];
////    pswKeyImageView.highlightedImage = [UIImage imageNamed:@"看密码"];
////    pswKeyImageView.highlighted = true;
//    [pswKeyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(18);
//        make.height.offset(13);
//        make.centerY.equalTo(tagLabel);
//        make.top.right.bottom.offset(0);
//        make.left.offset(15);
//    }];
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
//    [self.extensionView addGestureRecognizer:tap];
}


//- (void)tap:(UITapGestureRecognizer *)tap {
//    self.textField.secureTextEntry = !self.textField.secureTextEntry;
//    if(self.textField.secureTextEntry) {
//        [self.pswKeyBtn setImage:[UIImage imageNamed:@"看密码"] forState:UIControlStateNormal];
//    }else {
//        [self.pswKeyBtn setImage:[UIImage imageNamed:@"不看密码"] forState:UIControlStateNormal];
//    }
//}

- (BOOL)becomeFirstResponder {
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.textField resignFirstResponder];
}

@end
