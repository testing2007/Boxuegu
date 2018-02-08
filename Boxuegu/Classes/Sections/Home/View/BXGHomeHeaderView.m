//
//  BXGHomeHeaderView.m
//  CollectionViewPrj
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "BXGHomeHeaderView.h"

@implementation BXGHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self installUI];
    }
    return self;
}

- (void)installUI {
    self.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
    
    UIView *markView = [UIView new];
    markView.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    [self addSubview:markView];

    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor colorWithHex:0x333333];
    titleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UIButton *moreButton  = [UIButton new];
    [self addSubview:moreButton];
    [moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [moreButton.titleLabel setFont:[UIFont bxg_fontRegularWithSize:12]];
    [moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [moreButton addTarget:self  action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    
    [markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.equalTo(@15);
        make.left.offset(15);
        make.width.equalTo(@2);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(markView.mas_right).offset(5);
        make.centerY.equalTo(self);
    }];
    
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-8);
        make.centerY.equalTo(self);
    }];
}

- (void)more {
//    NSAssert(_type!=UNKNOWN_COURSE_TYPE, @"type don't assign right value");
    RWLog(@"more is trigger");
    if(_moreBlock) {
        _moreBlock(_type);
    }
}

@end
