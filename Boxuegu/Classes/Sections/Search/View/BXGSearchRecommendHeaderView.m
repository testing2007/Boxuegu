//
//  BXGSearchRecommendHeaderView.m
//  Boxuegu
//
//  Created by apple on 2017/12/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSearchRecommendHeaderView.h"

@interface BXGSearchRecommendHeaderView()
@end

@implementation BXGSearchRecommendHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        [self installUI];
    }
    return self;
}

-(void)installUI {
    UILabel *titleLabel = [UILabel new];
    [titleLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    titleLabel.textColor = [UIColor colorWithHex:0x333333];
    [titleLabel setText:@""];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UIButton *cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cleanButton.titleLabel setFont:[UIFont bxg_fontRegularWithSize:12]];
    [cleanButton setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    [cleanButton addTarget:self action:@selector(onCleanHistory:) forControlEvents:UIControlEventTouchUpInside];
    [cleanButton setTitle:@"清除" forState:UIControlStateNormal];
    [self addSubview:cleanButton];
    _cleanBtn = cleanButton;
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    [_cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.offset(0);
    }];
}

-(void)onCleanHistory:(UIButton*)sender {
    if(_tapCleanHistory) {
        _tapCleanHistory();
    }
}

@end
