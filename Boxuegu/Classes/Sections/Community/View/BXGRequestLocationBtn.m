//
//  BXGRequestLocationBtn.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGRequestLocationBtn.h"


@interface BXGRequestLocationBtn()
@property (nonatomic, weak) UILabel *locationTitleLabel;
@end

@implementation BXGRequestLocationBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setStirng:(NSString *)stirng {

    _stirng = stirng;
    
    if(stirng) {
    
        self.locationTitleLabel.text = stirng;
        [self.locationTitleLabel sizeToFit];
        [self.locationTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.titleLabel.mas_height);
            make.width.equalTo(self.titleLabel.mas_width);
        }];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
        [self installUI];
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self installUI];
}

- (void)installUI {

    //    border-radius: 100px;
    
    self.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    self.layer.cornerRadius = 10;
//    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(80);
//        make.height.offset(21);
//        make.left.offset(15);
//        make.top.equalTo(seletedImageView.mas_bottom).offset(15);
//    }];
    
    
    UILabel *locationTitleLabel = [UILabel new];
    locationTitleLabel.text = @"开始定位";
    [self addSubview:locationTitleLabel];
    self.locationTitleLabel = locationTitleLabel;
    
    UIImageView *locationIconImageView = [UIImageView new];
    [locationIconImageView setImage:[UIImage imageNamed:@"学习圈-定位"]];
    [self addSubview:locationIconImageView];
    [locationTitleLabel sizeToFit];
    [locationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationIconImageView.mas_right);
        make.centerY.offset(0);
        make.height.equalTo(locationTitleLabel.mas_height);
        make.width.equalTo(locationTitleLabel.mas_width);
    }];
    
    locationTitleLabel.font = [UIFont bxg_fontRegularWithSize:12];
    locationTitleLabel.textColor = [UIColor colorWithHex:0x999999];
    // locationTitleLabel.font = [RWFont font]
    //    font-family: PingFangSC-Regular;
    //    font-size: 24px;
    //color: #;
    
    [locationIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(5);
        make.centerY.offset(0);
        make.width.offset(16);
        make.height.offset(16);
    }];
    
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.locationTitleLabel.mas_right).offset(10);
    }];
}
@end
