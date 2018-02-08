//
//  BXGPlayerSelectRouteView.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/19.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGPlayerSelectRouteView.h"
#import "BXGLiveManager.h"
#import "BXGPlayerSelectRouteCell.h"

@interface BXGPlayerSelectRouteView() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BXGLiveManager *liveManager;
@end

@implementation BXGPlayerSelectRouteView

- (BXGLiveManager *)liveManager{
    
    if(_liveManager == nil) {
        
        _liveManager = [BXGLiveManager share];
    }
    return _liveManager;
}

- (UITableView *)tableView {
    
    if(_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 50;
        [_tableView registerClass:[BXGPlayerSelectRouteCell class] forCellReuseIdentifier:BXGPlayerSelectRouteCell.description];
        _tableView.allowsSelection = true;
        [_tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.1)]];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
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

- (void)installUI {
    

    self.backgroundColor = [UIColor colorWithHex:0x11161F alpha:0.9];

    UIButton *titleBtn = self.titleBtn;
    [titleBtn setTitle:@"线路" forState:UIControlStateNormal];
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
    }
    
    if(self.liveManager.channelCount > 0) {
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.liveManager.currentChannel inSection:0] animated:false scrollPosition:UITableViewScrollPositionNone];
    }
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.liveManager.channelCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BXGPlayerSelectRouteCell *cell = [tableView dequeueReusableCellWithIdentifier:BXGPlayerSelectRouteCell.description forIndexPath:indexPath];
    cell.routeNumber = indexPath.row + 1;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView selectRowAtIndexPath:indexPath animated:false scrollPosition:UITableViewScrollPositionNone];
    
    // 跳转太快添加选中效果
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.liveManager switchChannel:indexPath.row];
        if(self.didSelectedCell) {
            self.didSelectedCell(tableView,indexPath);
        }
    });
}

@end
