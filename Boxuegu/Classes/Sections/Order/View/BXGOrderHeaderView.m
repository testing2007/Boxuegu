//
//  BXGOrderHeaderView.m
//  Boxuegu
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderHeaderView.h"

@implementation BXGOrderHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self) {
        [self installUI];
    }
    return self;
}

- (void)installUI {
    self.contentView.backgroundColor = [UIColor whiteColor];

    UILabel *title = [UILabel new];
    [title setTextColor:[UIColor colorWithHex:0x666666]];
    if(IS_IPHONE_5) {
        [title setFont:[UIFont bxg_fontRegularWithSize:15]];
    } else {
        [title setFont:[UIFont bxg_fontRegularWithSize:16]];
    }
    [self.contentView addSubview:title];
    _title = title;
    
    UILabel *subtitle = [UILabel new];
    [subtitle setTextColor:[UIColor colorWithHex:0x666666]];
    if(IS_IPHONE_5) {
        [subtitle setFont:[UIFont bxg_fontRegularWithSize:15]];
    } else {
        [subtitle setFont:[UIFont bxg_fontRegularWithSize:16]];
    }
    [self.contentView addSubview:subtitle];
    _subtitle = subtitle;
    
    UILabel *rightTitle = [UILabel new];
    [rightTitle setTextColor:[UIColor colorWithHex:0x666666]];
    [rightTitle setFont:[UIFont bxg_fontRegularWithSize:12]];
    rightTitle.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:rightTitle];
    _rightTitle = rightTitle;
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(self);
        make.height.equalTo(@15);
    }];
    //将左边文本显示优先级设置到最高, 这样如果中间subtitle很长不至于将左边的文本被挤掉.
    [self.title setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [_rightTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(@-15);
        make.height.equalTo(@20);
    }];
    
    [_subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_title.mas_right).offset(5);
        make.centerY.equalTo(self);
        make.right.lessThanOrEqualTo(_rightTitle.mas_left).offset(0);
        make.height.equalTo(@18);
    }];
}

@end
