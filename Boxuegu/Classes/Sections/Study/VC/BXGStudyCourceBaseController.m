//
//  BXGStudyCourceBaseController.m
//  Boxuegu
//
//  Created by HM on 2017/4/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudyCourceBaseController.h"

@interface BXGStudyCourceBaseController ()

@end

@implementation BXGStudyCourceBaseController



- (void)installMaskUI{


    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"OVERLAY#F7D80A50-55AA-471C-AAD4-F34468379C66"]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(108);
    }];
    
    
    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    [label sizeToFit];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(imageView.mas_bottom).offset(3);
    }];
    
    label.text = @"您还没有的“职业课程学习计划”\n马上去官网选择！";
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont bxg_fontRegularWithSize:15];
    label.textColor = [UIColor colorWithHex:0x333333];
    // self.view add
}




@end
