//
//  BXGOrderBuyCourseCell.m
//  Boxuegu
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderBuyCourseCell.h"

@implementation BXGOrderBuyCourseCell

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
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if([reuseIdentifier isEqualToString:BXGOrderBuyCourseCellId_PriceImportantShow]) {
            [self installUI:YES];
        } else {
            [self installUI:NO];
        }
    }
    return self;
}

- (void)installUI:(BOOL)bPriceImportantShow {
//    @property(nonatomic, weak) UIImageView *courseThumbImageView;
//    @property(nonatomic, weak) UILabel *titleLabel;
//    @property(nonatomic, weak) UILabel *priceLabel;
//    @property(nonatomic, weak) UILabel *expireLabel;
    UIImageView *imageView = [UIImageView new];
    imageView.layer.cornerRadius = 4;
    imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:imageView];
    _courseThumbImageView = imageView;
    
    UILabel *titleLabel =[UILabel new];
    [titleLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [titleLabel setTextColor:[UIColor colorWithHex:0x333333]];
    if(IS_IPHONE_5) {
        [titleLabel setNumberOfLines:1];
    } else {
        [titleLabel setNumberOfLines:2];
    }
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UILabel *priceLabel = [UILabel new];
    [self.contentView addSubview:priceLabel];
    _priceLabel = priceLabel;
    if(bPriceImportantShow) {
        [_priceLabel setFont:[UIFont bxg_fontRegularWithSize:18]];
        [_priceLabel setTextColor:[UIColor colorWithHex:0xFF554C]];
    } else {
        [_priceLabel setFont:[UIFont bxg_fontRegularWithSize:12]];
        [_priceLabel setTextColor:[UIColor colorWithHex:0x999999]];
    }
//    [self priceIsImportShow:YES];
    
    UILabel *expireLabel = [UILabel new];
    [expireLabel setFont:[UIFont bxg_fontRegularWithSize:12]];
    [expireLabel setTextColor:[UIColor colorWithHex:0x999999]];
    [self.contentView addSubview:expireLabel];
    _expireLabel = expireLabel;
    
    [_courseThumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.width.equalTo(_courseThumbImageView.mas_height).multipliedBy(165.0/93.0);
        make.bottom.offset(-15);
//        make.width.equalTo(@165);
//        make.height.equalTo(@93);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_courseThumbImageView.mas_right).offset(10);
        make.top.equalTo(_courseThumbImageView.mas_top);
        make.right.offset(-15);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_titleLabel.mas_bottom).offset(3);
    }];
    
    [_expireLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.bottom.equalTo(_courseThumbImageView.mas_bottom);
        make.right.lessThanOrEqualTo(@-15);
    }];
}

//- (void)priceIsImportShow:(BOOL)bImportShow {
//    if(bImportShow) {
//        [_priceLabel setFont:[UIFont bxg_fontRegularWithSize:18]];
//        [_priceLabel setTextColor:[UIColor colorWithHex:0xFF554C]];
//    } else {
//        [_priceLabel setFont:[UIFont bxg_fontRegularWithSize:12]];
//        [_priceLabel setTextColor:[UIColor colorWithHex:0x999999]];
//    }
//}



















@end
