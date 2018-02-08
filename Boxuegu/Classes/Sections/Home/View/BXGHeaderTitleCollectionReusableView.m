//
//  BXGHeaderTitleCollectionReusableView.m
//  CollectionViewPrj
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "BXGHeaderTitleCollectionReusableView.h"

@implementation BXGHeaderTitleCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self installUI];
    }
    return self;
}

- (void)installUI {
    self.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
    
    UIView *markView = [UIView new];
    markView.backgroundColor = [UIColor redColor];
    [self addSubview:markView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor blackColor];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UIButton *moreButton  = [UIButton new];
    [self addSubview:moreButton];
    [moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [moreButton addTarget:self  action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    
    [markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.offset(15);
        make.top.offset(10);
        make.width.equalTo(@2);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(markView.mas_right).offset(5);
        make.centerY.equalTo(self);
    }];
    
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-8);
        make.centerY.equalTo(self);
    }];
}

- (void)more {
    NSAssert(_type!=UNKNOWN_COURSE_TYPE, @"type don't assign right value");
    RWLog(@"more is trigger");
}

@end
