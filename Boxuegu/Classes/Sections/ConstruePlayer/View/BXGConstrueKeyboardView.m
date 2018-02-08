//
//  BXGConstrueKeyboardView.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/12.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGConstrueKeyboardView.h"
#import "UITextField+Extension.h"

#define kInputViewFaceViewWidth 55
#define kInputViewSendViewWidth 64
#define K_BXG_CONSTRUE_LIVE_TEXTFIELD_MAX_COUNT 300

@interface BXGConstrueKeyboardView() <UITextFieldDelegate>

@property (nonatomic, assign) BOOL isOpenEmojiKeyboard;
@property (nonatomic, strong) UIView *emojiView;
@property (nonatomic, strong) UIButton *faceBtn;
@end

@implementation BXGConstrueKeyboardView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        [self installUI];
        [self installObservers];
    }
    return self;
}

- (void)dealloc {
    [self uninstallObservers];
}

#pragma mark - observers

- (void)installObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboadWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboadWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)uninstallObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ui

- (void)installUI {
    
    // 1.表情View
    UIButton *faceView = self.faceBtn;
    [self addSubview:faceView];
    
    [faceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
        make.width.offset(kInputViewFaceViewWidth);
    }];
    
    // 2.TextField
    UITextField *textView = [UITextField new];
    
    [self addSubview:textView];
    textView.placeholder = @"来说点什么吧";
    textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(faceView.mas_right).offset(15);
        make.bottom.top.offset(0);
    }];
    textView.delegate = self;
    textView.returnKeyType = UIReturnKeySend;
    self.textView = textView;
    
    // 3.Send View
    UIButton *sendView = [UIButton new];
    [self addSubview:sendView];
    sendView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [sendView setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [sendView setTitle:@"发送" forState:UIControlStateNormal];
    [sendView addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [sendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textView.mas_right).offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
        make.right.offset(0);
        make.width.offset(kInputViewSendViewWidth);
    }];
    
    // 4.left spView
    UIView *leftSpView = [UIView new];
    leftSpView.backgroundColor = [UIColor colorWithHex:0xcccccc];
    [self addSubview:leftSpView];
    [leftSpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(faceView.mas_right);
        make.centerY.equalTo(self);
        make.width.offset(1);
        make.height.offset(25);
    }];
    
    // 5.right spView
    UIView *rightSpView = [UIView new];
    rightSpView.backgroundColor = [UIColor colorWithHex:0xcccccc];
    [self addSubview:rightSpView];
    [rightSpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textView.mas_right);
        make.centerY.equalTo(self);
        make.width.offset(1);
        make.height.offset(25);
    }];
    self.layer.borderColor = [UIColor colorWithHex:0xf5f5f5].CGColor;
    self.layer.borderWidth = 0.5;
}

- (UIView *)emojiView {
    
    if(_emojiView == nil) {
        _emojiView = [UIView new];
        
        NSInteger count = 21;
        NSInteger colCount = 7;
        NSInteger rowCount = count / colCount + (count % colCount == 0 ? 0 : 1);
        
        CGFloat leftMargin = 15;
        if(K_IS_IPHONE_6_PLUS) {
            leftMargin = 30;
        }
        
        CGFloat rightMargin = leftMargin;
        CGFloat topMargin = leftMargin;
        
        CGFloat bottomMargin = topMargin;
        if(K_IS_IPHONE_X) {
            bottomMargin = K_BOTTOM_SAFE_OFFSET;
        }
        
        CGFloat width = 30;
        CGFloat height = width;
        CGFloat widthMax = ([UIScreen mainScreen].bounds.size.height > [UIScreen mainScreen].bounds.size.width? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height) - leftMargin - rightMargin;
        CGFloat heightMax = widthMax / colCount * rowCount;
        
        
        _emojiView.frame = CGRectMake(0, 0, 0, heightMax + topMargin + bottomMargin);
        
        for(NSInteger i = 0; i < count; i++) {
            NSInteger row = i / colCount;
            NSInteger col = i % colCount;
            
            CGFloat horizontalMargin = (widthMax - (colCount * width)) / (colCount - 1);
            CGFloat verticalMargin = (heightMax - (rowCount * height)) / (rowCount - 1);
            
            CGFloat x = leftMargin + (width + horizontalMargin) * col;
            CGFloat y = topMargin + (height + verticalMargin) * row;
            
            UIButton *btn = [UIButton new];
            btn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            NSString *imageName = [NSString stringWithFormat:@"live_chat_emoji_%02zd",i + 1];
            if(i == count - 1) {
                imageName = @"live_chat_emoji_delete";
                [btn addTarget:self action:@selector(clearEmoji:) forControlEvents:UIControlEventTouchUpInside];
            }else {
                [btn addTarget:self action:@selector(addEmoji:) forControlEvents:UIControlEventTouchUpInside];
            }
            [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            
            [_emojiView addSubview:btn];
            btn.frame = CGRectMake(x, y, width, height);
            //            btn.backgroundColor = [UIColor randomColor];
            btn.tag = i + 1;
            
            _emojiView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        }
    }
    return _emojiView;
}

- (UIButton *)faceBtn {
    
    if(_faceBtn == nil) {
        
        _faceBtn = [UIButton new];
        [_faceBtn setImage:[UIImage imageNamed:@"直播键盘-表情"] forState:UIControlStateNormal];
        [_faceBtn addTarget:self action:@selector(openEmojiKeyboard) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceBtn;
}

#pragma mark - method

- (void)sendMessage{
    
    NSString *msg = self.textView.text;
    self.textView.text = nil;
    if(self.sendMessageBlock) {
        self.sendMessageBlock(msg);
    }
}

- (void)addEmoji:(UIButton *)sender {
    NSInteger index = sender.tag;
    
    if(self.textView.text.length > K_BXG_CONSTRUE_LIVE_TEXTFIELD_MAX_COUNT) {
        return;
    }
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"live_chat_emoji_%02zd",index]];
    
    NSString *emojiString = [NSString stringWithFormat:@"[em2_%02zd]",index];
    if(!image){
        return;
    }
    // 添加
    NSMutableString *string = self.textView.text.mutableCopy;
    [string appendString:emojiString];
    self.textView.text = string;
}

- (void)openEmojiKeyboard {
    
    if(!self.isOpenEmojiKeyboard) {
        self.textView.inputView = self.emojiView;
        [self.textView reloadInputViews];
        [self.textView becomeFirstResponder];
        self.isOpenEmojiKeyboard = true;
        
        // 设置图标
    }else {
        self.textView.inputView = nil;
        [self.textView reloadInputViews];
        self.isOpenEmojiKeyboard = false;
        [self.textView becomeFirstResponder];
    }
}

- (void)setIsOpenEmojiKeyboard:(BOOL)isOpenEmojiKeyboard {
    _isOpenEmojiKeyboard = isOpenEmojiKeyboard;
    if(isOpenEmojiKeyboard) {
        [self.faceBtn setImage:[UIImage imageNamed:@"直播键盘-表情选中"] forState:UIControlStateNormal];
    }else {
        [self.faceBtn setImage:[UIImage imageNamed:@"直播键盘-表情"] forState:UIControlStateNormal];
    }
}

- (void)closeEmojiKeyboard {
    self.textView.inputView = nil;
}

- (void)clearEmoji:(UIButton *)sender{
    
    BOOL isEmoji = false;
    
    NSString *string = self.textView.text;
    UITextField *textField = self.textView;
    
    NSRange range = self.textView.selectedRange;
    
    NSRange seletedRange = self.textView.selectedRange;
    // 1.判断有没有选择 有选择-删除选择项
    if(seletedRange.length != 0) {
        NSMutableString *string = self.textView.text.mutableCopy;
        [string replaceCharactersInRange:seletedRange withString:@""];
        return;
    }
    
    // 2.是否有删除项
    NSInteger location = range.location - 1;
    NSInteger length = 1;
    NSString *deleteString = nil;
    NSRange deleteRange = NSMakeRange(location, length);
    if(location < 0) {
        return;
    }
    
    deleteString = [string substringWithRange:deleteRange];
    
    // 3.是否是emoji
    NSInteger emojiLocation = range.location - 8;
    NSInteger emojiLength = 8;
    NSRange emojiRange = NSMakeRange(emojiLocation, emojiLength);
    
    if([deleteString isEqualToString:@"]"]) {
        
        if(emojiLocation >= 0) {
            
            NSString *pattern = @"^\\[em2_[0-9]{2}\\]$";
            NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
            NSArray *result = [expression matchesInString:textField.text options:NSMatchingReportCompletion range:emojiRange];
            
            if(result.count > 0) {
                
                isEmoji = true;
                
            }
        }
    }
    
    if(isEmoji) {
        
        NSMutableString *string = textField.text.mutableCopy;
        [string replaceCharactersInRange:emojiRange withString:@""];
        textField.text = string;
    }else {
        
        NSMutableString *string = textField.text.mutableCopy;
        [string replaceCharactersInRange:deleteRange withString:@""];
        textField.text = string;
    }
}

#pragma mark - UIKeyboardWillShowNotification

- (void)keyboadWillShow:(NSNotification *)noti {
    
}

- (void)keyboadWillHide:(NSNotification *)noti {
    
    self.textView.inputView = nil;
    self.isOpenEmojiKeyboard = false;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0) {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([string isEqualToString:@""]) { // 判断退格
        
        if(textField.selectedRange.length == 0){
            // 判断是否是emoji 删除emoji
            if([string isEqualToString:@""]) { // 判断退格
                
                if(range.length == 1) {
                    
                    // delete emoji
                    
                    NSString *deleteString = [textField.text substringWithRange:range];
                    if([deleteString isEqualToString:@"]"]) {
                        
                        // 是否是合法的图标
                        
                        NSInteger location = range.location - 7;
                        NSInteger length = 8;
                        
                        
                        if(location >= 0) {
                            
                            NSRange newRange = NSMakeRange(location, length);
                            NSString *pattern = @"^\\[em2_[0-9]{2}\\]$";
                            NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
                            NSArray *result = [expression matchesInString:textField.text options:NSMatchingReportCompletion range:newRange];
                            if(result.count > 0) {
                                NSMutableString *string = textField.text.mutableCopy;
                                [string replaceCharactersInRange:newRange withString:@""];
                                textField.text = string;
                                return false;
                            }
                        }
                    }
                }
            }
        }
        return true;
    }
    
    if([string isEqualToString:@"\n"]) { // 判断回车
        
        [self sendMessage];
        return true;
    }
    
    // 设置textfield输入最大值
    if(textField.text.length > K_BXG_CONSTRUE_LIVE_TEXTFIELD_MAX_COUNT) {
        textField.text = [textField.text substringToIndex:K_BXG_CONSTRUE_LIVE_TEXTFIELD_MAX_COUNT];
        return false;
    }
    
    return true;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendMessage];
    return true;
}
@end
