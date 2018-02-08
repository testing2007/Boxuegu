//
//  BXGUserCertificationCell.h
//  Boxuegu
//
//  Created by apple on 2018/1/16.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGUserCertificationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *certifyHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *certifyHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *certifyHeaderLabel;

@property (weak, nonatomic) IBOutlet UILabel *knowsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *personInfoTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *personEducationInfoView;
@property (weak, nonatomic) IBOutlet UILabel *academicLabel;
@property (weak, nonatomic) IBOutlet UILabel *vAcademicLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialLabel;
@property (weak, nonatomic) IBOutlet UILabel *vSpecialLabel;

@property (weak, nonatomic) IBOutlet UIImageView *encourageImageView;

-(void)setSubjectName:(NSString*)subjectName
         andClassName:(NSString*)className;

@end
