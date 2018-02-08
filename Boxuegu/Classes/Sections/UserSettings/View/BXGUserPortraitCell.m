//
//  BXGUserPortraitCell.m
//  Boxuegu
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGUserPortraitCell.h"


@implementation BXGUserPortraitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    [self.textLabel setTextColor:[UIColor colorWithHex:0x333333]];
    [self.textLabel setFont:[UIFont bxg_fontRegularWithSize:16]];
    [self.detailTextLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [self.detailTextLabel setFont:[UIFont bxg_fontRegularWithSize:16]];
}

- (void)layoutSubviews {
    if([self.reuseIdentifier isEqualToString:idImageCell]) {
        [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if(K_IS_IPHONE_6_PLUS) {
                make.left.offset(20);
            } else {
                make.left.offset(15);
            }
            make.centerY.offset(0);
        }];
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.centerY.offset(0);
            make.height.equalTo(@50);
            make.width.equalTo(@50);
        }];
        
        self.imageView.layer.cornerRadius = 25;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    } else if ([self.reuseIdentifier isEqualToString:idEmailCell]) {
        [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if(K_IS_IPHONE_6_PLUS) {
                make.left.offset(20);
            } else {
                make.left.offset(15);
            }
            make.centerY.offset(0);
        }];
        [self.detailTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-36);
            make.centerY.offset(0);
//            make.height.equalTo(@50);
//            make.width.equalTo(@50);
        }];
    }
    
    
    [super layoutSubviews];
}

@end
