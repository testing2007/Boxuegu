//
//  BXGSingleTagTitleView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSingleTagTitleView.h"

@interface  BXGSingleTagTitleView()

@end

@implementation  BXGSingleTagTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame]; {
        
        [self installUI];
    }
    return self;
}
- (void)setCellTitle:(NSString *)cellTitle {
    
    _cellTitle = cellTitle;
    self.cellTitleLabel.text = cellTitle;
}

- (void)installUI {
    
    self.backgroundColor = [UIColor whiteColor];
    UIView *markView = [UIView new];
    markView.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    markView.layer.cornerRadius = 1;
    
    [self addSubview: markView];
    [markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(2);
        make.height.offset(15);
        make.left.offset(15);
        make.centerY.offset(0);
        
    }];
    
    UILabel *cellTitleLabel = [UILabel new];
    self.cellTitleLabel = cellTitleLabel;
    cellTitleLabel.font = [UIFont bxg_fontRegularWithSize:16];
    cellTitleLabel.textColor = [UIColor colorWithHex:0x333333];
    [self addSubview: cellTitleLabel];
    
    [cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(markView).offset(5);
        make.centerY.offset(0);
        make.right.offset(-15);
        make.height.equalTo(self);
    }];
}

@end
