//
//  BXGPlayerHeaderBackBtn.m
//  demo-CCMedia
//
//  Created by HM on 2017/6/8.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "Masonry.h"

// lib

#import "BXGPlayerHeaderBackBtn.h"


@interface  BXGPlayerHeaderBackBtn()

@property (nonatomic, weak) UILabel *btnTitleLabel;
// @property (nonatomic, weak) RWDynamicLabel *btnTitleLabel;

@end


@implementation BXGPlayerHeaderBackBtn

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        [self installUI];
    }
    return self;
}

- (void)setBtnTitle:(NSString *)btnTitle {

    _btnTitle = btnTitle;
    
    if(btnTitle) {
    
        self.btnTitleLabel.text = btnTitle;
    }else {
    
        self.btnTitleLabel.text = @"";
    }
}

- (void)installUI {
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"播放器-返回-白"]];
    UILabel *btnTitleLabel = [UILabel new];
    
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.btnTitleLabel = btnTitleLabel;
    [self addSubview:iconImageView];
    [self addSubview:btnTitleLabel];
    
    self.backgroundColor = [UIColor clearColor];
    btnTitleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    btnTitleLabel.textColor = [UIColor whiteColor];
    btnTitleLabel.text = @"";

    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.centerY.offset(0);
        make.height.width.offset(22);
    }];
    
    [btnTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(5);
        make.centerY.offset(0);
        make.height.equalTo(self);
        make.right.offset(0);
    }];
}

@end
