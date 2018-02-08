//
//  BXGPraiseCell.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPraiseCell.h"
#import "RWStarView.h"
#import "RWCommonFunction.h"
#import "BXGCourseLecturerModel.h"
@interface BXGPraiseCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellTimeLabel;
@property (weak, nonatomic) IBOutlet RWStarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *cellContentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellContentConstrainst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrainst;
@property (weak, nonatomic) UILabel *cellCenterTitleLabel;
@property (nonatomic, strong) UIView *spView;
@end

@implementation BXGPraiseCell

- (UIView *)spView {
    if(_spView == nil) {
        _spView = [UIView new];
        _spView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    }
    return _spView;
}
- (UITableViewCellSelectionStyle)selectionStyle {

    return UITableViewCellSelectionStyleNone;
}

- (void)setLecturerModel:(BXGCourseLecturerModel *)lecturerModel {
    _lecturerModel = lecturerModel;
    self.starView.hidden = true;
    self.cellTimeLabel.hidden = true;
    self.cellTitleLabel.font = [UIFont bxg_fontRegularWithSize:18];
    self.cellTitleLabel.text = lecturerModel.lectureName;
    self.cellContentLabel.textColor = [UIColor colorWithHex:0x999999];
    self.cellContentConstrainst.constant = -9;
    self.topConstrainst.constant = 5;
    
    self.iconImageView.layer.borderColor = [UIColor colorWithHex:0xf5f5f5].CGColor;
    self.iconImageView.layer.borderWidth = 0.5;
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if(!_spView) {
//            [self addSubview:self.spView];
//            [self.spView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.offset(-4);
//                make.left.right.offset(0);
//                make.height.offset(0.5);
//            }];
//        }
//    });
    
    
    
//    [self removeConstraint:self.cellContentConstrainst];
//
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cellContentLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.cellTitleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
//    self.cellContentConstrainst =
    // secondItem = self.cellTitleLabel
    [self layoutIfNeeded];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:lecturerModel.headImg] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.cellContentLabel.text = lecturerModel.des;
}

- (void)setModel:(BXGStudentCriticizeItemModel *)model {
    self.starView.changeStarEnable = false;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _model = model;
    
    if(model.smallPhoto){
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.smallPhoto] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }else {
        self.iconImageView.image = [UIImage imageNamed:@"默认头像"];
    }
    if(model.userName) {
        
        self.cellTitleLabel.text = model.userName;
    }else {
        
        self.cellTitleLabel.text = @" ";
    }
    
    if(model.createTime) {
        
        self.cellTimeLabel.text = model.createTime;
    }else {
        
        self.cellTimeLabel.text = @" ";
    }
    
    if(model.starLevel) {
        
        self.starView.stars = model.starLevel.integerValue;
    }else {
        
        self.starView.stars = 0;
    }
    
    if(model.content) {
        
        self.cellContentLabel.text = model.content;
    }else {
        
        
        self.cellContentLabel.text = @" ";
    }
    
    
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImageView.layer.cornerRadius = 16;
    self.iconImageView.layer.masksToBounds = true;
//    UILabel *cellCenterTitleLabel = [UILabel new];
//    [self.contentView addSubview:cellCenterTitleLabel];
//    cellCenterTitleLabel.font = [UIFont bxg_fontRegularWithSize:18];
//    cellCenterTitleLabel.textColor = [UIColor colorWithHex:0x333333];
//
//    [self.cellCenterTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.iconImageView);
//        make.left.equalTo(self.iconImageView.mas_right).offset(10);
//        make.right.offset(-15);
//    }];
    //self.cellTitleLabel.font = [UIFont bxg_fontRegularWithSize:RWAutoFontSize(16)];
    //self.cellTimeLabel.font = [UIFont bxg_fontRegularWithSize:RWAutoFontSize(13)];
    //self.cellContentLabel.font = [UIFont bxg_fontRegularWithSize:RWAutoFontSize(12)];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
