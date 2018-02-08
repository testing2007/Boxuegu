//
//  BXGCourseStudentCriticizedView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseStudentCriticizedView.h"
#import "RWCommonFunction.h"
#import "RWStarView.h"
#import "RWTableView.h"
#import "BXGPraiseCell.h"
#import "BXGStudentCriticizeTotalModel.h"
#import "BXGCourseDetailCriticizedViewModel.h"
#import "BXGMaskView.h"

@interface BXGCourseStudentCriticizedView() <UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *praiseArray;
@property (nonatomic, weak) UILabel *praiseScoreLabel;
@property (nonatomic, weak) UILabel *praiseGreateCountLabel;
@property (nonatomic, weak) RWTableView *praiseListDetailView;
@property (nonatomic, strong) BXGCourseDetailCriticizedViewModel *viewModel;
@property (nonatomic, assign) BOOL didLoadView;
@end

@implementation BXGCourseStudentCriticizedView

#pragma mark Interface

- (instancetype)initWithViewModel:(BXGCourseDetailCriticizedViewModel *)viewModel {
    self = [super initWithFrame:CGRectZero];
    if(self){
        _viewModel = viewModel;
    }
    return self;
}

- (void)setCourseId:(NSString *)courseId {
    _courseId = courseId;
    if(courseId){
        _viewModel = [[BXGCourseDetailCriticizedViewModel alloc]initWithCourseId:courseId];
    }
}

#pragma mark - Override

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if(newWindow && _didLoadView == false) {
        [self installUI];
        [self.praiseListDetailView installLoadingMaskView];
        [self loadPraiseDataWithRefresh:true];
        _didLoadView = true;
    }
}

#pragma mark - UI

- (void)installUI {
    Weak(weakSelf);
    
    UIView *evaluateHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 46)];
    [self addSubview:evaluateHeaderView];
    
    UIView * praiseListView = [UIView new];
    [evaluateHeaderView addSubview:praiseListView];
    
    
    [praiseListView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(0);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];
    
    // evaluateTotailView
    UIView *praiseListTotalView = [UIView new];
    praiseListTotalView.backgroundColor = [UIColor whiteColor];
    [praiseListView addSubview:praiseListTotalView];
    [praiseListTotalView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.offset(0);
        make.height.offset(46);
    }];
    
    UILabel *label =  [UILabel new];
    [praiseListTotalView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.offset(0);
    }];
    label.font = [UIFont bxg_fontRegularWithSize:16];
    label.textColor = [UIColor colorWithHex:0x333333];
    label.text = @"好评0%";
    
    UILabel *sublabel =  [UILabel new];
    [praiseListTotalView addSubview:sublabel];
    [sublabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right);
        make.centerY.offset(0);
    }];
    sublabel.font = [UIFont bxg_fontRegularWithSize:12];
    sublabel.textColor = [UIColor colorWithHex:0x999999];
    sublabel.text = @"（0条评论，0条好评）";
    
    UIView *spLine = [UIView new];
    [praiseListView addSubview:spLine];
    
    spLine.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [spLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(praiseListTotalView.mas_bottom).offset(0);
        make.height.offset(1);
        make.left.right.offset(0);
    }];
    
    // praiseListDetailView
    RWTableView *praiseListDetailView = [RWTableView new];
    if (@available(iOS 11.0, *)) {
        praiseListDetailView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:praiseListDetailView];
    praiseListDetailView.tableHeaderView = evaluateHeaderView;
    [praiseListDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.offset(0);
    }];
    
    [praiseListDetailView registerNib:[UINib nibWithNibName:@"BXGPraiseCell" bundle:nil] forCellReuseIdentifier:@"BXGPraiseCell"];
    praiseListDetailView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    praiseListDetailView.rowHeight = UITableViewAutomaticDimension;
    praiseListDetailView.estimatedRowHeight = 100;
    praiseListDetailView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    praiseListDetailView.cellForRowAtIndexPathBlock = ^UITableViewCell *(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
        BXGPraiseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGPraiseCell"];
        cell.model = weakSelf.praiseArray[indexPath.row];
        return cell;
    };
    
    praiseListDetailView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    praiseListDetailView.scrollViewDidScrollBlock = ^(UIScrollView *scrollView) {
        if(self.foldDelegate){
            [self.foldDelegate checkFoldWithScrollView:scrollView];
        }
    };
    praiseListDetailView.numberOfRowsInSectionBlock = ^NSInteger(UITableView *__weak tableView, NSInteger section) {
        return weakSelf.praiseArray.count;
    };

    if(self.headerReflashEnabled){
        [praiseListDetailView bxg_setHeaderRefreshBlock:^{
            [weakSelf loadPraiseDataWithRefresh:true];
        }];
//        praiseListDetailView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakSelf loadPraiseDataWithRefresh:true];
//        }];
    }
    if(self.footerReflashEnabled){
        
        [praiseListDetailView bxg_setFootterRefreshBlock:^{
            [weakSelf loadPraiseDataWithRefresh:false];
        }];
//        praiseListDetailView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [weakSelf loadPraiseDataWithRefresh:false];
//        }];
    }
    weakSelf.praiseScoreLabel = label;
    weakSelf.praiseGreateCountLabel = sublabel;
    weakSelf.praiseListDetailView = praiseListDetailView;
}

- (void)loadPraiseDataWithRefresh:(BOOL)isRefresh {
    Weak(weakSelf);
    [weakSelf.viewModel loadStudentCriticizedListWithRefresh:isRefresh
                                            andFinishedBlock:^(BOOL success,
                                                               BXGStudentCriticizeTotalModel *model,
                                                               NSArray * _Nullable modelArray,
                                                               NSString * _Nullable message)
     {
         
         weakSelf.praiseArray = modelArray;
         if(model.criticize)
         {
             weakSelf.praiseScoreLabel.text = [NSString stringWithFormat:@"好评%@",model.score];
             weakSelf.praiseGreateCountLabel.text = [NSString stringWithFormat:@"（%@条评论，%@条好评）",model.totalCount,model.greatCount];
         }
         else
         {
//             weakSelf.viewModel.praiseCourseIsEnd = true;
         }
         [weakSelf.praiseListDetailView bxg_endHeaderRefresh];
//         [weakSelf.praiseListDetailView.mj_header endRefreshing];
         
         if(weakSelf.viewModel.praiseCourseIsEnd)
         {
             [weakSelf.praiseListDetailView bxg_endFootterRefreshNoMoreData];
//             [weakSelf.praiseListDetailView.mj_footer endRefreshingWithNoMoreData];
         }
         else
         {
             [weakSelf.praiseListDetailView bxg_endFootterRefresh];
//             [weakSelf.praiseListDetailView.mj_footer endRefreshing];
         }
         
         [weakSelf removeMaskView];
         [weakSelf.praiseListDetailView removeMaskView];
         if(success) {
             
             [weakSelf.praiseListDetailView reloadData];
             if(!weakSelf.praiseArray || weakSelf.praiseArray.count <= 0){

                 // [weakSelf.praiseListDetailView installMaskView:BXGMaskViewTypeNoPraise];
                 [weakSelf.praiseListDetailView installMaskView:BXGMaskViewTypeNoPraise
                 andInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//                 andInset:UIEdgeInsetsMake(weakSelf.praiseListDetailView.tableHeaderView.frame.size.height + 1, 0, 0, 0)];
             }
         }else {
             
             [weakSelf.praiseListDetailView reloadData];
             [weakSelf.praiseListDetailView installMaskView:BXGMaskViewTypeLoadFailed];
         }
     }];
}
@end
