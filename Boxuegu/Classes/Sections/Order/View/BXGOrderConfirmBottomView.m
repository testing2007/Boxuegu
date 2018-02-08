//
//  BXGOrderConfirmBottomView.m
//  Boxuegu
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderConfirmBottomView.h"

@interface BXGOrderConfirmBottomView()
@property(nonatomic, assign) BOOL bConfirmEnable;
@end

@implementation BXGOrderConfirmBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        _bConfirmEnable = YES;
        [self installUI];
    }
    return self;
}

-(void)installUI {

    UILabel *payAmountLabel = [UILabel new];
    [payAmountLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [payAmountLabel setFont:[UIFont bxg_fontRegularWithSize:13]];
    [self addSubview:payAmountLabel];
    _payAmountLabel = payAmountLabel;
    
    UILabel *amountLabel = [UILabel new];
    [amountLabel setTextColor:[UIColor colorWithHex:0xFF6764]];
    [amountLabel setFont:[UIFont bxg_fontRegularWithSize:18]];
    [self addSubview:amountLabel];
    _amountLabel = amountLabel;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(submitOrder:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor colorWithHex:0x38ADFF]];
    [btn setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont bxg_fontRegularWithSize:18]];
    [self addSubview:btn];
    _confirmBtn = btn;

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.offset(0);
        make.width.equalTo(@130);
    }];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(btn.mas_left).offset(-15);
    }];
    [payAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(amountLabel.mas_left).offset(0);
    }];
}

-(void)submitOrder:(UIButton*)sender {
    if(!_bConfirmEnable) {
        [[BXGHUDTool share] showHUDWithString:@"请先阅读并同意《博学谷用户付费协议》"];
    } else {
        if(_submitOrderBlock) {
            _submitOrderBlock();
        }
    }
}

-(void)confirmIsEnable:(BOOL)bEnable {
//    [_confirmBtn setEnabled:bEnable];
    if(bEnable) {
        [_confirmBtn setBackgroundColor:[UIColor colorWithHex:0x38ADFF]];
    } else {
        [_confirmBtn setBackgroundColor:[UIColor colorWithHex:0xCCCCCC]];
    }
    
    _bConfirmEnable = bEnable;
}

@end

