//
//  BXGCategoryHeaderView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/17.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCategoryHeaderView.h"

@implementation BXGCategoryHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectZero];
    if(self) {
        [self installUI];
    }
    return self;
}
- (void)installUI {
    
    UIImageView *imageView = [UIImageView new];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(15);
        make.top.offset(10);
        make.bottom.offset(-10);
        make.right.offset(-15);
    }];
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = true;
//    imageView.backgroundColor = [UIColor blackColor];
    self.imageView = imageView;
}
@end
