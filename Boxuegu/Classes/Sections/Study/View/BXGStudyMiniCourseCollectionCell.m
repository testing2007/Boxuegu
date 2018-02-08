//
//  BXGStudyTableViewCell.m
//  Boxuegu
//
//  Created by HM on 2017/4/12.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudyMiniCourseCollectionCell.h"

@interface BXGStudyMiniCourseCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;
@property (weak, nonatomic) IBOutlet UILabel *courceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *learndSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *coureLengthLabel;


@end

@implementation BXGStudyMiniCourseCollectionCell

//- (void)setModel:(BXGMiniCourceModel *)model {
//    _model = model;
//    
//    [self.smallImageView sd_setImageWithURL:[NSURL URLWithString:model.smallimg_path]  placeholderImage:[UIImage imageNamed:@"默认加载图"]];
//    self.courceNameLabel.text = model.course_name;
//    self.teacherNameLabel.text = model.teacher_name;
//    self.learndSumLabel.text = [model.learnd_sum stringByAppendingString:@"人在学"];
//    self.coureLengthLabel.text = [model.course_length stringByAppendingString:@"课时"];
//    
//}

- (void)setModel:(BXGCourseModel *)model {
    _model = model;
    
    [self.smallImageView sd_setImageWithURL:[NSURL URLWithString:model.smallimg_path]  placeholderImage:[UIImage imageNamed:@"默认加载图"]];
    self.courceNameLabel.text = model.course_name;
    self.teacherNameLabel.text = model.teacher_name;
    self.learndSumLabel.text = [model.learnd_sum stringByAppendingString:@"人在学"];
    self.coureLengthLabel.text = [model.course_length stringByAppendingString:@"课时"];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.smallImageView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
