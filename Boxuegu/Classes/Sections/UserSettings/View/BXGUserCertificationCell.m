//
//  BXGUserCertificationCell.m
//  Boxuegu
//
//  Created by apple on 2018/1/16.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGUserCertificationCell.h"
#import "UIView+Frame.h"

@implementation BXGUserCertificationCell

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
    [_certifyHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.offset(0);
        make.height.equalTo(@141);
    }];
    [_certifyHeaderImageView setImage:[UIImage imageNamed:@"个人设置-已认证"]];
    [_certifyHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.centerX.offset(0);
    }];
    [_certifyHeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_certifyHeaderImageView.mas_bottom).offset(11);
        make.centerX.offset(0);
    }];
    
    [_personInfoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_certifyHeaderView.mas_bottom).offset(15);
        make.left.offset(15);
    }];

    [_knowsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_certifyHeaderView.mas_bottom).offset(25);
        make.left.offset(15);
    }];

    [_personEducationInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(_knowsTitleLabel.mas_bottom).offset(5);
        make.height.equalTo(@75);
    }];
    
    //配置字体+颜色属性
    [_certifyHeaderLabel setFont:[UIFont bxg_fontSemiboldWithSize:18]];
    [_certifyHeaderLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    //认证须知
    [_knowsTitleLabel setFont:[UIFont bxg_fontRegularWithSize:16]];
    [_knowsTitleLabel setTextColor:[UIColor colorWithHex:0x333333]];
    
    [_academicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(15);
        make.height.equalTo(@15);
    }];
    [_vAcademicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_academicLabel.mas_right).offset(5);
        make.top.equalTo(_academicLabel.mas_top).offset(0);
        make.height.equalTo(@15);
    }];
    [_specialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_academicLabel.mas_bottom).offset(15);
        make.left.offset(15);
        make.height.equalTo(@15);
    }];
    [_vSpecialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_specialLabel.mas_right).offset(5);
        make.top.equalTo(_specialLabel.mas_top);
        make.height.equalTo(@15);
    }];
    
    [_encourageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_personEducationInfoView.mas_bottom).offset(SCREEN_HEIGHT-(_personEducationInfoView.y+_personEducationInfoView.height)-(22+131+K_NAVIGATION_BAR_OFFSET));
        make.left.offset(51);
        make.right.offset(-51);
//        make.height.equalTo(@131);
        make.bottom.offset(-22);
    }];
    
    //配置字体+颜色属性
    [_certifyHeaderLabel setFont:[UIFont bxg_fontSemiboldWithSize:18]];
    [_certifyHeaderLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    [_personInfoTitleLabel setFont:[UIFont bxg_fontRegularWithSize:16]];
    [_personInfoTitleLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    //教育类型
    [_academicLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_academicLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [_vAcademicLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_vAcademicLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    [_specialLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_specialLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [_vSpecialLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_vSpecialLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    //认证须知
    [_encourageImageView setImage:[UIImage imageNamed:@"个人设置-鸡汤"]];
    [_encourageImageView setBackgroundColor:[UIColor colorWithRed:245 green:183 blue:156]];
}

-(void)setSubjectName:(NSString*)subjectName
         andClassName:(NSString*)className {
    
    self.vAcademicLabel.text = subjectName;
    self.vSpecialLabel.text = className;
    
}

@end
