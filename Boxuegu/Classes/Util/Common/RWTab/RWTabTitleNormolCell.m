//
//  RWTabTitleNormolCell.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "RWTabTitleNormolCell.h"
@interface RWTabTitleNormolCell()
@property (nonatomic, weak) UILabel *label;
@end
@implementation RWTabTitleNormolCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self installUI];
    }
    return self;
}

- (void)installUI {
    UILabel *label = [UILabel new];
    label.font = [UIFont bxg_fontRegularWithSize:15];
    label.textColor = [UIColor colorWithHex:0x999999];
    self.label = label;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        //        make.left.right.offset(0);
        make.centerY.equalTo(self);
    }];
}

- (void)setTabTitleString:(NSString *)tabTitleString {
    
    self.label.text = tabTitleString;
}

- (void)setIsTabSelected:(BOOL)isTabSelected {
    
    if(isTabSelected){
        
        self.label.textColor = [UIColor colorWithHex:0x38ADFF];
    }else {
        
        self.label.textColor = [UIColor colorWithHex:0x999999];
    }
}

@end
