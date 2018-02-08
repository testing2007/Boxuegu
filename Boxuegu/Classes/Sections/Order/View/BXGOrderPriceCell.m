//
//  BXGOrderPriceCell.m
//  Boxuegu
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderPriceCell.h"

@implementation BXGOrderPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self installUI];
    }
    return self;
}

- (void)installUI {
    UILabel *nameLabel = [UILabel new];
    [nameLabel setFont:[UIFont bxg_fontRegularWithSize:16]];
    [nameLabel setTextColor:[UIColor colorWithHex:0x333333]];
    [self.contentView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    UILabel *priceLabel = [UILabel new];
    [priceLabel setFont:[UIFont bxg_fontRegularWithSize:18]];
    [priceLabel setTextColor:[UIColor colorWithHex:0xFF6764]];
    [self.contentView addSubview:priceLabel];
    _priceLabel = priceLabel;

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(self);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self);
    }];
}

@end
