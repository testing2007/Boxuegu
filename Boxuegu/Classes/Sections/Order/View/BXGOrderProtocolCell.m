//
//  BXGOrderProtocolCell.m
//  Boxuegu
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderProtocolCell.h"

@implementation BXGOrderProtocolCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self installUI];
    }
    return self;
}

- (void)installUI {
    OptionImageView *optImageView = [[OptionImageView alloc] initIsSel:YES andSelBlock:nil andUnselBlock:nil];
    [self.contentView addSubview:optImageView];
    self.optImageView = optImageView;
    
    UILabel *readedLabel = [UILabel new];
    [readedLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [readedLabel setFont:[UIFont bxg_fontRegularWithSize:12]];
    readedLabel.text = @"我已阅读并同意";
    [self.contentView addSubview:readedLabel];
    _readedLabel = readedLabel;
    
    UILabel *linkProtocolLabel = [UILabel new];
    [linkProtocolLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [linkProtocolLabel setFont:[UIFont bxg_fontRegularWithSize:12]];
//    linkProtocolLabel.text = @"<<博学谷用户付费协议>>";
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"《博学谷用户付费协议》"]];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    linkProtocolLabel.attributedText = content;
    [self.contentView addSubview:linkProtocolLabel];
    _linkProtocolLabel = linkProtocolLabel;
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    tap.numberOfTapsRequired = 1;
    [tap addTarget:self action:@selector(tapProtocol:)];
    [_linkProtocolLabel addGestureRecognizer:tap];
    _linkProtocolLabel.userInteractionEnabled = YES;
    
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
    if(_readProtocolBlock) {
        _readProtocolBlock();
    }
}

@end
