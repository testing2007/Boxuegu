//
//  BXGStudySelectCourseBtn.m
//  Boxuegu
//
//  Created by HM on 2017/4/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudySelectCourseBtn.h"

@interface BXGStudySelectCourseBtn()

@property(nonatomic, strong) UIView *buttomBar;

@end

@implementation BXGStudySelectCourseBtn

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        [self installUI];
    }
    return self;
}

#pragma mark - install UI

/**
 搭建UI主函数
 */
- (void) installUI {
    
    // 文本
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont bxg_fontRegularWithSize:14];
    titleLabel.textColor = [UIColor colorWithHex:0x333333];
    titleLabel.textColor = [UIColor colorWithHex:0x999999];
    self.selectTitleLabel = titleLabel;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    
}


#pragma mark - install SubViews


#pragma mark - Response

/**
 监听按钮被点击
 
 @param selected 是否被点击
 */
-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if(selected) {
        // self.buttomBar.hidden = false;
        // self.buttomBar.backgroundColor = [UIColor colorWithHex:0x38ADFF];
        self.selectTitleLabel.textColor = [UIColor colorWithHex:0x333333];
    }else {
        //self.buttomBar.hidden = true;
        self.selectTitleLabel.textColor = [UIColor colorWithHex:0x999999];
        // self.buttomBar.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    }
    
}

@end
