//
//  BXGSelectionCell.m
//  demo-CCMedia
//
//  Created by HM on 2017/6/7.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "BXGSelectionCell.h"

// lib

#import "Masonry.h"
#import "UIColor+Extension.h"


@interface BXGSelectionCell ()

@property (nonatomic, strong) UILabel *cellTitleLabel;
@end

@implementation BXGSelectionCell

- (void)setCellTitle:(NSString *)cellTitle {

    _cellTitle = cellTitle;
    self.cellTitleLabel.text = cellTitle;
}

- (UILabel *)cellTitleLabel {

    if(!_cellTitleLabel){
    
        _cellTitleLabel = [UILabel new];
        _cellTitleLabel.font = [UIFont bxg_fontRegularWithSize:15];
        _cellTitleLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
    }
    return _cellTitleLabel;
}

- (UITableViewCellSelectionStyle)selectionStyle {

    return UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    //[super setSelected:selected];
    
    if(selected) {
        
        self.cellTitleLabel.textColor = [UIColor colorWithHex:0x38ADFF];
        
    }else {
        
        self.cellTitleLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
    }
}

- (void)setSelected:(BOOL)selected {

    //[super setSelected:selected];
    
    if(selected) {
    
        self.cellTitleLabel.textColor = [UIColor colorWithHex:0x38ADFF];
        
    }else {
    
        self.cellTitleLabel.textColor = [UIColor colorWithHex:0xFFFFFF];
    }
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
    [self.cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(15);
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
