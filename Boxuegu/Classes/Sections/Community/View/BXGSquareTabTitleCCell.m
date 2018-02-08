//
//  BXGSquareTabTitleCCell.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSquareTabTitleCCell.h"

@interface BXGSquareTabTitleCCell()
@property (nonatomic, strong) UILabel *cellTitleLabel;
@property (nonatomic, weak) UIView *arrow;
@end

@implementation BXGSquareTabTitleCCell
- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
    
        [self installUI];
    }
    return self;
}

- (void)setCellTitle:(NSString *)cellTitle {
    
    if(cellTitle && cellTitle != _cellTitle) {
    
        self.cellTitleLabel.text = cellTitle;
    }
    _cellTitle = cellTitle;
}
- (void)installUI {

    // self.backgroundColor = [UIColor randomColor];
    
    // *** Title
    UILabel *label = [UILabel new];
    [self.contentView addSubview:label];
    self.cellTitleLabel = label;
    label.font = [UIFont bxg_fontRegularWithSize:15];
    label.textColor = [UIColor colorWithHex:0x999999];
    // label.text = @"热门";
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.offset(0);
//        make.centerX.offset(0);
         make.left.offset(5);
         make.right.offset(-5);
    }];
    
    // *** Arrow
    
    
    UIView *arrow = [UIView new];
    [self.contentView addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        // make.left.right.bottom.offset(0);
        make.bottom.offset(0);
        make.centerX.offset(0);
        make.width.equalTo(label.mas_width);
        make.height.offset(3);
    }];
    arrow.layer.cornerRadius = 3 / 2.0;
    arrow.layer.masksToBounds = true;
    arrow.backgroundColor = [UIColor colorWithHex:0x38ADFF];
    arrow.hidden = true;
    self.arrow = arrow;
    // 被选择
//    font-family: PingFangSC-Regular;
//    font-size: 30px;
//    color: #38ADFF;
//    letter-spacing: 0;
//    line-height: 30px;
    
    // 未选择
//    font-family: PingFangSC-Regular;
//    font-size: 30px;
//    color: #999999;
//    letter-spacing: 0;
//    line-height: 30px;
}
- (void)setIsActive:(BOOL)isActive {
    
    _isActive = isActive;
    if(isActive){
        
        self.cellTitleLabel.textColor = [UIColor colorWithHex:0x38ADFF];
        self.arrow.hidden = false;
    }else {
        
        self.cellTitleLabel.textColor = [UIColor colorWithHex:0x999999];
        self.arrow.hidden = true;
    }
}

//- (void)setSelected:(BOOL)selected {
//
//    [super setSelected:selected];
//    if(selected){
//    
//        self.cellTitleLabel.textColor = [UIColor colorWithHex:0x38ADFF];
//        self.arrow.hidden = false;
//    }else {
//    
//        self.cellTitleLabel.textColor = [UIColor colorWithHex:0x999999];
//        self.arrow.hidden = true;
//    }
//}
@end
