//
//  BXGMiniCourseCC.m
//  CollectionViewPrj
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "BXGMiniCourseCC.h"

@implementation BXGMiniCourseCC
-(instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self installUI];
    }
    return self;
}

-(void)installUI {
    UIImageView *thumbImageView = [UIImageView new];
    [self.contentView addSubview:thumbImageView];
    _thumbImageView = thumbImageView;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLable = titleLabel;
    [self.contentView addSubview:_titleLable];
    _titleLable.textColor = [UIColor blackColor];
    
    [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH/2-15-7.5);
        make.height.mas_equalTo(30);
    }];
    
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_thumbImageView.mas_bottom).offset(5);
        make.left.equalTo(_thumbImageView.mas_left);
    }];
}

-(void)setIndex:(NSInteger)index {
    if(index%2==1) {
        [_thumbImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(7.5);
        }];
    } else{
        [_thumbImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
        }];
    }
}
@end
