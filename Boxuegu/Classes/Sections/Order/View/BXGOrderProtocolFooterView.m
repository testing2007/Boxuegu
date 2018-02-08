//
//  BXGOrderProtocolFooterView.m
//  Boxuegu
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderProtocolFooterView.h"

@implementation BXGOrderProtocolFooterView

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
    OptionImageView *optImageView = [[OptionImageView alloc] initIsSel:YES andSelBlock:^{
        
    } andUnselBlock:^{
        
    }];
    [self addSubview:optImageView];
    self.optImageView = optImageView;
    
    UILabel *readedLabel = [UILabel new];
    [readedLabel setTextColor:[UIColor colorWithHex:0x666666]];
//    [readedLabel setFont:[RWFont fontWithName:@"PingFangSC-Regular" size:12]];
    [readedLabel setFont:[UIFont bxg_fontRegularWithSize:12]];
    [self addSubview:readedLabel];
    _readedLabel = readedLabel;
    
    UILabel *linkProtocolLabel = [UILabel new];
    [linkProtocolLabel setTextColor:[UIColor colorWithHex:0x666666]];
//    [linkProtocolLabel setFont:[RWFont fontWithName:@"PingFangSC-Regular" size:12]];
     [linkProtocolLabel setFont:[UIFont bxg_fontRegularWithSize:12]];
    [self addSubview:linkProtocolLabel];
    _linkProtocolLabel = linkProtocolLabel;
    
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    tap.numberOfTapsRequired = 1;
    [tap addTarget:self action:@selector(tapProtocol:)];
    [self addGestureRecognizer:tap];
    
    [_optImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(self);
        make.width.equalTo(@19);
        make.height.equalTo(@19);
    }];
    
    [_readedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_optImageView);
        make.left.equalTo(_optImageView.mas_right).offset(12);
    }];
    
    [_linkProtocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_readedLabel.mas_right).offset(5);
        make.centerY.equalTo(_optImageView);
    }];
}

- (void)tapProtocol:(UIGestureRecognizer*)recognizer {
    RWLog(@"付费协议");
}

@end
