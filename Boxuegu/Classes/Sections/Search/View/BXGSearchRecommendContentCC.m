//
//  BXGSearchRecommendContentCC.m
//  Boxuegu
//
//  Created by apple on 2017/12/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSearchRecommendContentCC.h"

@implementation BXGSearchRecommendContentCC

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
        [self installUI];
    }
    return self;
}

-(void)installUI {
    UILabel *label = [UILabel new];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = true;
    [self.contentView addSubview:label];
    self.contentLabel = label;
    
    label.font = [UIFont bxg_fontRegularWithSize:13];
    label.textColor = [UIColor colorWithHex:0x333333];
    label.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor colorWithHex:0xF0F2F5];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.offset(-15);
        make.height.equalTo(@30);
        make.width.lessThanOrEqualTo(@150);
    }];
}

@end
