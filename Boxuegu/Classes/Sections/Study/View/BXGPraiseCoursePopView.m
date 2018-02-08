//
//  BXGPraiseCoursePopView.m
//  demo-PopView
//
//  Created by RenyingWu on 2017/7/20.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//



 #import "BXGPraiseCoursePopView.h"
#import "RWStarView.h"
#import "RWTextView.h"
#import "RWCommonFunction.h"

@interface BXGPraiseCoursePopView()
@property (nonatomic, weak) RWTextView *textView;
@property (nonatomic, weak) RWStarView *starView;
@end

@implementation BXGPraiseCoursePopView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        [self installUI];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
- (void)keyboardShow:(NSNotification *)noti {

//    // NSNumber *rect = noti.userInfo[@"UIKeyboardFrameBeginUserInfoKey"];
//    NSNumber *rect = noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
//    CGFloat keyboardHeight = rect.CGRectValue.size.height;
//    CGFloat keyboardY= rect.CGRectValue.origin.y;
////    if(noti.userInfo) {
////    
////        NSLog(noti.userInfo);
////    }
//    
//    // CGFloat ty;
////    CGFloat ty = [UIScreen mainScreen].bounds.size.height - (self.frame.size.height + self.frame.origin.y) - keyboardHeight - 44;
//    CGFloat ty = - ((self.frame.size.height + self.frame.origin.y) - keyboardY);
//
//    if(ty < 0) {
//    
//        // self.layer.transform = CATransform3DMakeTranslation(0, ty - 20, 0);
//        self.layer.transform = CATransform3DIdentity;
//        self.layer.transform = CATransform3DMakeTranslation(0, -104, 0);
//    }
    self.layer.transform = CATransform3DMakeTranslation(0, -104, 0);
}

- (void)keyboardHide:(NSNotification *)noti {
    // self.transform
    self.layer.transform = CATransform3DIdentity;
    
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)installUI {

    UIView *contentView = [UIView new];
    [self addSubview:contentView];
    contentView.backgroundColor = [UIColor whiteColor];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.backgroundColor = [UIColor clearColor];
    //    // w 640  h 644
    //
    //    // 提交 高度 100
    //
    //    // 文本框 260
    //
    //    //
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [contentView addSubview:commitBtn];
    
    [commitBtn addTarget:self action:@selector(clickCommitBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.equalTo(commitBtn.superview).multipliedBy(0.155);
    }];
    //
    commitBtn.titleLabel.font = [UIFont bxg_fontRegularWithSize:RWAutoFontSize(18)];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    commitBtn.tintColor = [UIColor whiteColor];
    commitBtn.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    

    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"评价该课程";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titleLabel];
    // titleLabel.adjustsFontSizeToFitWidth = true;
    //titleLabel.minimumScaleFactor = 0.5;
    
    // 5s
    
    // 6
    // titleLabel.font = [UIFont bxg_fontRegularWithSize:18];
    // plus
    titleLabel.font = [UIFont bxg_fontRegularWithSize:RWAutoFontSize(18)];
    
    
    titleLabel.textColor = [UIColor colorWithHex:0x333333];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        //make.width.equalTo(titleLabel.superview).multipliedBy(0.33);
        make.height.equalTo(titleLabel.superview).multipliedBy(0.056);
        // make.centerX.offset(0);
        make.top.offset(20);
        make.left.right.offset(0);
    }];
    
    UILabel *praiseStatusLabel = [UILabel new];
    [contentView addSubview:praiseStatusLabel];
    praiseStatusLabel.text = @"极佳";
    praiseStatusLabel.textColor = [UIColor colorWithHex:0x38ADFF];
    praiseStatusLabel.font = [UIFont bxg_fontMediumWithSize:RWAutoFontSize(18)];
    
    praiseStatusLabel.textAlignment = NSTextAlignmentCenter;
    [praiseStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
    }];
    
    
    RWStarView *starView = [RWStarView new];
    starView.stars = 5;
    starView.changeStarEnable = true;
    self.starView = starView;
    [contentView addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(praiseStatusLabel.mas_bottom).offset(15);
        make.centerX.offset(0);
        make.width.equalTo(starView.superview).multipliedBy(0.546);
        make.height.equalTo(starView.mas_width).multipliedBy(0.15);
    }];
    
    starView.starDidChageBlock = ^(NSInteger stars) {
        
        switch (stars) {
            case 1:
            {
                praiseStatusLabel.text = @"较差";
            }break;
            case 2:
            {
                praiseStatusLabel.text = @"一般";
            }break;
            case 3:
            {
                praiseStatusLabel.text = @"良好";
            }break;
            case 4:
            {
                praiseStatusLabel.text = @"推荐";
            }break;
            case 5:
            {
                praiseStatusLabel.text = @"极佳";
            }break;
                
            default:
            {
                praiseStatusLabel.text = @"未知";
            }break;
        }
        
        
//        1颗星：较差
//        2颗星：一般
//        3颗星：良好
//        4颗星：推荐
//        5颗星：极佳
    };
    
    UIView *spView = [UIView new];
    spView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [contentView addSubview:spView];
    
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(starView.mas_bottom).offset(15);
    }];
    
    RWTextView *textView = [RWTextView new];
    textView.countNumber = 200;
    textView.placeHolder = @"评论，200字以内！（真实的课程体验反馈，帮助我们为您提供优质课程！）";
    self.textView = textView;
    [contentView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spView.mas_bottom).offset(10);
        make.bottom.equalTo(commitBtn.mas_top).offset(-10);
        make.left.offset(0).offset(10);
        make.right.offset(0).offset(-10);
        // make.height.equalTo(commitBtn.superview).multipliedBy(0.155);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentsView:)];
    [contentView addGestureRecognizer:tap];
    contentView.layer.cornerRadius = 11;
    contentView.layer.masksToBounds = true;
    
    UIButton *closeBtn = [UIButton buttonWithType:0];
    [closeBtn setImage:[UIImage imageNamed:@"课程评价-关闭"] forState:UIControlStateNormal];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_right).offset(-5);
        make.centerY.equalTo(contentView.mas_top).offset(5);
    }];
    
    [closeBtn addTarget:self action:@selector(clickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapContentsView:(UITapGestureRecognizer *)tap;{

    [self.textView endEditing:true];
}

- (void)clickCloseBtn:(UIButton *)sender {

    if(self.closeBlock){
    
        self.closeBlock();
    }
}

- (void)clickCommitBtn:(UIButton *)sender {
    
    NSString *text = self.textView.text;
    if(text){
        
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    if([text isEqualToString:@""]) {
        
        [[BXGHUDTool share] showHUDWithString:@"内容不能为空"];
        return;
    }
    
    if([self.textView hasEmoji]) {
        
        [[BXGHUDTool share] showHUDWithString:kBXGToastNoSupportEmoji];
        return;
    }
    
    if(self.commitBlock){
        
        self.commitBlock(self.starView.stars ,self.textView.text);
    }
}


@end
