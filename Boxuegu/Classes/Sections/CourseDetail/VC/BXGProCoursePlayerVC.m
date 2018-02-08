//
//  BXGProCoursePlayerVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGProCoursePlayerVC.h"

#import "BXGNetWorkTool.h"
#import "BXGCourseDetailViewModel.h"
#import "RWMultiTableView.h"
#import "RWTab.h"
#import "BXGStudyChapterHeaderView.h"
// #import "BXGOutlineSectionCell.h"

#import "BXGPlayListItemCell.h"
#import "BXGPlayListPointCell.h"
#import "RWStarView.h"
#import "BXGPraiseCoursePopView.h"
#import "MOPopWindow.h"
#import "RWCommonFunction.h"
#import "BXGPraiseCell.h"
#import "UIExtTableView.h"
#import "MJRefresh.h"



@interface BXGProCoursePlayerVC ()
@property (nonatomic, strong) BXGCourseDetailViewModel *viewModel;
@property (nonatomic, weak) RWMultiTableView *proCourseOutlineView;

@property (nonatomic, strong) NSArray<BXGCourseOutlinePointModel *> *pointModelArray;
@property (nonatomic, strong) NSArray *sectionArray;

@property (nonatomic, weak) UILabel *praiseScoreLabel;
@property (nonatomic, weak) UILabel *praiseGreateCountLabel;
@property (nonatomic, weak) UITableView *praiseListDetailView;

@end

@implementation BXGProCoursePlayerVC
- (instancetype)initWithCourseModel:(BXGCourseModel *)courseModel; {

    self = [super init];
    if(self) {
    
        BXGCourseDetailViewModel *viewModel = [BXGCourseDetailViewModel viewModelWithModel:courseModel];
        _viewModel = viewModel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof (self) weakSelf = self;
    [self installUI];

    // HUD - 获取数据中
    
    // 1.请求数据
    [self.viewModel loadCoursePointAndVideoWithSectionId:self.model.idx andFinishedBlock:^(BOOL success, NSArray * _Nullable modelArray, NSString * _Nullable message) {
        
        if(success){
            
            if(modelArray.count <= 0) {
            
                [[BXGHUDTool share]showHUDWithString:@"课程大纲加载失败"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                    [weakSelf.navigationController popViewControllerAnimated:true];
                });
                
            }else {
            
                // 加载成功
                weakSelf.pointModelArray = modelArray;
                weakSelf.sectionArray = @[modelArray];
                [weakSelf.proCourseOutlineView installDataSourse];
                [weakSelf.proCourseOutlineView openAllSection];
                [weakSelf.proCourseOutlineView reloadData];
                
                // 设置播放器
                
                
            }
        }else {
            
            // 加载失败 跳出
        }
    }];
    
    [self loadPraiseDataWithRefresh:true];
}

- (void)loadPraiseDataWithRefresh:(BOOL)isRefresh {

    __weak typeof (self) weakSelf = self;

    [self.viewModel loadStudentCriticizedListWithRefresh:isRefresh andFinishedBlock:^(BOOL success,BXGStudentCriticizeTotalModel *model, NSArray * _Nullable modelArray, NSString * _Nullable message) {
        
        if(model.criticize) {
        
            weakSelf.praiseScoreLabel.text = [NSString stringWithFormat:@"好评%@",model.score];
            weakSelf.praiseGreateCountLabel.text = [NSString stringWithFormat:@"（%@条评论，%@条好评）",model.totalCount,model.greatCount];
            [weakSelf.praiseListDetailView reloadData];
            
            [weakSelf.praiseListDetailView.mj_header endRefreshing];
        }else {
        
            weakSelf.viewModel.praiseCourseIsEnd = true;
        }
        
        
        if(weakSelf.viewModel.praiseCourseIsEnd) {
        
            [weakSelf.praiseListDetailView.mj_footer endRefreshingWithNoMoreData];
        }else{
        
            [weakSelf.praiseListDetailView.mj_footer endRefreshing];
        }
    }];
}


- (void)installUI {

    UIView *courseDetailView = [self installCourseDetailView];
    [self.view addSubview:courseDetailView];
    [courseDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.left.right.offset(0);
    }];
    
}

- (UIView *)installCourseDetailView {
    
#pragma mark Generate Debug Data
    
    __weak typeof (self) weakSelf = self;

#pragma mark 课程大纲
    
    
    // tab 1
    RWMultiTableView *outlineTableView = [[RWMultiTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.proCourseOutlineView = outlineTableView;
    outlineTableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    // 注册cell

    [outlineTableView registerClass:[BXGPlayListPointCell class] forCellReuseIdentifier:@"BXGPlayListPointCell"];
    [outlineTableView registerClass:[BXGPlayListItemCell class] forCellReuseIdentifier:@"BXGPlayListItemCell"];
    
    // [outlineTableView registerClass:[BXGStudyChapterHeaderView class] forHeaderFooterViewReuseIdentifier:@"BXGStudyChapterHeaderView"];
    
    
    
    
    outlineTableView.rootModelForTableViewBlock = ^NSArray *(RWMultiTableView *tableView) {
        
        return weakSelf.sectionArray;
    };
    //
    outlineTableView.subModelsForTableViewBlock = ^NSArray *(RWMultiTableView *tableView, NSInteger section, RWMultiItem *parentItem) {
        
        if(parentItem.level == -1) {
            
            return parentItem.model;
        }else if(parentItem.level == 0) {
         
            BXGCourseOutlinePointModel *pointModel = parentItem.model;
            return pointModel.videos;
            
        }else {
        
            return nil;
        }
    };
    
    outlineTableView.cellForRowBlock = ^UITableViewCell *(RWMultiTableView *tableView, NSIndexPath *indexPath, RWMultiItem *item) {
        
        if(item.level == 0) {
        
            BXGPlayListPointCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGPlayListPointCell"];
            BXGCourseOutlinePointModel *model= item.model;
            cell.pointModel = model;
            return cell;
            
        }else {
        
            BXGPlayListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGPlayListItemCell"];
            BXGCourseOutlineVideoModel *model= item.model;
            cell.videoModel = model;
            return cell;
        }
        
        
        
//        if(item.tag == 0) {
//            
//            cell.isFirstCell = true;
//        }else {
//            
//            cell.isFirstCell = false;
//        }
        
        // NSInteger lastIndex = [tableView numberOfRowsInSection:indexPath.section];
//        if(item.tag == lastIndex - 1) {
//            
//            cell.isLastCell = true;
//        }else {
//            
//            cell.isLastCell = false;
//        }
        
        
        
    };
    
//    outlineTableView.viewForHeaderInSectionBlock = ^UIView *(RWMultiTableView *tableView, NSInteger section, RWMultiItem *item) {
//        
//        BXGStudyChapterHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BXGStudyChapterHeaderView"];
//        if(!headerView) {
//            
//            headerView = [BXGStudyChapterHeaderView new];
//        }
//        BXGCourseOutlineChapterModel *model = item.model;
//        headerView.title = model.name;
//        
//        headerView.isOpen = item.isOpen;
//        return headerView;
//    };
    
//    outlineTableView.heightForHeaderInSectionBlock = ^CGFloat(RWMultiTableView *tableView, NSInteger section) {
//        
//        return 50;
//    };
    
//    outlineTableView.didSelectRowBlock = ^(RWMultiTableView *tableView, NSIndexPath *indexPath, RWMultiItem *item) {
//        BXGProCoursePlayerVC *vc = [BXGProCoursePlayerVC new];
//        vc.model = item.model;
//        [weakSelf.navigationController pushViewController:vc animated:true];
//    };
    
    
    // BXGProCoursePlayerVC
    
    //    outlineTableView.heightForRowBlock = ^CGFloat(RWMultiTableView *tableView, NSInteger section, RWMultiItem *item) {
    //        if(item.tag == 0) {
    //
    //            return 80;
    //        }else {
    //
    //            return 70;
    //        }
    //
    //    };
    
    outlineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    outlineTableView.didSelectHeaderViewAtSectionBlock = ^(RWMultiTableView *tableView, NSInteger section, RWMultiItem *item) {
//        
//        if(item.isOpen){
//            
//            [tableView closeSection:section];
//            
//        }else {
//            
//            [tableView openSection:section];
//        }
//        
//        [tableView reloadData];
//    };
    outlineTableView.rowHeight = UITableViewAutomaticDimension;
    outlineTableView.estimatedRowHeight = 70;
    
    [outlineTableView installDataSourse];
    [outlineTableView openAllSection];
    

#pragma mark 评价
    
    
    UIView *evaluateView = [UIView new];
    
    
    // evaluateTitleView
    
    UIView *evaluateTitleView = [UIView new];
    [evaluateView addSubview:evaluateTitleView];

    [evaluateTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(0);
        make.left.right.offset(0);
        make.height.offset(95);
    }];
    
    UILabel *titleLabel = [UILabel new];
    [evaluateTitleView addSubview:titleLabel];
    
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    titleLabel.textColor = [UIColor colorWithHex:0x333333];
    titleLabel.text = @"评价该课程（相信品牌的力量！）";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.right.offset(0);
    }];
    RWStarView *starView = [RWStarView new];
    [evaluateTitleView addSubview:starView];
    starView.changeStarEnable = false;
    starView.touchUpInsideBlock = ^(NSInteger stars) {
      
        NSLog(@"TouchUpInside");
        UIView *sview = [BXGPraiseCoursePopView new];
        __weak typeof (self) weakSelf =self;
        [self rw_presentContentView:nil restrainBlock:^(UIView *view)  {
            
            [view addSubview:sview];
            [sview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(sview.superview);
                make.width.equalTo(sview.superview).offset(-30);
                make.height.equalTo(sview.mas_width).multipliedBy(644/640.0);
                // w 640  h 644
            }];
        } tapMaskBlock:^{
            [weakSelf dismissViewControllerAnimated:true completion:nil];
        } completion:^{
            
        }];
    };
    
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.width.equalTo(evaluateTitleView).multipliedBy(0.5);
        make.centerX.offset(0);
    }];
    [starView layoutIfNeeded];
    
    
    UIView *spView = [UIView new];
    [evaluateView addSubview:spView];
    
    spView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(starView.mas_bottom).offset(15);
        make.height.offset(9);
        make.left.right.offset(0);
    }];
    
    
    // praiseListView
    
    UIView * praiseListView = [UIView new];
    
    [evaluateView addSubview:praiseListView];
    [praiseListView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(spView.mas_bottom);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];

    
    
    
    
    
    // evaluateTotailView
    UIView *praiseListTotalView = [UIView new];
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
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:RWAutoFontSize(16)];
    label.textColor = [UIColor colorWithHex:0x333333];
    label.text = @"好评0%";

    UILabel *sublabel =  [UILabel new];
    [praiseListTotalView addSubview:sublabel];
    [sublabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right);
        make.centerY.offset(0);
    }];
    sublabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:RWAutoFontSize(12)];
    sublabel.textColor = [UIColor colorWithHex:0x999999];
    sublabel.text = @"（0条评论，0条好评）";
    self.praiseScoreLabel = label;
    self.praiseGreateCountLabel = sublabel;
    
    UIView *spLine = [UIView new];
    [praiseListView addSubview:spLine];
    
    spLine.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [spLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(praiseListTotalView.mas_bottom).offset(0);
        make.height.offset(1);
        make.left.right.offset(0);
    }];
   
    
    // BXGPraiseCell
    // praiseListDetailView
    UIExtTableView *praiseListDetailView = [UIExtTableView new];
    self.praiseListDetailView = praiseListDetailView;
    [praiseListView addSubview:praiseListDetailView];
    [praiseListDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(spLine.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.bottom.offset(0);
        
    }];
    praiseListDetailView.allowsSelection = false;
    [praiseListDetailView registerNib:[UINib nibWithNibName:@"BXGPraiseCell" bundle:nil] forCellReuseIdentifier:@"BXGPraiseCell"];
    praiseListDetailView.rowHeight = UITableViewAutomaticDimension;
    praiseListDetailView.estimatedRowHeight = 100;
    praiseListDetailView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    praiseListDetailView.cellForRowAtIndexPathBlock = ^UITableViewCell *(UITableView *__weak tableView, NSIndexPath *__weak indexPath) {
        
        BXGPraiseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGPraiseCell"];
        cell.model = weakSelf.viewModel.praiseCourseArray[indexPath.row];
        return cell;
    };
    
    praiseListDetailView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    
    praiseListDetailView.numberOfRowsInSectionBlock = ^NSInteger(UITableView *__weak tableView, NSInteger section) {
    
        return weakSelf.viewModel.praiseCourseArray.count;
    };
    
    praiseListDetailView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadPraiseDataWithRefresh:true];
    }];
    praiseListDetailView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadPraiseDataWithRefresh:false];
    }];
    
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor blueColor];
    UIView *view2 = [UIView new];
    view1.backgroundColor = [UIColor grayColor];
    // RWTab *superView =[[RWTab alloc]initWithDetailViewArrary:@[outlineTableView,evaluateView] andTitleArray:@[@"课程大纲",@"评价"] andCount:2];
    RWTab *superView =[[RWTab alloc]initWithDetailViewArrary:@[view1,view2] andTitleArray:@[@"课程大纲",@"评价"] andCount:2];
    // superView.scrollEnabled = false;
    return superView;
}


@end
