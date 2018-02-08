//
//  BXGOrderFooterView.m
//  Boxuegu
//
//  Created by apple on 2017/10/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderFooterView.h"

@interface BXGOrderFooterView()
@property(nonatomic, assign) BOOL rightBtnEnable;
@end

@implementation BXGOrderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self installUI];
    }
    return self;
}

- (void)installUI {
    self.contentView.backgroundColor = [UIColor whiteColor];

    _rightBtnEnable = YES;
    
    UILabel *title = [UILabel new];
    [title setTextColor:[UIColor colorWithHex:0xFF554C]];
    [title setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.contentView addSubview:title];
    _leftTitle = title;

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.layer.cornerRadius = 15;
    rightButton.layer.masksToBounds = YES;
    [rightButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton.titleLabel setFont:[UIFont bxg_fontRegularWithSize:15]];
    [self.contentView addSubview:rightButton];
    _rightBtn = rightButton;
    [self setRightBtnEnable:YES];

    UIView *seperateLineView = [UIView new];
    seperateLineView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [self.contentView addSubview:seperateLineView];
    _seperateLineView = seperateLineView;
    
    [_leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17);
        make.centerY.equalTo(self).offset(-9/2);
        make.height.equalTo(@15);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-9/2);
        make.right.equalTo(@-15);
        make.height.equalTo(@30);
        make.width.equalTo(@90);
    }];
    
    [_seperateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.equalTo(@9);
    }];
}

- (void)rightBtnAction:(UIButton*)sender {
    if(_rightBtnEnable) {
        if(_rightBtnBlock) {
            _rightBtnBlock();
        }
    } else {
        [[BXGHUDTool share] showHUDWithString:kBXGToastOrderMultiCoursePay];
    }
}

- (void)setRightBtnEnable:(BOOL)bEnable {
    if(bEnable) {
        [_rightBtn setBackgroundColor:[UIColor colorWithHex:0x38ADFF]];
    } else {
        [_rightBtn setBackgroundColor:[UIColor colorWithHex:0x666666]];
    }
    _rightBtnEnable = bEnable;
}

@end
