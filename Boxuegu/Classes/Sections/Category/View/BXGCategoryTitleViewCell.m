//
//  BXGCategoryTitleViewCell.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/17.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCategoryTitleViewCell.h"

@interface BXGCategoryTitleViewCell()
@property (nonatomic, weak) UILabel *label;
@end

@implementation BXGCategoryTitleViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        self.backgroundColor = [UIColor grayColor];
        [self installUI];
    }
    
    return self;
}

- (void)installUI {
    
    self.backgroundColor = [UIColor whiteColor];
    //    self.label.textColor = [UIColor yellowColor];
    UILabel *label = [UILabel new];
    label.font = [UIFont bxg_fontRegularWithSize:15];
    label.textColor = [UIColor colorWithHex:0x333333];
    label.text = @"Java";
    [self addSubview:label];
    self.label = label;
    label.bounds = CGRectMake(0, 0, 10, 10);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.right.offset(-5);
        make.centerY.offset(0);
    }];
    label.textAlignment = NSTextAlignmentCenter;
    
}

- (void)setTabTitleString:(NSString *)tabTitleString {
    
    _tabTitleString = tabTitleString;
    self.label.text = tabTitleString;
    //    [self.label sizeToFit];
}

- (void)setIsTabSelected:(BOOL)isTabSelected {
    
    _isTabSelected = isTabSelected;
    if(isTabSelected) {
        
        self.label.textColor = [UIColor colorWithHex:0x38ADFF];
        self.backgroundColor = [UIColor whiteColor];
        
    }else {
        
        self.label.textColor = [UIColor colorWithHex:0x333333];
        self.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    }
}
@end
