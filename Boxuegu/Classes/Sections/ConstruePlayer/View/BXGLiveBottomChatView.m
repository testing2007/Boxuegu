//
//  MYBottomChatView.m
//  QQKeyboard
//
//  Created by wurenying on 2018/1/9.
//  Copyright © 2018年 Renying Wu. All rights reserved.
//

#import "BXGLiveBottomChatView.h"
#import <Masonry.h>
#import "UIColor+Extension.h"
#import "UITextField+Extension.h"



#define kInputViewFaceViewWidth 55
#define kInputViewSendViewWidth 64

@interface MYBottomChatView() <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textView;
@property (nonatomic, assign) BOOL isOpenEmojiKeyboard;
@property (nonatomic, strong) UIView *emojiView;
@end

@implementation MYBottomChatView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        [self installUI];
    }
    return self;
}

- (void)installUI {
    // 1.表情View
    UIButton *faceView = [UIButton new];
    [self addSubview:faceView];
    
    [faceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
        make.width.offset(kInputViewFaceViewWidth);
    }];
    
    [faceView setImage:[UIImage imageNamed:@"直播键盘-表情"] forState:UIControlStateNormal];
    [faceView addTarget:self action:@selector(openEmojiKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
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
    self.textView = textView;
    
    // 3.Send View
    UIButton *sendView = [UIButton new];
    [self addSubview:sendView];
    sendView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [sendView setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [sendView setTitle:@"发送" forState:UIControlStateNormal];
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
}
#pragma mark - Delegate

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
    }
    
    if([string isEqualToString:@"\n"]) { // 判断回车
        
    }
    
    return true;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return true;
}

#pragma mark - Func

- (void)addEmoji:(UIButton *)sender {
    NSInteger index = sender.tag;
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

#pragma mark - Function

- (void)openEmojiKeyboard {
    
    if(!self.isOpenEmojiKeyboard) {
        self.textView.inputView = nil;
        self.textView.inputView = self.emojiView;
        [self.textView endEditing:true];
        [self.textView becomeFirstResponder];
        self.isOpenEmojiKeyboard = true;
        self.textView.delegate = self;
    }else {
        [self.textView endEditing:true];
        self.isOpenEmojiKeyboard = false;
        self.textView.inputView = nil;
        [self.textView becomeFirstResponder];
        self.textView.delegate = self;
    }
}

- (void)closeEmojiKeyboard {
    self.textView.inputView = nil;
}


- (UIView *)emojiView {
    
    if(_emojiView == nil) {
        _emojiView = [UIView new];
        
        NSInteger count = 21;
        NSInteger colCount = 7;
        NSInteger rowCount = count / colCount + (count % colCount == 0 ? 0 : 1);
        
        CGFloat leftMargin = 2;
        CGFloat rightMargin = leftMargin;
        CGFloat topMargin = leftMargin;
        CGFloat bottomMargin = topMargin;
        
        CGFloat verticalMargin = 10;
        CGFloat horizontalMargin = verticalMargin;
        CGFloat widthMax = ([UIScreen mainScreen].bounds.size.height > [UIScreen mainScreen].bounds.size.width? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height) - leftMargin - rightMargin;
        CGFloat heightMax = widthMax / colCount * 3;
        
        
        _emojiView.frame = CGRectMake(0, 0, 0, heightMax + topMargin + bottomMargin);
        
        for(NSInteger i = 0; i < count; i++) {
            NSInteger row = i / colCount;
            NSInteger col = i % colCount;
            CGFloat width = (widthMax - (colCount - 1) * horizontalMargin) / colCount;
            CGFloat height = (heightMax - (rowCount - 1) * horizontalMargin) / rowCount;
            
            CGFloat x = leftMargin + (width + horizontalMargin) * col;
            CGFloat y = topMargin + (height + verticalMargin) * row;
            
            UIButton *btn = [UIButton new];
            
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
        }
        // live_chat_emoji_01
        
    }
    return _emojiView;
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
@end
