//
//  RWTextView.m
//  RW
//
//  Created by RenyingWu on 2017/7/20.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "RWTextView.h"
#import "RWCommonFunction.h"

@interface RWTextView() <UITextViewDelegate>


@end

@implementation RWTextView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        [self installUI];
    }
    return self;
}

#pragma mark - Getter Setter

- (void)setCountNumber:(NSInteger)countNumber {
    
    _countNumber = countNumber;
    
    self.counterLabel.text = @(self.countNumber).description;
    // self.counterLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.countNumber).description,@(self.countNumber).description];
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    
    _placeHolder = placeHolder;
    self.placeHolderLabel.text = placeHolder;
}

- (void)setIsAutoSizeFit:(BOOL)isAutoSizeFit {

    _isAutoSizeFit = isAutoSizeFit;
    if(isAutoSizeFit){
    
        self.scrollEnabled = false;
    }else {
    
        self.scrollEnabled = true;
    }
}

- (UILabel *)counterLabel {
    
    if(!_counterLabel) {
        
        _counterLabel = [UILabel new];
        _counterLabel.text = @(self.countNumber).description;
        _counterLabel.font = [UIFont bxg_fontRegularWithSize:RWAutoFontSize(15)];
        _counterLabel.textColor = [UIColor colorWithHex:0x999999];
    }
    return _counterLabel;
}

#pragma mark - Install UI

- (void)installUI {
    
    // setting
    self.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    self.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    self.layer.cornerRadius = 4;
    self.font = [UIFont bxg_fontRegularWithSize:RWAutoFontSize(16)];
    self.textColor = [UIColor colorWithHex:0x333333];

    // install subviews components view
    UIView *componentsView = [UIView new];
    [self addSubview:componentsView];
    componentsView.backgroundColor = [UIColor clearColor];
    componentsView.userInteractionEnabled = false;
    [componentsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.top.right.offset(0);
        make.width.equalTo(self);
        make.height.equalTo(self);
    }];
    
    // install subviews place holder label
    UILabel *placeHolderLabel = [UILabel new];
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.font = [UIFont bxg_fontRegularWithSize:RWAutoFontSize(16)];
    placeHolderLabel.text = @"";
    placeHolderLabel.textColor = [UIColor colorWithHex:0xbbbbbb];
    [self addSubview:placeHolderLabel];
    self.placeHolderLabel = placeHolderLabel;
    self.delegate = self;
    [placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.offset(9);
         make.left.offset(15);
         make.width.equalTo(self).offset(-20);
    }];
}

- (void)installCounterLabel {
    
    if(self.superview && !self.counterLabel.window) {
        
        [self.superview addSubview:self.counterLabel];
        [self.counterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
             make.right.equalTo(self).offset(-5);
             make.bottom.equalTo(self).offset(-5);
         }];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self installCounterLabel];
}

#pragma mark - TextView Delegate

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    ;
    
}

- (void)textViewDidChange:(UITextView *)textView {

    NSString *text = textView.text;
    
    if(text.length>self.countNumber){
        
        textView.text= [text substringToIndex:self.countNumber];
        [[BXGHUDTool share] showHUDWithString:@"您输入的字符已超过了限制!"];
        if(self.overMaxCountBlock) {
        
            
            self.overMaxCountBlock();
        }
    }
    self.counterLabel.text = @(self.countNumber - (NSInteger)(textView.text.length)).description;
    // self.counterLabel.text =  [NSString stringWithFormat:@"%@/%zd",@(self.countNumber - (NSInteger)(textView.text.length)).description,self.countNumber];
    if(textView.text.length > 0){
    
        self.placeHolderLabel.hidden = true;
    }else {
    
        self.placeHolderLabel.hidden = false;
    }
    if(self.isAutoSizeFit) {
    
        //获得textView的初始尺寸
        CGFloat width = CGRectGetWidth(textView.frame);
        CGFloat height = CGRectGetHeight(textView.frame);
        
        CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
        CGRect newFrame = textView.frame;
        
        if(self.minimumHeight >= 0){
            
            if(newSize.height <= self.minimumHeight) {
                
                newSize = CGSizeMake(width, self.minimumHeight);
            }
        }
        
        // newFrame.size = CGSizeMake(fmax(width, newSize.width), fmax(height, newSize.height));
        newFrame.size = CGSizeMake(width, newSize.height);
        
        textView.frame= newFrame;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(newSize.height);
        }];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    //不支持系统表情的输入
//    if([[self.textInputMode primaryLanguage] isEqualToString:@"emoji"]) {
//    
//        return NO;
//    }
    if ([[[UITextInputMode currentInputMode ]primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    // 监听退格键
    if ([text isEqualToString:@""] ) {
        
        if(textView.text.length == 0) {
            
            self.placeHolderLabel.hidden = false;
            
        }else if(range.location == 0 && range.length == 1 && textView.text.length == 1) {
            
            self.placeHolderLabel.hidden = false;
        }else {
        
            self.placeHolderLabel.hidden = true;
        }
        return true;
    }

    // 监听回车
    if([text isEqualToString:@"\n"]) {
        
        if(textView.text.length == 0) {
            
            self.placeHolderLabel.hidden = false;
        }
        return true;
        // return false;
    }
    
    // 监听是否有文字
    if([textView.text stringByAppendingString:text].length > 0){
        
        self.placeHolderLabel.hidden = true;
    }else {
    
        self.placeHolderLabel.hidden = false;
    }
    
    return true;
}
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
- (BOOL)hasEmoji {
    return [self stringContainsEmoji:self.text];
}
@end
