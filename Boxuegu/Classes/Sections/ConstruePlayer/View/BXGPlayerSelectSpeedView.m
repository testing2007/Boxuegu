//
//  BXGPlayerSelectSpeedView.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/16.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGPlayerSelectSpeedView.h"
#import "BXGVODPlayerRateCell.h"
#import "BXGPlayerManager.h"

//#import "BXGCourseOutlineVideoModel.h"

@interface BXGPlayerSelectSpeedView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSNumber *> *rateList;
@property (nonatomic, strong) BXGPlayerManager *playerManager;
@end
@implementation BXGPlayerSelectSpeedView

- (BXGPlayerManager *)playerManager {
    
    if(_playerManager == nil) {
        
        _playerManager = [BXGPlayerManager share];
    }
    return _playerManager;
}

- (NSArray<NSNumber *> *)rateList {
    
    if(_rateList == nil) {
        
        _rateList = @[@1.0,@1.25,@1.5,@1.75,@2.0];
    }
    return _rateList;
}

- (UITableView *)tableView {
    
    if(_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 50;
        [_tableView registerClass:[BXGVODPlayerRateCell class] forCellReuseIdentifier:BXGVODPlayerRateCell.description];
        _tableView.allowsSelection = true;
        [_tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.1)]];

    }
    return _tableView;
}

- (UIButton *)titleBtn {
    
    if(_titleBtn == nil) {
        
        _titleBtn = [UIButton new];
        _titleBtn.titleLabel.font = [UIFont bxg_fontSemiboldWithSize:13];
        [_titleBtn setTitleColor:[UIColor colorWithHex:0xcccccc] forState:UIControlStateNormal];
    }
    return _titleBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        [self installUI];
    }
    return self;
}

//self.leftPopViewTitleLabel = titleLabel;
//titleLabel.font = [UIFont bxg_fontSemiboldWithSize:13];
//titleLabel.textColor = [UIColor colorWithHex:0xcccccc];
//[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//    make.top.right.offset(0);
//    make.height.offset(43);
//    make.left.offset(15);
//}];


- (void)installUI {
    
    self.backgroundColor = [UIColor colorWithHex:0x11161F alpha:0.9];
    
    UIButton *titleBtn = self.titleBtn;
    [titleBtn setTitle:@"倍速" forState:UIControlStateNormal];
    [self addSubview:titleBtn];
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(0);
        make.height.offset(43);
        make.left.offset(15);
    }];
    
    UIView *spView = [UIView new];
    [self addSubview:spView];
    spView.backgroundColor = [UIColor colorWithHex:0xffffff];
    spView.alpha = 0.1;
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleBtn.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.height.offset(1);
    }];
    
    UITableView *tableView = self.tableView;
    
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spView.mas_bottom).offset(0);
        make.bottom.right.offset(0);
        make.left.offset(0);
    }];
    
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
    }
    
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.rateList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BXGVODPlayerRateCell *cell = [tableView dequeueReusableCellWithIdentifier:BXGVODPlayerRateCell.description forIndexPath:indexPath];
    
    cell.rate = self.rateList[indexPath.row];
    if(self.playerManager.rate == cell.rate.floatValue) {
        [tableView selectRowAtIndexPath:indexPath animated:true scrollPosition:UITableViewScrollPositionTop];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView selectRowAtIndexPath:indexPath animated:true scrollPosition:UITableViewScrollPositionTop];
    
    // 跳转太快添加选中效果
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.playerManager.rate = self.rateList[indexPath.row].floatValue;
    });
    
}

@end
