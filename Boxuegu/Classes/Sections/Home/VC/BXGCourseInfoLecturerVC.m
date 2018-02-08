//
//  BXGCourseInfoLecturerVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseInfoLecturerVC.h"
#import "BXGCourseInfoViewModel.h"
#import "RWTableView.h"
#import "BXGPraiseCell.h"
#import "BXGSingleTagTitleView.h"
#import "BXGCourseInfoLecturerViewModel.h"

@interface BXGCourseInfoLecturerVC () <UIScrollViewDelegate>
@property (nonatomic, weak) RWTableView *tableView;
@property (nonatomic, strong) BXGCourseInfoLecturerViewModel *viewModel;
@end

@implementation BXGCourseInfoLecturerVC

- (void)setLecturerModels:(NSArray *)lecturerModels {
    _lecturerModels = lecturerModels;
    [self.tableView reloadData];
}

- (instancetype)initWithViewModel:(BXGCourseInfoLecturerViewModel *)viewModel; {
    self = [super init];
    if(self) {
        _viewModel = viewModel;
    }
    return self;
}

#pragma mark - Data

- (void)loadData {
    Weak(weakSelf);
    [self.view installLoadingMaskView];
    [self.viewModel loadCourseCourseLecturerWithFinished:^(NSArray<BXGCourseLecturerModel *> *lecturerModels) {
        [weakSelf.view removeMaskView];
        [weakSelf.tableView removeMaskView];
        
        
        if(lecturerModels == nil) {
            
            [weakSelf.tableView installMaskView:BXGButtonMaskViewTypeLoadFailed andInset:UIEdgeInsetsMake(0, 0, 0, 0) buttonBlock:^{
                [weakSelf loadData];
            }];
            return;
        }
        
        if(lecturerModels.count <= 0) {
            [self.tableView installMaskView:BXGMaskViewTypeNoData];
            return;
        }
        
        weakSelf.lecturerModels = lecturerModels;
    }];
}

- (void)installUI {
    Weak(weakSelf);
    RWTableView *tableView = [RWTableView new];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    [tableView registerNib:[UINib nibWithNibName:@"BXGPraiseCell" bundle:nil] forCellReuseIdentifier:@"BXGPraiseCell"];
    tableView.estimatedRowHeight = 100;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.allowsSelection = false;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    BXGSingleTagTitleView *headerView = [[BXGSingleTagTitleView alloc]initWithFrame:CGRectMake(0, 0, 0, 46)];
    tableView.tableHeaderView = headerView;
    headerView.cellTitle = @"导师简介";
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
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    self.tableView = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self installUI];
    [self loadData];
}
@end
