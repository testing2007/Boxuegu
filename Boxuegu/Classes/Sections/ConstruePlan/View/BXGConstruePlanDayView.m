//
//  BXGConstruePlanDayView.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGConstruePlanDayView.h"
#import "BXGConstruePlanDayCell.h"
#import "BXGConstruePlanDayModel.h"

#define kBXGConstruePlanDayCellId @"BXGConstruePlanDayCell"

@interface BXGConstruePlanDayView() <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *headerDateLabel;
@end

@implementation BXGConstruePlanDayView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        [self installUI];
    }
    return self;
}

- (void)installUI {
    
    UIView *headerView = self.headerView;
    [self addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(0);
        make.height.offset(34);
    }];
    
    UITableView *contentView = self.contentView;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(headerView.mas_bottom);
        make.bottom.offset(0);
    }];
}

#pragma mark - getter setter

- (void)setModelArray:(NSArray<BXGConstruePlanDayModel *> *)modelArray {
    
    _modelArray = modelArray;
    [self.contentView reloadData];
}

- (void)setDate:(NSDate *)date {
    
    _date = date;
    if(_date) {
       self.headerDateLabel.text = [_date converDateStringToFormat:@"yyyy年M月d日 EEEE"];
    }
}

#pragma mark - ui

- (UIView *)headerView {
    
    if(_headerView == nil) {
        
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        // 休息
        UILabel *secondTagTitleLabel = [UILabel new];
        [_headerView addSubview:secondTagTitleLabel];
        secondTagTitleLabel.text = @"休息";
        secondTagTitleLabel.font = [UIFont bxg_fontRegularWithSize:15];
        secondTagTitleLabel.textColor = [UIColor colorWithHex:0x333333];
        
        [secondTagTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.centerY.offset(0);
        }];
        
        [secondTagTitleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        UIView *greenCircularView = [UIView new];
        [_headerView addSubview:greenCircularView];
        greenCircularView.backgroundColor = [UIColor colorWithHex:0x50E3C2];
        [greenCircularView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(secondTagTitleLabel.mas_left).offset(-5);
            make.width.height.offset(10);
            make.centerY.offset(0);
        }];
        
        [greenCircularView layoutIfNeeded];
        greenCircularView.layer.cornerRadius = greenCircularView.bounds.size.height * 0.5;
        
        // 直播
        UILabel *firstTagTitleLabel = [UILabel new];
        [_headerView addSubview:firstTagTitleLabel];
        firstTagTitleLabel.text = @"直播";
        firstTagTitleLabel.font = [UIFont bxg_fontRegularWithSize:15];
        firstTagTitleLabel.textColor = [UIColor colorWithHex:0x333333];
        
        [firstTagTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(greenCircularView.mas_left).offset(-30);
            make.centerY.offset(0);
        }];
        [firstTagTitleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        // 红色
        UIView *redCircularView = [UIView new];
        [_headerView addSubview:redCircularView];
        redCircularView.backgroundColor = [UIColor colorWithHex:0xFF554C];
        [redCircularView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(firstTagTitleLabel.mas_left).offset(-5);
            make.width.height.offset(10);
            make.centerY.offset(0);
        }];
        
        [redCircularView layoutIfNeeded];
        redCircularView.layer.cornerRadius = greenCircularView.bounds.size.height * 0.5;
        
        UILabel *dateLabel = self.headerDateLabel;
        [_headerView addSubview:dateLabel];
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.centerY.offset(0);
            make.right.equalTo(redCircularView).offset(-15);
        }];
    }
    return _headerView;
}

- (UILabel *)headerDateLabel {

    if(_headerDateLabel == nil) {
        _headerDateLabel = [UILabel new];
        _headerDateLabel.font = [UIFont bxg_fontRegularWithSize:15];
    }
    return _headerDateLabel;
}

- (UITableView *)contentView {
    
    if(_contentView == nil) {
        _contentView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.rowHeight = UITableViewAutomaticDimension;
        _contentView.estimatedRowHeight = 200;
        [_contentView registerClass:[BXGConstruePlanDayCell class] forCellReuseIdentifier:kBXGConstruePlanDayCellId];
        _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _panGestureRecognizer = _contentView.panGestureRecognizer;
    }
    return _contentView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.modelArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BXGConstruePlanDayCell *cell = [tableView dequeueReusableCellWithIdentifier:kBXGConstruePlanDayCellId forIndexPath:indexPath];
    [cell setModel:self.modelArray[indexPath.row] andIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BXGConstruePlanDayModel *model = self.modelArray[indexPath.row];
    NSString *planId = model.idx;
    if(self.onClickPlanBlock) {
        self.onClickPlanBlock(planId);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    BOOL isTop = false;
    if(scrollView.contentOffset.y < 0) {
        isTop = true;
        if(self.onScrollToTopBlock){
            self.onScrollToTopBlock(isTop);
        }
    }
    if(scrollView.contentOffset.y > 0) {
        isTop = false;
        if(self.onScrollToTopBlock){
            self.onScrollToTopBlock(isTop);
        }
    }
}

@end
