//
//  BXGOrderPayStyleCell.m
//  Boxuegu
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderPayStyleCell.h"

@implementation BXGOrderPayStyleCell

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
        [self installUI];
    }
    return self;
}

-(void)installUI {
//    @property(nonatomic, weak) UIImageView *identifyImageView;
//    @property(nonatomic, weak) UILabel *nameLable;
//    @property(nonatomic, weak) OptionImageView *optionImageView
    
    UIImageView *identifyImageView = [UIImageView new];
//    identifyImageView.layer.borderWidth = 1;
//    identifyImageView.layer.borderColor = [UIColor redColor].CGColor;
    [self.contentView addSubview:identifyImageView];
    _identifyImageView = identifyImageView;
    
    UILabel *nameLabel = [UILabel new];
    [nameLabel setFont:[UIFont bxg_fontRegularWithSize:16]];
    [nameLabel setTextColor:[UIColor colorWithHex:0x333333]];
    [self.contentView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    OptionImageView *optImageView = [[OptionImageView alloc] initIsSel:NO andSelBlock:nil andUnselBlock:nil];
    [self.contentView addSubview:optImageView];
    _optionImageView = optImageView;
    
    [_identifyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(self);
        make.width.equalTo(@22);//@16+6
        make.height.equalTo(@22);//@16+6
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_identifyImageView.mas_right).offset(7);
        make.centerY.equalTo(self);
    }];
    
    [_optionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self);
    }];
    
}


@end
