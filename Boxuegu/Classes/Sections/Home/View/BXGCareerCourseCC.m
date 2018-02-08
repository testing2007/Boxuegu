//
//  BXGCareerCourseCC.m
//  CollectionViewPrj
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "BXGCareerCourseCC.h"
#import "BXGHomeCourseModel.h"

@interface BXGCareerCourseCC()
@end

@implementation BXGCareerCourseCC
-(instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
        [self installUI];
    }
    return self;
}

-(void)installUI {
    UIImageView *courseImageView = [UIImageView new];
    courseImageView.layer.cornerRadius = 4;
    courseImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:courseImageView];
    _courseImageView = courseImageView;

    UILabel *courseNameLabel = [UILabel new];
    self.courseNameLabel = courseNameLabel;
    [self.contentView addSubview:courseNameLabel];
    _courseNameLabel.font = [UIFont bxg_fontRegularWithSize:15];
    _courseNameLabel.textColor = [UIColor colorWithHex:0x333333];
    
    UILabel *descLabel = [UILabel new];
    self.descLabel = descLabel;
    [self.contentView addSubview:descLabel];
    _descLabel.numberOfLines = 2;
    _descLabel.font = [UIFont bxg_fontRegularWithSize:12];
    _descLabel.textColor = [UIColor colorWithHex:0x999999];

    UILabel *learndCountLabel = [UILabel new];
    self.learndCountLabel = learndCountLabel;
    [self.contentView addSubview:learndCountLabel];
    _learndCountLabel.font = [UIFont bxg_fontRegularWithSize:12];
    _learndCountLabel.textColor = [UIColor colorWithHex:0x666666];

    UILabel *currentPriceLabel = [UILabel new];
    self.currentPriceLabel = currentPriceLabel;
    [self.contentView addSubview:currentPriceLabel];
    _currentPriceLabel.textAlignment = NSTextAlignmentRight;
    _currentPriceLabel.font = [UIFont bxg_fontRegularWithSize:16];
    _currentPriceLabel.textColor = [UIColor colorWithHex:0xFF554C];
    [_courseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(15);
//        make.width.equalTo(@165);
//        make.height.equalTo(@93);
        make.width.equalTo(_courseImageView.mas_height).multipliedBy(165.0/93.0);
        make.bottom.offset(-20);
    }];
    
    [_courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_courseImageView.mas_top).offset(0);
        make.left.equalTo(_courseImageView.mas_right).offset(10);
        make.right.offset(-15);
        make.height.equalTo(@17);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_courseNameLabel.mas_bottom).offset(IS_IPHONE_5?5:10);
        make.left.equalTo(_courseNameLabel.mas_left);
        make.right.equalTo(_courseNameLabel.mas_right);
    }];

    [_learndCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_courseImageView.mas_bottom);
        make.left.equalTo(_descLabel.mas_left);
        make.height.equalTo(@12);
    }];

    [_currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_descLabel.mas_right);
        make.bottom.equalTo(_learndCountLabel.mas_bottom);
        make.height.equalTo(@12);
    }];
}

-(void)setModel:(BXGHomeCourseModel*)model {
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:model.courseImg] placeholderImage:[UIImage imageNamed:@"默认加载图"]];
    self.courseNameLabel.text = model.courseName;
    self.descLabel.text = model.des;
    self.learndCountLabel.text = [NSString stringWithFormat:@"%ld人学习", [model.learndCount longValue]];
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%.2lf", [model.currentPrice floatValue]];
}

@end
