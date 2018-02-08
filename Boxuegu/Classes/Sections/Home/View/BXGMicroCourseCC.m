//
//  BXGMicroCourseCC.m
//  CollectionViewPrj
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 itheima. All rights reserved.
//

#import "BXGMicroCourseCC.h"
#import "BXGHomeCourseModel.h"

@implementation BXGMicroCourseCC
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
        
    UILabel *learndCountLabel = [UILabel new];
    self.learndCountLabel = learndCountLabel;
    [self.contentView addSubview:learndCountLabel];
    _learndCountLabel.font = [UIFont bxg_fontRegularWithSize:12];
    _learndCountLabel.textColor = [UIColor colorWithHex:0x666666];
    
    UILabel *currentPriceLabel = [UILabel new];
    self.currentPriceLabel = currentPriceLabel;
    [self.contentView addSubview:currentPriceLabel];
    _currentPriceLabel.textAlignment = NSTextAlignmentRight;
    _currentPriceLabel.font = [UIFont bxg_fontRegularWithSize:14];
    _currentPriceLabel.textColor = [UIColor colorWithHex:0xFF554C];
    
    [_courseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(15);
        make.width.equalTo([NSNumber numberWithFloat:(SCREEN_WIDTH)/2.0-15-7.5]);
//        make.height.equalTo(@93);
//        make.bottom.offset(-20);
        make.height.equalTo(_courseImageView.mas_width).multipliedBy(93.0/165.0);
    }];
    
    [_courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_courseImageView.mas_bottom).offset(6);
        make.left.equalTo(_courseImageView.mas_left).offset(0);
        make.right.equalTo(_courseImageView.mas_right);
        make.height.equalTo(@14);
    }];
    
    [_learndCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_courseNameLabel.mas_bottom).offset(5);
        make.left.equalTo(_courseNameLabel.mas_left);
        make.height.equalTo(@12);
    }];
    
    [_currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_courseImageView.mas_right);
        make.top.equalTo(_courseNameLabel.mas_bottom).offset(3);
        make.bottom.equalTo(_learndCountLabel.mas_bottom);
        make.height.equalTo(@14);
    }];
}

-(void)setModel:(BXGHomeCourseModel*)model andIndex:(NSInteger)index {
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:model.courseImg] placeholderImage:[UIImage imageNamed:@"默认加载图"]];
    self.courseNameLabel.text = model.courseName;
    self.learndCountLabel.text = [NSString stringWithFormat:@"%ld人学习", [model.learndCount longValue]];
    if(model.isFree.integerValue==1 && model.courseType.integerValue==1) {
        self.currentPriceLabel.text = @"免费";//免费微课
    } else {
        //精品微课
        self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%0.2f", [model.currentPrice floatValue]];
    }
    
    if(index%2==1) {
        [_courseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(7.5);
        }];
    } else{
        [_courseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
        }];
    }
}

@end
