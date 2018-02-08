//
//  BXGEditTextView.m
//  Boxuegu
//
//  Created by apple on 2018/1/13.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGEditTextView.h"

#define kDefaultLimitSize 400

@interface BXGEditTextView()<UITextViewDelegate>

@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, assign) NSInteger limitCount;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, weak) UILabel *placeholderLabel;
@property (nonatomic, weak) UILabel *countLabel;
@property (nonatomic, copy) FinishBlockType finishBlock;

@end

@implementation BXGEditTextView

- (instancetype)initLimitCount:(NSInteger)limitCount
                    andContent:(NSString*)content
                andPlaceholder:(NSString*)placeholder
                andFinishBlock:(FinishBlockType)finishBlock {
    self = [super init];
    if(self) {
        _limitCount = limitCount<=0 ? 400 : limitCount;
        _placeholder = placeholder;
        _finishBlock = finishBlock;
        
        [self installUI];
        if(![NSString isEmpty:content]) {
            self.textView.text = content;
            self.placeholderLabel.hidden = YES;
        }
        [self.textView becomeFirstResponder];
    }
    return self;
}

- (void)installUI {
    
    UITextView *textView = [UITextView new];
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
//    textView.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    [textView setTextColor:[UIColor colorWithHex:0x333333]];
    [textView setFont:[UIFont bxg_fontRegularWithSize:18]];
    textView.delegate =self;
    textView.returnKeyType = UIReturnKeyDone;
    [self addSubview:textView];
    _textView = textView;

    UILabel *placeholderLabel = [UILabel new];
    [placeholderLabel setTextColor:[UIColor colorWithHex:0xCCCCCC]];
    [placeholderLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    placeholderLabel.text = _placeholder;
    placeholderLabel.textAlignment = NSTextAlignmentLeft;
    [textView addSubview:placeholderLabel];
    _placeholderLabel = placeholderLabel;
    
    UILabel *countLabel = [UILabel new];
    [countLabel setTextColor:[UIColor colorWithHex:0xCCCCCC]];
    [countLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    countLabel.text = [NSString stringWithFormat:@"%ld", _limitCount];
    countLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:countLabel];
    _countLabel = countLabel;
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(10);
    }];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.textView).offset(-10);
            make.bottom.equalTo(self.textView);
            make.height.equalTo(@(10 + 10 + 15));
            make.width.equalTo(@40);
    }];
}

- (void)setContent:(NSString*)content {
    if(!content || content.length==0) {
        _placeholderLabel.hidden = NO;
    } else {
        _placeholderLabel.hidden = YES;
        self.textView.text = content;
    }
}

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        if(_finishBlock) {
            _finishBlock(self.textView.text);
        }
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
//    if([text stringContainsEmoji]) {
//        [[BXGHUDTool share] showHUDWithString:kBXGToastNoSupportEmoji];
//        return NO;
//    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1 && textView.text.length == 1)
    {
        self.placeholderLabel.hidden = NO;
    }
    if (![text isEqualToString:@""] )
    {
        self.placeholderLabel.hidden = YES;
    }else {
        return YES;
    }
    if([self.countLabel.text integerValue] == 0) {
        [[BXGHUDTool share] showHUDWithString:[NSString stringWithFormat:@"请输入2-%ld个字!", _limitCount]];
        return NO;
    }
    
    if((self.textView.text.length + text.length) > _limitCount){
        
        NSMutableString *mString = [NSMutableString new];
        [mString appendString:self.textView.text];
        [mString replaceCharactersInRange:range withString:text];
        
        NSInteger length = mString.length;
        if(length > _limitCount) {
            length = _limitCount;
        }
        NSString *subText = [mString substringWithRange:NSMakeRange(0, length)];
        self.textView.text = subText;
        
        [[BXGHUDTool share] showHUDWithString:[NSString stringWithFormat:@"请输入2-%ld个字!", _limitCount]];
        return NO;
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    self.countLabel.text =  @(_limitCount - textView.text.length).description;
    if([textView.text isEqualToString:@""]) {
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
}

//- (void)textViewDidEndEditing:(UITextView *)textView {
//    if(_finishBlock) {
//        _finishBlock(self.textView.text);
//    }
//}

- (void)finishEdit {
    [self.textView resignFirstResponder];
}

- (NSString*)content {
    return self.textView.text;
}

@end
