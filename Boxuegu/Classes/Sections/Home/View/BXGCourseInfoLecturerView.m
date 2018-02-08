//
//  BXGCourseInfoLecturerView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseInfoLecturerView.h"

#import "BXGCourseInfoViewModel.h"
#import "RWTableView.h"
#import "BXGPraiseCell.h"
#import "BXGSingleTagTitleView.h"
#import "BXGCourseInfoLecturerViewModel.h"

@interface BXGCourseInfoLecturerView() <UIScrollViewDelegate>
@property (nonatomic, weak) RWTableView *tableView;
@property (nonatomic, strong) BXGCourseInfoLecturerViewModel *viewModel;
@end

@implementation BXGCourseInfoLecturerView

#pragma mark - Interface

- (instancetype)initWithViewModel:(BXGCourseInfoLecturerViewModel *)viewModel; {
    self = [super init];
    if(self) {
        _viewModel = viewModel;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
    }
    return self;
}

#pragma mark - Data

- (void)loadData {
    Weak(weakSelf);
    [self.viewModel loadCourseCourseLecturerWithFinished:^(NSArray<BXGCourseLecturerModel *> *lecturerModels) {
        weakSelf.lecturerModels = lecturerModels;
    }];
}

#pragma mark - Getter / Setter

- (void)setLecturerModels:(NSArray *)lecturerModels {
    _lecturerModels = lecturerModels;
    [self.tableView reloadData];
}

#pragma mark - View Event

- (void)installUI {
    Weak(weakSelf);
    
    // -- TableView --
    
    // init
    RWTableView *tableView = [RWTableView new];
    [self addSubview:tableView];
    self.tableView = tableView;
    
    // config
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.allowsSelection = false;
    [tableView registerNib:[UINib nibWithNibName:@"BXGPraiseCell" bundle:nil] forCellReuseIdentifier:@"BXGPraiseCell"];
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    // header view
    BXGSingleTagTitleView *headerView = [[BXGSingleTagTitleView alloc]initWithFrame:CGRectMake(0, 0, 0, 46)];
    tableView.tableHeaderView = headerView;
    headerView.cellTitle = @"导师简介";

    // datasource / delegate
    tableView.numberOfRowsInSectionBlock = ^NSInteger(UITableView *__weak tableView, NSInteger section) {
        return weakSelf.lecturerModels.count;
    };
    tableView.cellForRowAtIndexPathBlock = ^UITableViewCell *(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
        BXGPraiseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGPraiseCell" forIndexPath:indexPath];
        cell.lecturerModel = weakSelf.lecturerModels[indexPath.row];
        return cell;
    };
    tableView.scrollViewDidScrollBlock = ^(UIScrollView *scrollView) {
        [self.foldDelegate checkFoldWithScrollView:scrollView];
    };
    
    // layout
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
}
@end

