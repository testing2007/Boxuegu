//
//  BXGRealCertificationCell.h
//  Boxuegu
//
//  Created by apple on 2018/1/16.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGUserBaseInfoModel.h"

@interface BXGRealCertificationCell : UITableViewCell

 @property (weak, nonatomic) IBOutlet UIView *certifyHeaderView;
 @property (weak, nonatomic) IBOutlet UIImageView *certifyHeaderImageView;
 @property (weak, nonatomic) IBOutlet UILabel *certifyHeaderSuccessLabel;
 
 @property (weak, nonatomic) IBOutlet UILabel *personInfoTitleLabel;
 @property (weak, nonatomic) IBOutlet UIView *personBaseInfoView;
 @property (weak, nonatomic) IBOutlet UIView *personEducationInfoView;
 
 @property (weak, nonatomic) IBOutlet UILabel *nameLabel;
 @property (weak, nonatomic) IBOutlet UILabel *vNameLabel;
 @property (weak, nonatomic) IBOutlet UILabel *sexLabel;
 @property (weak, nonatomic) IBOutlet UILabel *vSexLabel;
 @property (weak, nonatomic) IBOutlet UILabel *cellPhoneLabel;
 @property (weak, nonatomic) IBOutlet UILabel *vCellphoneLabel;
 @property (weak, nonatomic) IBOutlet UILabel *certificationIdLabel;
 @property (weak, nonatomic) IBOutlet UILabel *vCertificationIdLabel;
 @property (weak, nonatomic) IBOutlet UILabel *EMailLabel;
 @property (weak, nonatomic) IBOutlet UILabel *vEMailLabel;
 @property (weak, nonatomic) IBOutlet UILabel *QQLabel;
 @property (weak, nonatomic) IBOutlet UILabel *vQQLabel;
 
 @property (weak, nonatomic) IBOutlet UILabel *academicLabel;
 @property (weak, nonatomic) IBOutlet UILabel *vAcademicLabel;
 @property (weak, nonatomic) IBOutlet UILabel *graduateSchool;
 @property (weak, nonatomic) IBOutlet UILabel *vGraduateSchool;
 @property (weak, nonatomic) IBOutlet UILabel *specialLabel;
 @property (weak, nonatomic) IBOutlet UILabel *vSpecialLabel;

 @property (weak, nonatomic) IBOutlet UILabel *knowsTitleLabel;
 @property (weak, nonatomic) IBOutlet UITextView *knowsContentTxtView;

-(void)setRealName:(NSString*)realName
            andSex:(NSString*)sex
      andCellphone:(NSString*)cellphone
andCertificationId:(NSString*)certificationId
          andEMail:(NSString*)email
             andQQ:(NSString*)QQ
       andAcademic:(NSString*)academic
 andGraduateSchool:(NSString*)graduateSchool
        andSpecial:(NSString*)special;

@end
