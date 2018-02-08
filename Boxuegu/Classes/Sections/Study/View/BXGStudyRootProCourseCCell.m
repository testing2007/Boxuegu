//
//  BXGStudyRootProCourseCCell.m
//  Boxuegu
//
//  Created by HM on 2017/6/13.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudyRootProCourseCCell.h"

@interface BXGStudyRootProCourseCCell()
@property (weak, nonatomic) IBOutlet UIImageView *cellIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellCourseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellTeacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellStudyCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellLearnedCount;

@end

@implementation BXGStudyRootProCourseCCell


- (void)setCourseDetailViewModel:(BXGCourseDetailViewModel *)courseDetailViewModel {

    _courseDetailViewModel = courseDetailViewModel;
    self.model = courseDetailViewModel.courseModel;
}


-(void)setModel:(BXGCourseModel *)model {

    _model = model;
    
    if(model.course_name){
    
        self.cellCourseNameLabel.text = model.course_name;
    }else {
    
        self.cellCourseNameLabel.text = @"";
    }
    
    if(model.smallimg_path){
        
        [self.cellIconImageView sd_setImageWithURL:[NSURL URLWithString:model.smallimg_path] placeholderImage:[UIImage imageNamed:@"默认加载图"]];
    }else {
        
        [self.cellIconImageView setImage:[UIImage imageNamed:@"默认加载图"]];
    }
    
    if(model.teacher_name){
        
        self.cellTeacherNameLabel.text = model.teacher_name;
    }else {
        
        self.cellTeacherNameLabel.text = @"";
    }
    
    if(model.learnd_count){ // 已学习课时
        
        self.cellLearnedCount.text = [NSString stringWithFormat:@"已学习%@课时",model.learnd_count];
    }else {
        
        self.cellLearnedCount.text = [NSString stringWithFormat:@"已学习0课时"];
    }
    
    if(model.course_length){ // 已学习课时
        
        self.cellStudyCountLabel.text = [NSString stringWithFormat:@"共%@课时",model.course_length];
    }else {
        
        self.cellStudyCountLabel.text = [NSString stringWithFormat:@"共0课时"];;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
