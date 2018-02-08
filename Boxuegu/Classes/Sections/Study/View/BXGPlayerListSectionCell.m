//
//  BXGStudySectionCell.m
//  Boxuegu
//
//  Created by HM on 2017/4/22.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPlayerListSectionCell.h"

@interface BXGPlayerListSectionCell()
@property (nonatomic, weak) UILabel *titleLabel;
@end


@implementation BXGPlayerListSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self installUI];
}
-(void)setTitle:(NSString *)title {
    
    _title = title;
    self.titleLabel.text = title;
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

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        [self installUI];
    }
    return self;
}
              
- (void)installUI {

    self.contentView.backgroundColor = [UIColor whiteColor];
    // self.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    titleLabel.font = [UIFont bxg_fontSemiboldWithSize:16];
    
    // titleLabel.textColor = [UIColor colorWithHex:0x666666];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
        make.height.offset(16);
        make.right.offset(-15);
    }];
    titleLabel.textColor = [UIColor blackColor];
    
}


@end
