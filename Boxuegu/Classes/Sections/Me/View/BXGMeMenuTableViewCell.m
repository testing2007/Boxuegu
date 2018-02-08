//
//  BXGMeMenuNormalTableViewCell.m
//  Boxuegu
//
//  Created by HM on 2017/4/14.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMeMenuTableViewCell.h"

@interface BXGMeMenuTableViewCell()


@end

@implementation BXGMeMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self installUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self installUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        [self installUI];
    }
    return self;
}
- (void)installUI {
    
    self.textLabel.font = [UIFont bxg_fontRegularWithSize:16];
    self.detailTextLabel.font = [UIFont bxg_fontRegularWithSize:13];
    self.textLabel.textColor = [UIColor colorWithHex:0x3333333];
    self.detailTextLabel.textColor = [UIColor colorWithHex:0x999999];
    
}

@end
