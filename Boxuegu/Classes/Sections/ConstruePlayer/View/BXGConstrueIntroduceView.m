//
//  BXGConstrueIntroduceView.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/12.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGConstrueIntroduceView.h"
#import "BXGConstrueIntroduceModel.h"

@interface BXGConstrueIntroduceView()


// UI
@property (nonatomic, strong) UIView *titleTagView;
@property (nonatomic, strong) UILabel *introduceTagLabel;
@property (nonatomic, strong) UILabel *courseNameLabel;

@property (nonatomic, strong) UILabel *subjectNameTagLabel;
@property (nonatomic, strong) UILabel *subjectNameContentLabel;

@property (nonatomic, strong) UILabel *construeContentLabel;
@property (nonatomic, strong) UILabel *construeTagLabel;

@property (nonatomic, strong) UILabel *teacherContentLabel;
@property (nonatomic, strong) UILabel *teacherTagLabel;

@property (nonatomic, strong) UILabel *construeDurationLabel;
@property (nonatomic, strong) UILabel *construeDurationTagLabel;

@property (nonatomic, strong) UILabel *construeTimeLabel;
@property (nonatomic, strong) UILabel *construeTimeTagLabel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation BXGConstrueIntroduceView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        [self installUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)dealloc {
    
}


#pragma make - interface

- (void)setModel:(BXGConstrueIntroduceModel *)model {
    _model = model;
    if(model) {
        self.subjectNameContentLabel.text = model.subjectName;
        self.construeContentLabel.text = model.desc;
        self.teacherContentLabel.text = model.teacher;
        
        self.construeDurationLabel.text = [NSString stringWithFormat:@"%zd分钟",model.duration.integerValue];
        self.construeTimeLabel.text = [NSString stringWithFormat:@"%@\n%@",model.startTime,model.endTime];
        
    }else {
        // 添加一个蒙版
        self.subjectNameContentLabel.text = @"";
        self.construeContentLabel.text = @"";
        self.teacherContentLabel.text = @"";
        self.construeDurationLabel.text = @"";
        self.construeTimeLabel.text = @"";
    }
}

#pragma mark - getter setter

- (UIScrollView *)scrollView {
    
    if(_scrollView == nil) {
        
        _scrollView = [UIScrollView new];
    }
    return _scrollView;
}

- (UIView *)contentView {
    
    if(_contentView == nil) {
        
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UIView *)titleTagView {
    
    if(_titleTagView == nil) {
        
        _titleTagView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2, 15)];
        _titleTagView.backgroundColor = [UIColor themeColor];
        _titleTagView.layer.cornerRadius = 1;
    }
    return _titleTagView;
}

- (UILabel *)introduceTagLabel {
    
    if(_introduceTagLabel == nil) {
        
        _introduceTagLabel = [UILabel new];
        _introduceTagLabel.text = @"课程简介";
        _introduceTagLabel.font = [UIFont bxg_fontRegularWithSize:16];
        _introduceTagLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    return _introduceTagLabel;
}

- (UILabel *)courseNameLabel {
    
    if(_courseNameLabel == nil) {
        
        _courseNameLabel = [UILabel new];
        _courseNameLabel.font = [UIFont bxg_fontRegularWithSize:16];
        _courseNameLabel.textColor = [UIColor colorWithHex:0x333333];
        _courseNameLabel.text = @"JavaEE在线就业班";
    }
    return _courseNameLabel;
}

- (UILabel *)subjectNameTagLabel {
    
    if(_subjectNameTagLabel == nil) {
        
        _subjectNameTagLabel = [UILabel new];
        _subjectNameTagLabel.font = [UIFont bxg_fontRegularWithSize:16];
        _subjectNameTagLabel.text = @"直播学科:";
        _subjectNameTagLabel.textColor = [UIColor colorWithHex:666666];
        _subjectNameTagLabel.numberOfLines = 0;
    }
    return _subjectNameTagLabel;
}

- (UILabel *)subjectNameContentLabel {
    
    if(_subjectNameContentLabel == nil) {
        
        _subjectNameContentLabel = [UILabel new];
        _subjectNameContentLabel.font = [UIFont bxg_fontRegularWithSize:16];
        _subjectNameContentLabel.textColor = [UIColor colorWithHex:666666];
        _subjectNameContentLabel.numberOfLines = 0;
        _subjectNameContentLabel.text = @" ";
    }
    return _subjectNameContentLabel;

}

- (UILabel *)construeContentLabel {
    
    if(_construeContentLabel == nil) {
        
        _construeContentLabel = [UILabel new];
        _construeContentLabel.font = [UIFont bxg_fontRegularWithSize:16];
        _construeContentLabel.textColor = [UIColor colorWithHex:666666];
        _construeContentLabel.numberOfLines = 0;
        _construeContentLabel.text = @"12321312321123123113123123131232131232112312311312312313";
    }
    return _construeContentLabel;
}

- (UILabel *)construeTagLabel {
    
    if(_construeTagLabel == nil) {
        
        _construeTagLabel = [UILabel new];
        _construeTagLabel.font = [UIFont bxg_fontRegularWithSize:16];
        _construeTagLabel.textColor = [UIColor colorWithHex:666666];
        _construeTagLabel.text = @"直播内容:";
        _construeTagLabel.numberOfLines = 0;
    }
    return _construeTagLabel;
}

- (UILabel *)construeDurationLabel {
    
    if(_construeDurationLabel == nil) {
        
        _construeDurationLabel = [UILabel new];
        _construeDurationLabel.font = [UIFont bxg_fontRegularWithSize:16];
        _construeDurationLabel.textColor = [UIColor colorWithHex:666666];
        _construeDurationLabel.numberOfLines = 0;
        _construeDurationLabel.text = @"1232131232112312311312312313";
    }
    return _construeDurationLabel;
}

- (UILabel *)construeDurationTagLabel {
    
    if(_construeDurationTagLabel == nil) {
        
        _construeDurationTagLabel = [UILabel new];
        _construeDurationTagLabel.font = [UIFont bxg_fontRegularWithSize:16];
        _construeDurationTagLabel.textColor = [UIColor colorWithHex:666666];
        _construeDurationTagLabel.text = @"直播时长:";
        _construeDurationTagLabel.numberOfLines = 0;
    }
    return _construeDurationTagLabel;
}

- (UILabel *)construeTimeLabel {
    
    if(_construeTimeLabel == nil) {
        
        _construeTimeLabel = [UILabel new];
        _construeTimeLabel.font = [UIFont bxg_fontRegularWithSize:16];
        _construeTimeLabel.textColor = [UIColor colorWithHex:666666];
        _construeTimeLabel.numberOfLines = 0;
        _construeTimeLabel.text = @"123213123211231231131231231312321312321123123113123123131232131232112312311312312313123213123211231231131231231312321312321123123113123123131232131232112312311312312313";
    }
    return _construeTimeLabel;
}

- (UILabel *)construeTimeTagLabel {
    
    if(_construeTimeTagLabel == nil) {
        
        _construeTimeTagLabel = [UILabel new];
        _construeTimeTagLabel.font = [UIFont bxg_fontRegularWithSize:16];
        _construeTimeTagLabel.textColor = [UIColor colorWithHex:666666];
        _construeTimeTagLabel.text = @"直播时间:";
        _construeTimeTagLabel.numberOfLines = 0;
    }
    return _construeTimeTagLabel;
}

- (UILabel *)teacherContentLabel {
    
    if(_teacherContentLabel == nil) {
        
        _teacherContentLabel = [UILabel new];
        _teacherContentLabel.font = [UIFont bxg_fontRegularWithSize:16];
        _teacherContentLabel.textColor = [UIColor colorWithHex:666666];
        _teacherContentLabel.numberOfLines = 0;
        _teacherContentLabel.text = @"123213123211231231131231231312321312321123123113123123131232131232112312311312312313123213123211231231131231231312321312321123123113123123131232131232112312311312312313123213123211231231131231231312321312321123123113123123131232131232112312311312312313123213123211231231131231231312321312321123123113123123131232131232112312311312312313";
    }
    return _teacherContentLabel;
}

- (UILabel *)teacherTagLabel {
    
    if(_teacherTagLabel == nil) {
        
        _teacherTagLabel = [UILabel new];
        _teacherTagLabel.font = [UIFont bxg_fontRegularWithSize:16];
        _teacherTagLabel.textColor = [UIColor colorWithHex:666666];
        _teacherTagLabel.text = @"直播导师:";
        _teacherTagLabel.numberOfLines = 0;
        
    }
    return _teacherTagLabel;
}

#pragma mark - ui


#pragma mark -

- (void)installUI {
    
    // addsubview
    UIScrollView *scrollView = self.scrollView;
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
    
    UIView *contentView = self.contentView;
    [scrollView addSubview:contentView];
    
    UIView *titleTagView = self.titleTagView;
    [contentView addSubview:titleTagView];
    
    UIView *introduceTagLabel = self.introduceTagLabel;
    [contentView addSubview:introduceTagLabel];
    
    UIView *courseNameLabel = self.courseNameLabel;
    [contentView addSubview:courseNameLabel];
    
    UIView *subjectNameContentLabel = self.subjectNameContentLabel;
    [contentView addSubview:subjectNameContentLabel];
    
    UIView *subjectNameTagLabel = self.subjectNameTagLabel;
    [contentView addSubview:subjectNameTagLabel];
    [subjectNameTagLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [subjectNameTagLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    UIView *construeTagLabel = self.construeTagLabel;
    [contentView addSubview:construeTagLabel];
    
    UIView *construeContentLabel = self.construeContentLabel;
    [contentView addSubview:construeContentLabel];
    [construeContentLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    UILabel *teacherTagLabel = self.teacherTagLabel;
    [contentView addSubview:teacherTagLabel];
    
    UILabel *teacherContentLabel = self.teacherContentLabel;
    [contentView addSubview:teacherContentLabel];
    [teacherContentLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    UILabel *construeDurationTagLabel = self.construeDurationTagLabel;
    [contentView addSubview:construeDurationTagLabel];
    
    UILabel *construeDurationLabel = self.construeDurationLabel;
    [contentView addSubview:construeDurationLabel];
    [construeDurationLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    
    UILabel *construeTimeTagLabel = self.construeTimeTagLabel;
    [contentView addSubview:construeTimeTagLabel];
    
    UILabel *construeTimeLabel = self.construeTimeLabel;
    [contentView addSubview:construeTimeLabel];
    [construeTimeLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    
    // layout
    
#define kContentAndTagXOffset 10
    
    [titleTagView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [subjectNameTagLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [introduceTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.equalTo(titleTagView.mas_right).offset(5);
        make.right.offset(-15);
        
    }];
    
    [titleTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(introduceTagLabel);
        make.width.offset(2);
        make.height.offset(15);
        
    }];
    
    [courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(introduceTagLabel.mas_bottom).offset(15);
        make.left.equalTo(titleTagView);
        make.right.offset(-15);

    }];
    
    // subjectName
    
    [subjectNameContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(courseNameLabel.mas_bottom).offset(10);
        make.right.offset(-15);
        make.left.equalTo(subjectNameTagLabel.mas_right).offset(kContentAndTagXOffset);
        make.height.greaterThanOrEqualTo(subjectNameTagLabel);
    }];
    [subjectNameTagLabel sizeToFit];
    [subjectNameTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleTagView);
        make.top.equalTo(subjectNameContentLabel);
        make.width.offset(subjectNameTagLabel.bounds.size.width);
    }];
    

    // construeContent
    [construeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subjectNameContentLabel.mas_bottom).offset(10);
        
        make.right.offset(-15);
        make.left.equalTo(subjectNameTagLabel.mas_right).offset(kContentAndTagXOffset);
        make.height.greaterThanOrEqualTo(construeTagLabel);
    }];
    
    [construeTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleTagView);
        make.top.equalTo(construeContentLabel);
    }];
    
    [construeTagLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    // teacher
    
    
    [teacherTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleTagView);
        make.top.equalTo(teacherContentLabel);
    }];
    
    [teacherContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(construeContentLabel.mas_bottom).offset(10);
        make.left.equalTo(subjectNameTagLabel.mas_right).offset(kContentAndTagXOffset);
        make.right.offset(-15);
        make.height.greaterThanOrEqualTo(teacherTagLabel);
    }];
    
    [teacherTagLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    // durantion
    
    
    [construeDurationTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleTagView);
        make.top.equalTo(construeDurationLabel);
    }];
    
    [construeDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(teacherContentLabel.mas_bottom).offset(10);
        make.left.equalTo(subjectNameTagLabel.mas_right).offset(kContentAndTagXOffset);
        make.right.offset(-15);
        make.height.greaterThanOrEqualTo(construeDurationTagLabel);
    }];
    
    [construeDurationTagLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    // time
    
    
    
    [construeTimeTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleTagView);
        make.top.equalTo(construeTimeLabel);
    }];
    
    [construeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(construeDurationLabel.mas_bottom).offset(10);
        make.left.equalTo(subjectNameTagLabel.mas_right).offset(kContentAndTagXOffset);
        make.right.offset(-15);
        make.height.greaterThanOrEqualTo(construeTimeTagLabel);
        make.bottom.offset(-15);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.width.equalTo(scrollView);
        make.bottom.offset(0);
    }];
    
    [construeTimeTagLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}
@end
