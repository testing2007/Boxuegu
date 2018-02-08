//
//  BXGUserLogoView.m
//  Boxuegu
//
//  Created by HM on 2017/4/27.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGUserLogoView.h"

@implementation BXGUserLogoView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
        [self installUI];
    }
    return self;
}

- (void)installUI {

    // logoImageView
    UIImageView *logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"全聚星logo"]];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(80);
        make.centerX.offset(0);
        make.width.height.offset(90);
    }];
    
    // textlogoImageView
    UIImageView *textlogoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"全聚星文字logo"]];
    textlogoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:textlogoImageView];
    [textlogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImageView.mas_bottom).offset(10);
        make.centerX.offset(0);
        make.width.offset(100);
        make.height.offset(50);
    }];
}
@end
