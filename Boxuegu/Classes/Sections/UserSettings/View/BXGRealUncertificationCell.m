//
//  BXGRealUncertificationCell.m
//  Boxuegu
//
//  Created by apple on 2018/1/16.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGRealUncertificationCell.h"

@implementation BXGRealUncertificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self installUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)installUI {
    [_certifyHeaderImageView setImage:[UIImage imageNamed:@"个人设置-未认证"]];
    [_certifyHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.centerX.offset(0);
    }];
    [_certifyHeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_certifyHeaderImageView.mas_bottom).offset(22);
        make.centerX.offset(0);
    }];
    
    [_knowsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_certifyHeaderLabel.mas_bottom).offset(81);
        make.left.offset(15);
    }];
    [_knowsContentTxtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_knowsTitleLabel.mas_bottom).offset(0);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.equalTo(@(_knowsContentTxtView.contentSize.height));
        make.bottom.offset(-10);//没有这一句, 布局就会不对, 有一种约束上下必须闭合的特点
    }];
    _knowsContentTxtView.scrollEnabled = NO;
    _knowsContentTxtView.editable = NO;
    _knowsContentTxtView.selectable = NO;

    //配置字体+颜色属性
    [_certifyHeaderLabel setFont:[UIFont bxg_fontSemiboldWithSize:18]];
    [_certifyHeaderLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    //认证须知
    [_knowsTitleLabel setFont:[UIFont bxg_fontRegularWithSize:16]];
    [_knowsTitleLabel setTextColor:[UIColor colorWithHex:0x333333]];
    [_knowsContentTxtView setFont:[UIFont bxg_fontRegularWithSize:13]];
    [_knowsContentTxtView setTextColor:[UIColor colorWithHex:0x666666]];
}

@end
