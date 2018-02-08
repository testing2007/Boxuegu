//
//  BXGPlayerSelectVideoView.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/16.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGPlayerSelectVideoView.h"

#import "BXGSelectionVideoCell.h"
#import "BXGCourseOutlineVideoModel.h"

@interface BXGPlayerSelectVideoView()

@property (nonatomic, strong) UIButton *titleBtn;

@end

@implementation BXGPlayerSelectVideoView

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    _delegate = delegate;
    
    self.tableView.delegate = delegate;
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    self.tableView.dataSource = dataSource;
}

- (UITableView *)tableView {
    
    if(_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
        
        
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 50;
        [_tableView registerClass:[BXGSelectionVideoCell class] forCellReuseIdentifier:@"BXGSelectionVideoCell"];
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
        [_titleBtn setTitle:@"选集" forState:UIControlStateNormal];
        _titleBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
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
    
    [self addSubview:_titleBtn];
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(0);
        make.height.offset(43);
        make.left.offset(15);
    }];
    
    UIButton *spView = [UIButton new];
    [self addSubview:spView];
    spView.backgroundColor = [UIColor colorWithHex:0xffffff];
    spView.alpha = 0.1;
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleBtn.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.height.offset(1);
    }];
    
    UITableView *selectVideoTableView = self.tableView;
    
    [self addSubview:selectVideoTableView];
    [selectVideoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spView.mas_bottom).offset(0);
        make.bottom.right.offset(0);
        make.left.offset(0);
    }];
    
    if (@available(iOS 11.0, *)) {
        selectVideoTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
    }
    
}
- (void)installPlayerSelectVideoTableView {
    __weak typeof (self) weakSelf = self;
    
    UITableView *selectVideoTableView = [UITableView new];
    selectVideoTableView.backgroundColor = [UIColor clearColor];
    selectVideoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    selectVideoTableView.rowHeight = 50;
    [selectVideoTableView registerClass:[BXGSelectionVideoCell class] forCellReuseIdentifier:@"BXGSelectionVideoCell"];
    selectVideoTableView.allowsSelection = true;
    [selectVideoTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.1)]];
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



@end
