//
//  RWBadgeView.m
//  RWBadgeView
//
//  Created by RW on 2017/6/16.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "RWBadgeView.h"

@implementation UITabBar (BadgeView)

- (void)showBadgeOnItemIndex:(int)index{
    
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 4;
    
    badgeView.backgroundColor = [UIColor colorWithHex:0xFF554C];
    CGRect tabFrame = self.frame;
    
    
    //确定小红点的位置
    float percentX = (index +0.55) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(5);
    badgeView.frame = CGRectMake(x, y, 8, 8);
    [self addSubview:badgeView];
    
}

- (void)hideBadgeOnItemIndex:(int)index{
    
    //移除小红点
    [self removeBadgeOnItemIndex:index];
    
}

- (void)removeBadgeOnItemIndex:(int)index{
    
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        
        if (subView.tag == 888+index) {
            
            [subView removeFromSuperview];
            
        }
    }
}
@end

@interface RWBadgeView()
@property (nonatomic, weak) UILabel *badgeLabel;
@property (nonatomic, weak) UIView *bgView;
@end

@implementation RWBadgeView
@synthesize badgeFontSize = _badgeFontSize;

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        
        [self installUI];
    }
    return self;
}

- (void)awakeFromNib {

    [super awakeFromNib];
    [self installUI];
}

- (void)setBadgeNumber:(NSInteger )badgeNumber {
    
    _badgeNumber = badgeNumber;
    if(badgeNumber <= 0){
        
        self.bgView.hidden = true;
        self.badgeLabel.hidden = true;
    }else {
        self.bgView.hidden = false;
        self.badgeLabel.hidden = false;
        
        if(badgeNumber >= 99){
            
            self.badgeLabel.text = @"99+";
        }else {
            
            self.badgeLabel.text = @(badgeNumber).description;
        }
    }
}

-(NSInteger)badgeFontSize
{
    if(_badgeFontSize==0)
    {
        _badgeFontSize = 13;
    }
    return _badgeFontSize;
}
-(void)setBadgeFontSize:(NSInteger)newBadgeFontSize
{
    if(_badgeFontSize != newBadgeFontSize)
    {
        NSLog(@"%ld", _badgeFontSize);
        _badgeFontSize = newBadgeFontSize;
        [UIFont bxg_fontRegularWithSize:_badgeFontSize];
        self.badgeLabel.font = [UIFont bxg_fontRegularWithSize:_badgeFontSize];
        self.badgeLabel.text = @" ";
        [self.badgeLabel sizeToFit];
        self.badgeLabel.text = @"";
        _bgView.layer.cornerRadius = _badgeLabel.frame.size.height / 2.0;
        [self layoutSubviews];
    }
}

- (void)installUI{
    UILabel *badgeLabel = [UILabel new];
    badgeLabel.text = @" ";
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.font = [UIFont bxg_fontRegularWithSize:self.badgeFontSize];
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor colorWithHex:0xFF554C];
    [self addSubview:bgView];
    [self addSubview:badgeLabel];
    
    [badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(badgeLabel.mas_width);
        make.height.equalTo(badgeLabel.mas_height);
        make.center.equalTo(self);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(badgeLabel.mas_width).offset(5);
        make.width.greaterThanOrEqualTo(badgeLabel.mas_height);
        make.height.equalTo(badgeLabel.mas_height);
        
        make.center.equalTo(badgeLabel);
    }];
    [badgeLabel sizeToFit];
    badgeLabel.text = @"";
    bgView.layer.cornerRadius = badgeLabel.frame.size.height / 2.0;
    [bgView.layer masksToBounds];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(self);
    }];
    
    self.bgView = bgView;
    self.badgeLabel = badgeLabel;
}
@end
