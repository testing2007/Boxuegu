//
//  BXGConstureOnAirImageView.m
//  Boxuegu
//
//  Created by wurenying on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGConstureOnAirImageView.h"

@interface BXGConstureOnAirImageView()
@property (nonatomic, strong) UIImageView *onAirImageView;
@property (nonatomic, strong) UILabel *onAirLabel;
@end
@implementation BXGConstureOnAirImageView

- (UILabel *)onAirLabel {
    
    if(_onAirLabel == nil) {
        
        _onAirLabel = [UILabel new];
        _onAirLabel.font = [UIFont bxg_fontRegularWithSize:12];
        _onAirLabel.textColor = [UIColor themeColor];
        _onAirLabel.text = @"正在直播";
    }
    return _onAirLabel;
}

- (void)hide {
    [self.onAirImageView removeFromSuperview];
    self.onAirImageView = nil;
    self.hidden = true;
}

- (void)show {
    
    [self.onAirImageView removeFromSuperview];
    self.onAirImageView = nil;
//    self.onAirImageView.image = nil;
    self.hidden = false;
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSInteger i = 0; i < 8; i++) {
        
        NSString* imageName = [NSString stringWithFormat:@"onair_img_%02zd",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [arrM addObject:image];
    }
    UIImage *anmiationImage = [UIImage animatedImageWithImages: arrM duration:arrM.count * 0.1];
    [self.onAirImageView setImage:anmiationImage];
    
    [self addSubview:self.onAirImageView];
    [self.onAirImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
        make.width.height.offset(11);
        make.left.equalTo(self.onAirLabel.mas_right).offset(1);
    }];
    
    
}

- (UIImageView *)onAirImageView {
    
    if(_onAirImageView == nil) {
        
        _onAirImageView = [UIImageView new];

    }
    return _onAirImageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self installUI];
    }
    return self;
}

- (void)installUI {
    
    UILabel *onAirLabel = self.onAirLabel;
    [self addSubview:onAirLabel];
    [onAirLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.centerY.offset(0);
    }];
    
    UIImageView *onAirImageView = self.onAirImageView;
    [self addSubview:onAirImageView];
    [onAirImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
        make.width.height.offset(12);
        make.left.equalTo(onAirLabel.mas_right).offset(1);
    }];
}

@end
