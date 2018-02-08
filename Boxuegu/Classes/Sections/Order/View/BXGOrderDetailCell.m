//
//  BXGOrderDetailCell.m
//  Boxuegu
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderDetailCell.h"

@implementation BXGOrderDetailCell

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
    UILabel *payStyleId = [UILabel new];
    [payStyleId setText:@"支付方式: "];
    [payStyleId sizeToFit];
    [payStyleId setTextColor:[UIColor colorWithHex:0x666666]];
    [payStyleId setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.contentView addSubview:payStyleId];
    UILabel *payStyleLabel = [UILabel new];
    [payStyleLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [payStyleLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.contentView addSubview:payStyleLabel];
    _payStyleLabel = payStyleLabel;
    
    UILabel *amountId = [UILabel new];
    [amountId setText:@"订单金额: "];
    [amountId sizeToFit];
    [amountId setTextColor:[UIColor colorWithHex:0x666666]];
    [amountId setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.contentView addSubview:amountId];
    UILabel *amountLabel = [UILabel new];
    [amountLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [amountLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.contentView addSubview:amountLabel];
    _amountLabel = amountLabel;
    
    UILabel *discountAmountId = [UILabel new];
    [discountAmountId setText:@"优惠抵扣: "];
    [discountAmountId sizeToFit];
    [discountAmountId setTextColor:[UIColor colorWithHex:0x666666]];
    [discountAmountId setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.contentView addSubview:discountAmountId];
    UILabel *discountAmountLabel = [UILabel new];
    [discountAmountLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [discountAmountLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.contentView addSubview:discountAmountLabel];
    _discountAmountLabel = discountAmountLabel;
    
    UILabel *overAmountId = [UILabel new];
    [overAmountId setText:@"满减优惠: "];
    [overAmountId sizeToFit];
    [overAmountId setTextColor:[UIColor colorWithHex:0x666666]];
    [overAmountId setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.contentView addSubview:overAmountId];
    UILabel *overAmountLabel = [UILabel new];
    [overAmountLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [overAmountLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.contentView addSubview:overAmountLabel];
    _overAmountLabel = overAmountLabel;
    
    UILabel *payPriceId = [UILabel new];
    [payPriceId setText:@"实际金额: "];
    [payPriceId sizeToFit];
    [payPriceId setTextColor:[UIColor colorWithHex:0x666666]];
    [payPriceId setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.contentView addSubview:payPriceId];
    UILabel *payPriceLabel = [UILabel new];
    [payPriceLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [payPriceLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.contentView addSubview:payPriceLabel];
    _payPriceLabel = payPriceLabel;
    
    UILabel *orderTimeId = [UILabel new];
    [orderTimeId setText:@"下单时间: "];
    [orderTimeId sizeToFit];
    [orderTimeId setTextColor:[UIColor colorWithHex:0x666666]];
    [orderTimeId setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.contentView addSubview:orderTimeId];
    UILabel *orderTimeLabel = [UILabel new];
    [orderTimeLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [orderTimeLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.contentView addSubview:orderTimeLabel];
    _orderTimeLabel = orderTimeLabel;
    
    UILabel *payTimeId = [UILabel new];
    [payTimeId setText:@"支付时间: "];
    [payTimeId sizeToFit];
    [payTimeId setTextColor:[UIColor colorWithHex:0x666666]];
    [payTimeId setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.contentView addSubview:payTimeId];
    UILabel *payTimeLabel = [UILabel new];
    [payTimeLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [payTimeLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.contentView addSubview:payTimeLabel];
    _payTimeLabel = payTimeLabel;

    [payStyleId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.height.equalTo(@15);
    }];
    [payStyleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payStyleId.mas_right);
        make.top.equalTo(payStyleId.mas_top);
        make.height.equalTo(@15);
    }];
    
    [amountId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(payStyleId.mas_bottom).offset(10);
        make.height.equalTo(@15);
    }];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(amountId.mas_right);
        make.top.equalTo(amountId.mas_top);
        make.height.equalTo(@15);
    }];
    
    [discountAmountId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(amountId.mas_bottom).offset(10);
        make.height.equalTo(@15);
    }];
    [discountAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(discountAmountId.mas_right);
        make.top.equalTo(discountAmountId.mas_top);
        make.height.equalTo(@15);
    }];
    
    [overAmountId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(discountAmountId.mas_bottom).offset(10);
        make.height.equalTo(@15);
    }];
    [overAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(overAmountId.mas_right);
        make.top.equalTo(overAmountId.mas_top);
        make.height.equalTo(@15);
    }];
    
    [payPriceId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(overAmountId.mas_bottom).offset(10);
        make.height.equalTo(@15);
    }];
    [payPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payPriceId.mas_right);
        make.top.equalTo(payPriceId.mas_top);
        make.height.equalTo(@15);
    }];
    
    [orderTimeId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(payPriceId.mas_bottom).offset(10);
        make.height.equalTo(@15);
    }];
    [orderTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderTimeId.mas_right);
        make.top.equalTo(orderTimeId.mas_top);
        make.height.equalTo(@15);
    }];

    [payTimeId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(orderTimeId.mas_bottom).offset(10);
        make.height.equalTo(@15);
    }];
    [payTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payTimeId.mas_right);
        make.top.equalTo(payTimeId.mas_top);
        make.height.equalTo(@15);
    }];
}

@end
