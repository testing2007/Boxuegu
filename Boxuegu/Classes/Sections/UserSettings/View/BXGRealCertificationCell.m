//
//  BXGRealCertificationCell.m
//  Boxuegu
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGRealCertificationCell.h"

@implementation BXGRealCertificationCell

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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self installUI];
    }
    return self;
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
    [_certifyHeaderSuccessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_certifyHeaderImageView.mas_bottom).offset(11);
        make.centerX.offset(0);
    }];
    
    [_personInfoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_certifyHeaderView.mas_bottom).offset(15);
        make.left.offset(15);
    }];
    
    [_personBaseInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(_personInfoTitleLabel.mas_bottom).offset(10);
        make.height.equalTo(@195);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(15);
        make.height.equalTo(@15);
    }];
    [_vNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(5);
        make.top.equalTo(_nameLabel); //make.top.equalTo(_nameLabel);行否
        make.height.equalTo(@15);
    }];
    [_sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(_nameLabel.mas_bottom).offset(15);
        make.height.equalTo(@15);
    }];
    [_vSexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_sexLabel.mas_right).offset(5);
        make.top.equalTo(_sexLabel.mas_top);
        make.height.equalTo(@15);
    }];
    [_cellPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(_sexLabel.mas_bottom).offset(15);
        make.height.equalTo(@15);
        make.width.equalTo(@64);
    }];
    [_vCellphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cellPhoneLabel.mas_right).offset(5);
        make.top.equalTo(_cellPhoneLabel.mas_top);
        make.height.equalTo(@15);
    }];
    [_certificationIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(_cellPhoneLabel.mas_bottom).offset(15);
        make.height.equalTo(@15);
    }];
    [_vCertificationIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_certificationIdLabel.mas_right).offset(5);
        make.top.equalTo(_certificationIdLabel.mas_top);
        make.height.equalTo(@15);
    }];
    [_EMailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(_certificationIdLabel.mas_bottom).offset(15);
        make.height.equalTo(@15);
    }];
    [_vEMailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_EMailLabel.mas_right).offset(5);
        make.top.equalTo(_EMailLabel.mas_top);
        make.height.equalTo(@15);
    }];
    [_QQLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(_EMailLabel.mas_bottom).offset(15);
        make.height.equalTo(@15);
    }];
    [_vQQLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_QQLabel.mas_right).offset(5);
        make.top.equalTo(_QQLabel.mas_top);
        make.height.equalTo(@15);
    }];
    //*
    [_personEducationInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(_personBaseInfoView.mas_bottom).offset(10);
        make.height.equalTo(@105);
    }];
    [_academicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(15);
        make.height.equalTo(@15);
    }];
    [_vAcademicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_academicLabel.mas_right).offset(5);
        make.top.equalTo(_academicLabel.mas_top).offset(0);
        make.height.equalTo(@15);
    }];
    [_graduateSchool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_academicLabel.mas_bottom).offset(15);
        make.left.offset(15);
        make.height.equalTo(@15);
    }];
    [_vGraduateSchool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_graduateSchool.mas_right).offset(5);
        make.top.equalTo(_graduateSchool.mas_top);
        make.height.equalTo(@15);
    }];
    [_specialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_graduateSchool.mas_bottom).offset(15);
        make.left.offset(15);
        make.height.equalTo(@15);
    }];
    [_vSpecialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_specialLabel.mas_right).offset(5);
        make.top.equalTo(_specialLabel.mas_top);
        make.height.equalTo(@15);
    }];
    
    [_knowsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_personEducationInfoView.mas_bottom).offset(25);
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
    [_certifyHeaderSuccessLabel setFont:[UIFont bxg_fontSemiboldWithSize:18]];
    [_certifyHeaderSuccessLabel setTextColor:[UIColor colorWithHex:0x666666]];

    [_personInfoTitleLabel setFont:[UIFont bxg_fontRegularWithSize:16]];
    [_personInfoTitleLabel setTextColor:[UIColor colorWithHex:0x666666]];

    [_nameLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_nameLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [_vNameLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_vNameLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    [_sexLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_sexLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [_vSexLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_vSexLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    [_cellPhoneLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_cellPhoneLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [_vCellphoneLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_vCellphoneLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    [_certificationIdLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_certificationIdLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [_vCertificationIdLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_vCertificationIdLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    [_EMailLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_EMailLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [_vEMailLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_vEMailLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    [_QQLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_QQLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [_vQQLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_vQQLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    //教育类型
    [_academicLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_academicLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [_vAcademicLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_vAcademicLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    [_graduateSchool setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_graduateSchool setTextColor:[UIColor colorWithHex:0x666666]];
    [_vGraduateSchool setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_vGraduateSchool setTextColor:[UIColor colorWithHex:0x666666]];
    
    [_specialLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_specialLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [_vSpecialLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [_vSpecialLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    //认证须知
    [_knowsTitleLabel setFont:[UIFont bxg_fontRegularWithSize:16]];
    [_knowsTitleLabel setTextColor:[UIColor colorWithHex:0x333333]];
    [_knowsContentTxtView setFont:[UIFont bxg_fontRegularWithSize:13]];
    [_knowsContentTxtView setTextColor:[UIColor colorWithHex:0x666666]];
}

-(void)setRealName:(NSString*)realName
            andSex:(NSString*)sex
      andCellphone:(NSString*)cellphone
andCertificationId:(NSString*)certificationId
          andEMail:(NSString*)email
             andQQ:(NSString*)QQ
       andAcademic:(NSString*)academic
 andGraduateSchool:(NSString*)graduateSchool
        andSpecial:(NSString*)special {
    
    self.vNameLabel.text = realName;
    self.vSexLabel.text = sex;
    self.vCellphoneLabel.text = cellphone;
    self.vCertificationIdLabel.text = certificationId;
    self.vEMailLabel.text = email;
    self.vQQLabel.text = QQ;
    self.vAcademicLabel.text = academic;
    self.vGraduateSchool.text = graduateSchool;
    self.vSpecialLabel.text = special;
    
}

@end

