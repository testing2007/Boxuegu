//
//  BXGStudyTableViewCell.m
//  Boxuegu
//
//  Created by HM on 2017/4/12.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseHorizentalCell.h"
#import "BXGHistoryModel.h"
#import "BXGLearningRecordModel.h"

#import "UILabel+Extension.h"

@interface BXGCourseHorizentalCell()

@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;
@property (weak, nonatomic) IBOutlet UILabel *courceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *learndSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *coureLengthLabel;

@property (nonatomic, weak) UIButton *purchaseBtn;
@end

@implementation BXGCourseHorizentalCell

- (void)setIsPurchase:(BOOL)isPurchase {
    
    _isPurchase = isPurchase;
    if(_isPurchase) {
        
        self.purchaseBtn.hidden = false;
        // self.learndSumLabel.hidden = true;
        self.coureLengthLabel.hidden = true;
    }else {
        
        self.purchaseBtn.hidden = true;
        // self.learndSumLabel.hidden = false;
        self.coureLengthLabel.hidden = false;
    }
}

- (void)setModel:(BXGCourseModel *)model {
    _model = model;
    
    [self.smallImageView sd_setImageWithURL:[NSURL URLWithString:model.smallimg_path]  placeholderImage:[UIImage imageNamed:@"默认加载图"]];
    self.courceNameLabel.text = model.course_name;
    self.teacherNameLabel.text = model.teacher_name;
    self.learndSumLabel.hidden = false;
    self.learndSumLabel.text = [model.learnd_sum stringByAppendingString:@"人在学"];
    self.coureLengthLabel.hidden = false;
    self.coureLengthLabel.text = [model.course_length stringByAppendingString:@"课时"];
    
}

- (void)setHistoryModel:(BXGHistoryModel *)historyModel {

    _historyModel = historyModel;
    
    // [self.smallImageView sd_setImageWithURL:[NSURL URLWithString:historyModel.smallimgPaht]  placeholderImage:[UIImage imageNamed:@"默认加载图"]];
    self.courceNameLabel.text = historyModel.course_name;
    self.teacherNameLabel.text = historyModel.video_name;
    
    NSString *percent = [NSString stringWithFormat:@"已学习%.0lf%%", historyModel.per * 100];
    
    [self.smallImageView sd_setImageWithURL:[NSURL URLWithString:historyModel.smallimgPath]  placeholderImage:[UIImage imageNamed:@"默认加载图"]];
    self.learndSumLabel.text = percent;
    
    self.coureLengthLabel.hidden = true;
    
}

- (void)setRecordModel:(BXGLearningRecordModel *)recordModel {

    _recordModel = recordModel;
    
    self.courceNameLabel.text = recordModel.course_name;
    self.teacherNameLabel.text = recordModel.video_name;
    
    // NSString *percent = [NSString stringWithFormat:@"已学习%.0lf%%", recordModel.per * 100];
    
    [self.smallImageView sd_setImageWithURL:[NSURL URLWithString:recordModel.smallimgPath]  placeholderImage:[UIImage imageNamed:@"默认加载图"]];
    self.learndSumLabel.text = @"";
    
    self.coureLengthLabel.hidden = true;
}

- (void)setCourseNoteModel:(BXGCourseNoteModel *)noteModel
{
    _courseNoteModel = noteModel;
    
    [self.smallImageView sd_setImageWithURL:[NSURL URLWithString:_courseNoteModel.smallImgPath]
                           placeholderImage:[UIImage imageNamed:@"默认加载图"]];
    self.courceNameLabel.text = _courseNoteModel.courseName;
    self.teacherNameLabel.text = [NSString stringWithFormat:@"笔记%@条",_courseNoteModel.notesCount];
    
    self.learndSumLabel.text = @"";
    self.coureLengthLabel.hidden = true;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.smallImageView.layer.masksToBounds = true;
    
    
    UIButton *purchaseBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    [self addSubview:purchaseBtn];
    
    [purchaseBtn setTintColor:[UIColor colorWithHex:0x38ADFF]];
    [purchaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(-15);
        make.centerY.equalTo(self.coureLengthLabel.mas_centerY).offset(0);
    }];
    self.purchaseBtn = purchaseBtn;
    purchaseBtn.hidden = true;
    
    [purchaseBtn addTarget:self action:@selector(clickPurchaseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [UILabel changeLineSpaceForLabel:self.courceNameLabel WithSpace:1];
}


- (void)clickPurchaseBtn:(UIButton *)sender {
 
    if(self.clickAddBtnBlock){
    
        self.clickAddBtnBlock(self.model);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
