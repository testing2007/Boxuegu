//
//  BXGMiniCalendarView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/26.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMiniCalendarView.h"
#import "BXGDateTool.h"

@interface BXGMiniCalendarView()

@property (nonatomic, weak) UILabel *monthLabel;
@property (nonatomic, weak) UILabel *yearLabel;
@end


@implementation BXGMiniCalendarView
@synthesize currentDate = _currentDate;
- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if(self) {
        
        [self installUI];
    }
    
    return self;
}

- (NSDate *)currentDate {

    if(!_currentDate) {
    
        _currentDate = [NSDate new];
    }
    return _currentDate;
}

- (void)setCurrentDate:(NSDate *)currentDate {

    __weak typeof (self) weakSelf = self;
    if(!currentDate) {
    
        _currentDate = [NSDate new];
    }
    _currentDate = currentDate;
    
    if(weakSelf.dateDidChangeBlock) {
    
        weakSelf.dateDidChangeBlock(_currentDate);
    }
    
    NSDateComponents *components = [[BXGDateTool share] dateComponentsForDate:currentDate];
    self.yearLabel.text = @(components.year).description;
    self.monthLabel.text = [@(components.month).description stringByAppendingString:@"月"];
}

- (void)installUI {
    
    UILabel *monthLabel = [UILabel new];
    [self addSubview:monthLabel];
    monthLabel.font = [UIFont bxg_fontRegularWithSize:20];
    monthLabel.textColor = [UIColor colorWithHex:0x333333];
    monthLabel.text = @"04月";
    self.monthLabel = monthLabel;
    UILabel *yearLabel = [UILabel new];
    [self addSubview:yearLabel];
    yearLabel.font = [UIFont bxg_fontRegularWithSize:11];
    yearLabel.textColor = [UIColor colorWithHex:0x666666];
    yearLabel.text = @"2017";
    self.yearLabel = yearLabel;
    UIButton *leftBtn = [UIButton new];
    [self addSubview:leftBtn];
    [leftBtn setImage:[UIImage imageNamed:@"学习中心-日历-左"] forState:UIControlStateNormal];
    // size 18 rect
    [leftBtn addTarget:self action:@selector(clickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightBtn = [UIButton new];
    [self addSubview:rightBtn];
    
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"学习中心-日历-右"] forState:UIControlStateNormal];
    // size 18 rect
    UIButton *centerBtn = [UIButton new];
    [self addSubview:centerBtn];
    [centerBtn addTarget:self action:@selector(clickCenterBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    // 约束学习中心-日历-
    
    [monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_centerX).offset(6);
        make.bottom.offset(0);
    }];
    
    [yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_centerX).offset(6);
        make.bottom.offset(0);
    }];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(0);
        make.bottom.offset(0);
        make.width.height.offset(19);
        
    }];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.offset(0);
        make.bottom.offset(0);
        make.width.height.offset(19);
    }];
    
    [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.offset(0);
        make.left.equalTo(leftBtn.mas_right);
        make.right.equalTo(rightBtn.mas_left);
    }];
    
}
- (void)clickLeftBtn:(UIButton *)sender {

    __weak typeof (self) weakSelf = self;
    weakSelf.currentDate = [[BXGDateTool share] dateForLastMonthWithDate:weakSelf.currentDate];
    if(self.clickLeftBtnBlock){
    
        self.clickLeftBtnBlock(weakSelf.currentDate);
    }
}

- (void)clickRightBtn:(UIButton *)sender {
    
    __weak typeof (self) weakSelf = self;
    
    weakSelf.currentDate = [[BXGDateTool share] dateForNextMonthWithDate:weakSelf.currentDate];
    
    
    if(self.clickRightBtnBlock){
        
        self.clickRightBtnBlock(weakSelf.currentDate);
    }
    
    
}

- (void)clickCenterBtn:(UIButton *)sender {
    
    __weak typeof (self) weakSelf = self;
    
    
    if(self.clickCenterBtnBlock){
        
        self.clickCenterBtnBlock(weakSelf.currentDate);
    }
    
    
}



@end
