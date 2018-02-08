//
//  BXGAcceptProtocolView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGAcceptProtocolView.h"

@implementation BXGAcceptProtocolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        [self installUI];
    }
    return self;
}

- (void)installUI {
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.userInteractionEnabled = true;
    [self addSubview:imageView];
    UITapGestureRecognizer *tapOption = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOption:)];
    [imageView addGestureRecognizer:tapOption];
    self.imageView = imageView;
    self.selected = true;
    
    UILabel *readedLabel = [UILabel new];
    [readedLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [readedLabel setFont:[UIFont bxg_fontRegularWithSize:12]];
    readedLabel.text = @"我已阅读并同意";
    [self addSubview:readedLabel];
    _readedLabel = readedLabel;
    
    UILabel *linkProtocolLabel = [UILabel new];
    [linkProtocolLabel setTextColor:[UIColor colorWithHex:0x666666]];
    [linkProtocolLabel setFont:[UIFont bxg_fontRegularWithSize:12]];
    //    linkProtocolLabel.text = @"<<博学谷用户付费协议>>";
    [self addSubview:linkProtocolLabel];
    _linkProtocolLabel = linkProtocolLabel;
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    tap.numberOfTapsRequired = 1;
    [tap addTarget:self action:@selector(tapProtocol:)];
    [_linkProtocolLabel addGestureRecognizer:tap];
    _linkProtocolLabel.userInteractionEnabled = YES;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(self);
        make.width.equalTo(@19);
        make.height.equalTo(@19);
    }];
    
    [_readedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView);
        make.left.equalTo(imageView.mas_right).offset(12);
    }];
    
    [_linkProtocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_readedLabel.mas_right).offset(5);
        make.centerY.equalTo(imageView);
    }];
}
- (void)setProtocolName:(NSString *)protocolName {
    _protocolName = protocolName;
    if(protocolName){
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"《%@》",protocolName]];
        NSRange contentRange = {0,[content length]};
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        self.linkProtocolLabel.attributedText = content;
    }
}

- (void)tapProtocol:(UITapGestureRecognizer*)recognizer {
    if(_readProtocolBlock) {
        _readProtocolBlock();
    }
}

- (void)tapOption:(UITapGestureRecognizer*)recognizer {
    self.selected = !self.selected;
    if(_selectedBlock) {
        _selectedBlock(self.selected);
    }
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if(_selected) {
        self.imageView.image = [UIImage imageNamed:@"多选-选中"];
    }else {
        self.imageView.image = [UIImage imageNamed:@"多选-未选中"];
    }
}
@end
