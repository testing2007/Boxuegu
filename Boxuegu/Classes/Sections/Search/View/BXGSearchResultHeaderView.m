//
//  BXGSearchResultHeaderView.m
//  Boxuegu
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSearchResultHeaderView.h"

@implementation BXGSearchResultHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectZero];
    if(self) {
        [self installUI];
    }
    return self;
}

- (void)installUI {
    self.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    UILabel *titleLabel = [UILabel new];
    [titleLabel setFont:[UIFont bxg_fontRegularWithSize:14]];
    titleLabel.textColor = [UIColor colorWithHex:0x666666];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
}

@end
