//
//  BXGOrderPayResultOrderFailedCell.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/26.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderPayResultOrderFailedCell.h"

@implementation BXGOrderPayResultOrderFailedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-22);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
