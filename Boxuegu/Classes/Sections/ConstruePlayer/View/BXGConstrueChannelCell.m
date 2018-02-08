//
//  BXGConstrueChannelCell.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/15.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGConstrueChannelCell.h"
@interface BXGConstrueChannelCell()
@property (nonatomic, strong) UILabel *cellTitleLabel;
@end
@implementation BXGConstrueChannelCell

- (UILabel *)cellTitleLabel {
    
    if(_cellTitleLabel == nil) {
        
        _cellTitleLabel = [UILabel new];
        _cellTitleLabel.font = [UIFont bxg_fontRegularWithSize:12];
        _cellTitleLabel.textColor = [UIColor whiteColor];
    }
    return _cellTitleLabel;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setIsCurrentSelected:selected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setIsCurrentSelected:selected];
}

- (void)setCellTitle:(NSString *)cellTitle {
    _cellTitle = cellTitle;
    if(cellTitle.length > 0) {
        self.cellTitleLabel.text = cellTitle;
    }else {
        self.cellTitleLabel.text = @"";
    }
}

- (void)setIsCurrentSelected:(BOOL)isCurrentSelected {
    _isCurrentSelected = isCurrentSelected;
    if(_isCurrentSelected) {
        
        self.cellTitleLabel.textColor = [UIColor themeColor];
    }else {
        
        self.cellTitleLabel.textColor = [UIColor whiteColor];
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
    UILabel *cellTitleLabel = self.cellTitleLabel;
    [self.contentView addSubview:cellTitleLabel];
    [cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
//    cellTitleLabel.textAlignment = NSTextAlignmentRight;
//    self.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
}
@end
