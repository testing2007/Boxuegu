//
//  BXGProgressView.m
//  Boxuegu
//
//  Created by apple on 2017/6/29.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGProgressView.h"

@interface BXGProgressView()
//@property(nonatomic, strong) UIView *leftView;
//@property(nonatomic, strong) UIView *rightView;
//@property(nonatomic, strong) UIColor *leftViewBgColor;
//@property(nonatomic, strong) UIColor *rightViewBgColor;
@end

@implementation BXGProgressView

//-(instancetype)init
//{
//    self = [super init];
//    if(self)
//    {
//        [self installUI];
//    }
//    return self;
//}
//
//-(void) installUI
//{
//    _leftView = [UIView new];
//    [self addSubview:_leftView];
//    _rightView = [UIView new];
//    [self addSubview:_rightView];
//}
//
//-(void)setLeftProgressColor:(UIColor*)leftColor
//{
//    _leftViewBgColor = leftColor;
//}
//
//-(void)setRightProgressColor:(UIColor*)rightColor
//{
//    _rightViewBgColor = rightColor;
//}
//
//-(void)setProgress:(CGFloat)progress
//{
//    if(progress<0)
//    {
//        _progress = 0;
//        _leftView.hidden = YES;
//        _rightView.hidden = NO;
//    }
//    else if(progress>1)
//    {
//        _progress = 1;
//        _leftView.hidden = NO;
//        _rightView.hidden = YES;
//    }
//    else
//    {
//        _leftView.hidden = NO;
//        _rightView.hidden = NO;
//    }
//    [_leftView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.top.bottom.offset(0);
//        make.right.offset(self.frame.size.width*progress);
//    }];
////    [_rightView mas_updateConstraints:^(MASConstraintMaker *make) {
////        make.right.top.bottom.offset(0);
////        make.left.equalTo(_leftView.);
////    }];
//}
//



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
