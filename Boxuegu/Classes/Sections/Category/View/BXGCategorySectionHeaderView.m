//
//  BXGCategorySectionHeaderView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/17.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCategorySectionHeaderView.h"
@interface BXGCategorySectionHeaderView()
@property (nonatomic, weak) UILabel *label;
@end
@implementation BXGCategorySectionHeaderView
- (void)setSectionTitle:(NSString *)sectionTitle {
    _sectionTitle = sectionTitle;
    self.label.text = sectionTitle;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectZero];
    if(self) {
        [self installUI];
    }
    return self;
}
- (void)installUI {
    
    self.backgroundColor = [UIColor whiteColor];
    UILabel *label = [UILabel new];
    //    /UIImageView *imageView = [UIImageView new];
    label.font = [UIFont bxg_fontRegularWithSize:15];
    label.textColor = [UIColor colorWithHex:0x333333];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(15);
        make.top.offset(0);
        make.bottom.offset(0);
        make.right.offset(-15);
    }];
    label.text = @"1231312131";
    //    font-family: PingFangSC-Regular;
    //    font-size: 30px;
    //color: #333333;
    //    line-height: 30px;
    self.label = label;
    //    imageView.backgroundColor = [UIColor brownColor];
}
@end
