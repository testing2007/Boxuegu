//
//  BXGOrderCouponCell.m
//  Boxuegu
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderCouponCell.h"

@implementation BXGOrderCouponCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self installUI];
    }
    return self;
}

- (void)installUI {
    UILabel *nameLabel = [UILabel new];
    [nameLabel setFont:[UIFont bxg_fontRegularWithSize:16]];
    [nameLabel setTextColor:[UIColor colorWithHex:0x333333]];
    [nameLabel setText:@"优惠券"];
    [self.contentView addSubview:nameLabel];
    
    UILabel *availableNumLabel = [UILabel new];
    [availableNumLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [availableNumLabel setTextColor:[UIColor colorWithHex:0x999999]];
    [self.contentView addSubview:availableNumLabel];
    _availableNumLabel = availableNumLabel;
    
    UILabel *arrowLabel = [UILabel new];
    [arrowLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [arrowLabel setTextColor:[UIColor colorWithHex:0xDDDDDD]];
    [arrowLabel setText:@">"];
    [self.contentView addSubview:arrowLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(self);
    }];
    
    [arrowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self);
    }];
    
    [_availableNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowLabel.mas_left).offset(-5);
        make.centerY.equalTo(self);
    }];
}

@end
