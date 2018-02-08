//
//  BXGStudyRootProCourseCCell.m
//  Boxuegu
//
//  Created by HM on 2017/6/13.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseHorizentalCCell.h"
#import "RWDeviceInfo.h"
#import "UILabel+Extension.h"
@interface BXGCourseHorizentalCCell()

@property (weak, nonatomic) IBOutlet UIImageView *cellIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellSubTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellThirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellFourthLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subTitleOffet;

@end

@implementation BXGCourseHorizentalCCell


- (void)setCourseDetailViewModel:(BXGCourseDetailViewModel *)courseDetailViewModel {

    _courseDetailViewModel = courseDetailViewModel;
    self.model = courseDetailViewModel.courseModel;
}


-(void)setModel:(BXGCourseModel *)model {

    _model = model;
    
    if(model.course_name){
    
        self.cellTitleLabel.text = model.course_name;
    }else {
    
        self.cellTitleLabel.text = @"";
    }
    
    if(model.smallimg_path){
        
        [self.cellIconImageView sd_setImageWithURL:[NSURL URLWithString:model.smallimg_path] placeholderImage:[UIImage imageNamed:@"默认加载图"]];
    }else {
        
        [self.cellIconImageView setImage:[UIImage imageNamed:@"默认加载图"]];
    }
    
    if(model.teacher_name){
        
        self.cellSubTitleLabel.text = model.teacher_name;
    }else {
        
        self.cellSubTitleLabel.text = @"";
    }
    
    if(model.learnd_count){ // 已学习课时
        
        self.cellThirdLabel.text = [NSString stringWithFormat:@"已学习%@课时",model.learnd_count];
    }else {
        
        self.cellThirdLabel.text = [NSString stringWithFormat:@"已学习0课时"];
    }
    
    if(model.course_length){ // 已学习课时
        
        self.cellFourthLabel.text = [NSString stringWithFormat:@"共%@课时",model.course_length];
    }else {
        
        self.cellFourthLabel.text = [NSString stringWithFormat:@"共0课时"];;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    RWDeviceScreenType screenType = [RWDeviceInfo deviceScreenType];
    if(screenType <= RWDeviceScreenTypeSE) {
    
        self.subTitleOffet.constant = 0;
    }
    [UILabel changeLineSpaceForLabel:self.cellTitleLabel WithSpace:1];
    // subTitleOffet
}



@end
