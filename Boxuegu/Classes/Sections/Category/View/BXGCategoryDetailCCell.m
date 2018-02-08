//
//  BXGCategoryDetailCCell.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/17.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCategoryDetailCCell.h"

@interface BXGCategoryDetailCCell()
@property (nonatomic, weak) UILabel *tagLabel;
@end
@implementation BXGCategoryDetailCCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectZero];
    if(self) {
        [self installUI];
    }
    return self;
}

- (void)setTagTitle:(NSString *)tagTitle {
    _tagTitle = tagTitle;
    if(tagTitle) {
    
        self.tagLabel.text = tagTitle;
    }else {
        self.tagLabel.text = @"";
    }
    
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if(selected) {
        self.backgroundColor = [UIColor themeColor];
        self.tagLabel.textColor = [UIColor whiteColor];
    }else {
        self.backgroundColor = [UIColor colorWithHex:0xF0F2F5];
        self.tagLabel.textColor = [UIColor colorWithHex:0x333333];
    }
}

//- (void)setHighlighted:(BOOL)highlighted {
//    [super setHighlighted:highlighted];
//    if(highlighted) {
//        self.backgroundColor = [UIColor themeColor];
//        self.tagLabel.textColor  = [UIColor whiteColor];
//    }else {
//        self.backgroundColor = [UIColor colorWithHex:0xF0F2F5];
//        self.tagLabel.textColor = [UIColor colorWithHex:0x333333];
//    }
//}

- (void)installUI {
    
    UILabel *label = [UILabel new];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = true;
    [self.contentView addSubview:label];
    self.tagLabel = label;
//    [string appendString:@"Java"];
//    label.text = string;

    label.font = [UIFont bxg_fontRegularWithSize:13];
    label.textColor = [UIColor colorWithHex:0x333333];
    label.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor colorWithHex:0xF0F2F5];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.greaterThanOrEqualTo(@30);
        
        make.left.offset(15);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.offset(-15);
        make.height.offset(30);
        make.width.lessThanOrEqualTo(@150);
    }];
}
@end
