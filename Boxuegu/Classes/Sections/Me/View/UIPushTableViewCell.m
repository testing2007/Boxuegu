//
//  UIPushTableViewCell.m
//  Boxuegu
//
//  Created by HM on 2017/6/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "UIPushTableViewCell.h"
#import "RWBadgeView.h"

@interface UIPushTableViewCell()
@property (nonatomic,strong) UILabel *cellTitleLabel;

@property (nonatomic, weak) RWBadgeView *badgeView;
@end

@implementation UIPushTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
    
        [self installUI];
    }
    return self;
}

-(void)setBedgeNumber:(NSInteger)bedgeNumber {

    _bedgeNumber = bedgeNumber;
    self.badgeView.badgeNumber = _bedgeNumber;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self installUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    if(title){
        self.cellTitleLabel.text = title;
    }else {
        
        self.cellTitleLabel.text = @"";
    }
}

- (UILabel *)cellTitleLabel {
    
    if(!_cellTitleLabel) {
        
        _cellTitleLabel = [UILabel new];
    }
    return  _cellTitleLabel;
}
//*
-(UIImageView*)iconImageView
{
    if(!_iconImageView)
    {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}
//*/
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)installUI {
    [self.contentView addSubview:self.iconImageView];
    
    self.cellTitleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    self.cellTitleLabel.text = @"";
    self.cellTitleLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.cellTitleLabel sizeToFit];
    
    [self.contentView addSubview:self.cellTitleLabel];
    [self.cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
        make.right.offset(-50);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 50 - 15);
    }];
    
    RWBadgeView *badgeView = [RWBadgeView new];
    self.badgeView = badgeView;
    [self.contentView addSubview:badgeView];
    
    [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.width.offset(20);
        make.centerY.offset(0);
        make.height.offset(14);
    }];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

-(void)updateLayout
{
    [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_iconImageView.image==nil ? CGSizeZero : CGSizeMake(23, 23));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(13);
    }];
    [self.cellTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(_iconImageView.image==nil ? 15 : 13+23+9);
        make.centerY.offset(0);
        make.right.offset(-50);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 50 -(13+23+9));
    }];
}

- (void)updateConstraints
{
    [self updateLayout];
    [super updateConstraints];
}

@end
