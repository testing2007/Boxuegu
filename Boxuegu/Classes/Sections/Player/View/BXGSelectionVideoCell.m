//
//  BXGSelectionVideoCell.m
//  demo-CCMedia
//
//  Created by HM on 2017/6/7.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "UIColor+Extension.h"

#import "BXGSelectionVideoCell.h"
#import "Masonry.h"

@interface BXGSelectionVideoCell ()

@property (nonatomic, strong) UILabel *cellTitleLabel;
@property (nonatomic, strong) UIImageView *cellIconImageView;
//@property (nonatomic, copy) NSString *cellTitle;
@end
@implementation BXGSelectionVideoCell

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.isArrow = selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.isArrow = selected;
}

- (void)setIsArrow:(BOOL)isArrow {

    _isArrow = isArrow;
    if(isArrow) {
        
        [self.cellIconImageView setImage:[UIImage imageNamed:@"课程详情-播放"]];
        self.cellTitleLabel.textColor = [UIColor colorWithHex:0x38ADFF];
        
    }else {
        
        [self.cellIconImageView setImage:[UIImage imageNamed:@"课程详情列表-未播放"]];
        self.cellTitleLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
    }
}

- (void)setCellTitle:(NSString *)cellTitle {
    
    _cellTitle = cellTitle;
    self.cellTitleLabel.text = cellTitle;
}

- (void)setModel:(BXGCourseOutlineVideoModel *)model {

    _model = model;
    self.cellTitle = model.name;
}

- (UILabel *)cellTitleLabel {
    
    if(!_cellTitleLabel){
        
        _cellTitleLabel = [UILabel new];
        _cellTitleLabel.font = [UIFont bxg_fontRegularWithSize:15];
        _cellTitleLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
    }
    return _cellTitleLabel;
}


- (UIImageView *)cellIconImageView {

    if(!_cellIconImageView) {
    
        _cellIconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"课程详情列表-未播放"]];
    }
    return _cellIconImageView;
}


- (UITableViewCellSelectionStyle)selectionStyle {
    
    return UITableViewCellSelectionStyleNone;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        
        [self installUI];
    }
    return self;
}

- (void)installUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.cellTitleLabel];
    
    self.backgroundColor = [UIColor clearColor];
   
    [self.contentView addSubview:self.cellIconImageView];

    
    [self.cellIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
        make.width.height.offset(18);
    }];
    [self.cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.cellIconImageView.mas_right).offset(15);
        make.centerY.offset(0);
        make.right.offset(-15);
    }];
    
    UIView *bottomSpView = [UIView new];
    bottomSpView.backgroundColor = [UIColor colorWithHex:0x333333];
    [self.contentView addSubview:bottomSpView];
    [bottomSpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.bottom.offset(0);
        make.height.offset(1);
    }];
}


@end
