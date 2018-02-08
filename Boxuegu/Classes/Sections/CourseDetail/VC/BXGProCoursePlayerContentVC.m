//
//  BXGProCoursePlayerContentVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/22.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGProCoursePlayerContentVC.h"

#import "BXGCourseDetailViewModel.h"
#import "RWMultiTableView.h"
#import "RWTab.h"
#import "BXGStudyChapterHeaderView.h"
#import "BXGPlayListItemCell.h"
#import "BXGPlayListPointCell.h"
#import "RWStarView.h"
#import "BXGPraiseCoursePopView.h"
#import "MOPopWindow.h"
#import "RWCommonFunction.h"
#import "BXGPraiseCell.h"
#import "UIExtTableView.h"
#import "MJRefresh.h"
#import "BXGDownloadSelectPageVC.h"
#import "BXGMaskView.h"

@interface BXGProCoursePlayerContentVC ()

@property (nonatomic, strong) NSArray<BXGCourseOutlinePointModel *> *pointModelArray;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) BXGCourseOutlineSectionModel *sectionModel;
@property (nonatomic, strong) BXGCourseOutlineVideoModel *currentVideoModel;

@property (nonatomic, weak)   RWMultiTableView *proCourseOutlineView;
@property (nonatomic, weak)   UILabel *praiseScoreLabel;
@property (nonatomic, weak)   UILabel *praiseGreateCountLabel;
@property (nonatomic, weak)   UITableView *praiseListDetailView;

@property (nonatomic, strong) NSArray *praiseArray;
@property (nonatomic, strong) BXGCourseOutlineVideoModel *firstVideoModel;
@end

@implementation BXGProCoursePlayerContentVC

#pragma mark - Init

- (instancetype)initWithCourseModel:(BXGCourseModel *)courseModel; {
    
    self = [super init];
    if(self) {
        
        BXGCourseDetailViewModel *viewModel = [BXGCourseDetailViewModel viewModelWithModel:courseModel];
        self.viewModel = viewModel;
    }
    return self;
}

- (instancetype)initWithCourseModel:(BXGCourseModel *)courseModel andSectionModel:(BXGCourseOutlineSectionModel *)sectionModel; {
    
    self = [super init];
    if(self) {
        
        BXGCourseDetailViewModel *viewModel = [BXGCourseDetailViewModel viewModelWithModel:courseModel];
        self.viewModel = viewModel;
        
        self.sectionModel = sectionModel;
    }
    return self;
}
// Public

- (void)updateHighlightVideoModel:(BXGCourseOutlineVideoModel *)videoModel; {
    
    self.currentVideoModel = videoModel;
    [self.proCourseOutlineView reloadData];
    
}
- (void)scrollToModel:(id)model; {
    
    RWMultiItem *item = [self.proCourseOutlineView searchItemWithModel:model];
    
    if(item){
        
        NSIndexPath *indexPath= [self.proCourseOutlineView indexPathForItem:item];
        if(indexPath) {
            //            [self.proCourseOutlineView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }else {
            [self.proCourseOutlineView scrollsToTop];
        }
    }else {
        
        [self.proCourseOutlineView scrollsToTop];
    }
}

#pragma mark - Life Cyle

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self installUI];
    [self loadOutlineData];
    [self loadPraiseDataWithRefresh:true];
}

#pragma mark - Load Data

- (void)loadOutlineData {
    
    __weak typeof (self) weakSelf = self;
    [weakSelf.proCourseOutlineView installLoadingMaskView];
    // 1.请求数据
    [weakSelf.viewModel loadCoursePointAndVideoWithSectionId:weakSelf.sectionModel.idx andFinishedBlock:^(BOOL success, NSArray * _Nullable modelArray, NSString * _Nullable message) {
        [weakSelf.proCourseOutlineView removeMaskView];
        if(success && modelArray.count > 0){
            
            // 加载成功
            weakSelf.pointModelArray = modelArray;
            for(NSInteger i = 0; i < weakSelf.pointModelArray.count; i++) {
                
                if(weakSelf.pointModelArray[i].videos.count > 0) {
                    
                    weakSelf.firstVideoModel = weakSelf.pointModelArray[i].videos.firstObject;
                    break;
                }
            }
            
            weakSelf.sectionArray = @[modelArray];
            [weakSelf.proCourseOutlineView installDataSourse];
            [weakSelf.proCourseOutlineView openAllSection];
            [weakSelf.proCourseOutlineView reloadData];
            
            // 设置播放器播放列表
            if(weakSelf.settingPointModelArrayBlock) {
                
                weakSelf.settingPointModelArrayBlock(weakSelf.pointModelArray);
            }
            // [[BXGHUDTool share]showHUDWithString:@"课程大纲加载成功!"];
            
            
        }else {
            
            [[BXGHUDTool share]showHUDWithString:@"课程大纲加载失败!"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf.navigationController popViewControllerAnimated:true];
            });
        }
    }];
}

- (void)loadPraiseDataWithRefresh:(BOOL)isRefresh
{
    __weak typeof (self) weakSelf = self;
    
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
             weakSelf.viewModel.praiseCourseIsEnd = true;
         }
         
         [weakSelf.praiseListDetailView bxg_endHeaderRefresh];
         
         if(weakSelf.viewModel.praiseCourseIsEnd)
         {
             [weakSelf.praiseListDetailView bxg_endFootterRefreshNoMoreData];
         }
         else
         {
             [weakSelf.praiseListDetailView bxg_endFootterRefresh];
         }
         
         [weakSelf.praiseListDetailView removeMaskView];
         if(success) {
             
             [weakSelf.praiseListDetailView reloadData];
             if(!weakSelf.praiseArray || weakSelf.praiseArray.count <= 0){
                 
                 // [weakSelf.praiseListDetailView installMaskView:BXGMaskViewTypeNoPraise];
                 [weakSelf.praiseListDetailView installMaskView:BXGMaskViewTypeNoPraise andInset:UIEdgeInsetsMake(weakSelf.praiseListDetailView.tableHeaderView.frame.size.height, 0, 0, 0)];
             }
         }else {
             
             [weakSelf.praiseListDetailView reloadData];
             [weakSelf.praiseListDetailView installMaskView:BXGMaskViewTypeLoadFailed];
         }
         
     }];
}

#pragma mark - Install UI

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
    weakSelf.proCourseOutlineView = outlineTableView;
    outlineTableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    // 注册cell
    
    [outlineTableView registerClass:[BXGPlayListPointCell class] forCellReuseIdentifier:@"BXGPlayListPointCell"];
    [outlineTableView registerClass:[BXGPlayListItemCell class] forCellReuseIdentifier:@"BXGPlayListItemCell"];
    
    
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
            cell.downloadBtnBlock = ^(BXGCourseOutlinePointModel *pointModel) {
                
                BXGCourseOutlinePointModel *copyPointModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:pointModel]];
                
                BOOL bAllDownloaded = [[BXGResourceManager shareInstance] isAllVideoDownloadedUnderPointMode:copyPointModel];
                if(bAllDownloaded)
                {
                    [[BXGHUDTool share] showHUDWithString:@"本知识视频,您已经全部下载过了, 马上去学习吧"];
                }
                else
                {
                    BXGCourseModel *courseModel = weakSelf.viewModel.courseModel;
                    BXGDownloadSelectPageVC *vc = [BXGDownloadSelectPageVC new];
                    [vc enterDownloadSelectPageWithCourseModel:courseModel pointModel:copyPointModel];
                    [weakSelf.navigationController pushViewController:vc animated:true];
                }
            };
            
            return cell;
        }else {
            
            BXGPlayListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGPlayListItemCell"];
            cell.isPlaying = weakSelf.currentVideoModel == item.model;
            BXGCourseOutlineVideoModel *model= item.model;
            cell.videoModel = model;
            return cell;
        }
    };
    outlineTableView.didSelectRowBlock = ^(RWMultiTableView *tableView, NSIndexPath *indexPath, RWMultiItem *item) {
        
        if([item.model isKindOfClass:[BXGCourseOutlineVideoModel class]]) {
            
            weakSelf.clickVideoModelBlock(item.model);
        }
    };
    
    outlineTableView.willDisplayCellBlock = ^(RWMultiTableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath, RWMultiItem *item) {
        if([item.model isKindOfClass:[BXGCourseOutlineVideoModel class]]){
            
            BXGCourseOutlineVideoModel *videoModel = (BXGCourseOutlineVideoModel *)item.model;
            NSString* videoIdx = videoModel.idx;
            BXGPlayListItemCell *vcell = (BXGPlayListItemCell *)cell;
            [[BXGDownloader shareInstance] addObserver:vcell withVideoIdxKey:videoIdx];
        }
    };
    
    outlineTableView.didEndDisplayingCellBlock = ^(RWMultiTableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath, RWMultiItem *item) {
        
        if([item.model isKindOfClass:[BXGCourseOutlineVideoModel class]]){
            BXGCourseOutlineVideoModel *videoModel = (BXGCourseOutlineVideoModel *)item.model;
            
            NSString* videoIdx = videoModel.idx;
            [[BXGDownloader shareInstance] removeObserver:cell andVideoIdxkey:videoIdx];
        }
    };
    
    outlineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    outlineTableView.rowHeight = UITableViewAutomaticDimension;
    outlineTableView.estimatedRowHeight = 70;
    
    [outlineTableView installDataSourse];
    [outlineTableView openAllSection];
    
    
#pragma mark 评价
    
    
    UIView *evaluateView = [UIView new];
    
    UIView *evaluateHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 150)];
    
    // evaluateTitleView
    
    UIView *evaluateTitleView = [UIView new];
    [evaluateHeaderView addSubview:evaluateTitleView];
    
    [evaluateTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(0);
        make.left.right.offset(0);
        make.height.offset(95);
    }];
    
    UILabel *titleLabel = [UILabel new];
    [evaluateTitleView addSubview:titleLabel];
    evaluateTitleView.backgroundColor = [UIColor whiteColor];
    
    titleLabel.font = [UIFont bxg_fontRegularWithSize:RWAutoFontSize(16)];
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
        [[BXGBaiduStatistic share] statisticEventString:jybpjan_27 andParameter:nil];
        if(!weakSelf.currentVideoModel && !weakSelf.firstVideoModel){
            
            return;
        }
        BXGPraiseCoursePopView *sview = [BXGPraiseCoursePopView new];
        
        
        sview.closeBlock = ^{
            [[BXGBaiduStatistic share] statisticEventString:jybgban_29 andParameter:nil];
            [weakSelf.navigationController dismissViewControllerAnimated:true completion:nil];
        };
        
        sview.commitBlock = ^(NSInteger star, NSString *text) {
            
            [[BXGBaiduStatistic share] statisticEventString:jybpjtj_28 andParameter:nil];
            NSString *videoId;
            NSString *pointId;
            if(weakSelf.currentVideoModel){
                
                videoId = weakSelf.currentVideoModel.idx;
                pointId = weakSelf.currentVideoModel.superPointModel.idx;
            }else if(weakSelf.firstVideoModel){
                
                videoId = weakSelf.firstVideoModel.idx;
                pointId = weakSelf.firstVideoModel.superPointModel.idx;
            }
            
            if(!videoId || !pointId){
                
                return;
            }
            [weakSelf.navigationController dismissViewControllerAnimated:true completion:^{
                // [[BXGHUDTool share]showHUDWithString:@"提交评论成功！"];
                [[BXGHUDTool share] showLoadingHUDWithString:@"提交评论中..."];
                [weakSelf.viewModel commitStudentCriticizeWithVideoId:videoId andPointId:pointId andStarLevel:@(star) andContent:text finishedBlock:^(BOOL success) {
                    if(success){
                        
                        [[BXGHUDTool share] showHUDWithString:@"提交评论成功"];
                        [weakSelf.praiseListDetailView bxg_beginHeaderRefresh];
                    }else{
                        
                        [[BXGHUDTool share] showHUDWithString:@"提交评论失败"];
                    }
                }];
            }];
        };
        // sview.videoId = weakSelf.currentVideoModel.idx;
        
        [weakSelf rw_presentContentView:nil restrainBlock:^(UIView *view)  {
            
            [view addSubview:sview];
            [sview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(sview.superview);
                make.width.equalTo(sview.superview).multipliedBy(0.84);
                make.height.equalTo(sview.mas_width).multipliedBy(644/640.0);
                // w 640  h 644
            }];
        } tapMaskBlock:^{
            //  [weakSelf dismissViewControllerAnimated:true completion:nil];
        } completion:^{
            
        }andShouldAutorotate:false];
    };
    
    
    
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.width.equalTo(evaluateTitleView).multipliedBy(0.5);
        make.centerX.offset(0);
    }];
    [starView layoutIfNeeded];
    
    
    UIView *spView = [UIView new];
    [evaluateHeaderView addSubview:spView];
    
    spView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(starView.mas_bottom).offset(15);
        make.height.offset(9);
        make.left.right.offset(0);
    }];
    
    
    // praiseListView
    
    UIView * praiseListView = [UIView new];
    
    [evaluateHeaderView addSubview:praiseListView];
    
    [praiseListView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(spView.mas_bottom);
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
    weakSelf.praiseScoreLabel = label;
    weakSelf.praiseGreateCountLabel = sublabel;
    
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
    
    
    weakSelf.praiseListDetailView = praiseListDetailView;
    [evaluateView addSubview:praiseListDetailView];
    praiseListDetailView.tableHeaderView = evaluateHeaderView;
    
    [praiseListDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // make.top.equalTo(spLine.mas_bottom).offset(0);
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
        //        if(weakSelf.viewModel.praiseCourseArray.count > indexPath.row) {
        //
        //            cell.model = weakSelf.viewModel.praiseCourseArray[indexPath.row];
        //        }
        
        cell.model = weakSelf.praiseArray[indexPath.row];
        
        return cell;
    };
    
    praiseListDetailView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    
    praiseListDetailView.numberOfRowsInSectionBlock = ^NSInteger(UITableView *__weak tableView, NSInteger section) {
        
        return weakSelf.praiseArray.count;
        
        // return weakSelf.viewModel.praiseCourseArray.count;
    };
    
    //    praiseListDetailView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //
    //        [weakSelf loadPraiseDataWithRefresh:true];
    //    }];
    
    [praiseListDetailView bxg_setHeaderRefreshBlock:^{
        [weakSelf loadPraiseDataWithRefresh:true];
    }];
    
    //    praiseListDetailView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        [weakSelf loadPraiseDataWithRefresh:false];
    //    }];
    
    [praiseListDetailView bxg_setFootterRefreshBlock:^{
        [weakSelf loadPraiseDataWithRefresh:false];
    }];
    
    
    RWTab *superView =[[RWTab alloc]initWithDetailViewArrary:@[outlineTableView,evaluateView] andTitleArray:@[@"课程大纲",@"评价"] andCount:2];
    superView.scrollEnabled = false;
    return superView;
}

-(void)dealloc {
    
    NSArray *cells = [self.proCourseOutlineView visibleCells];
    for(int i = 0; i<cells.count; ++i) {
        
        if([cells[i] isKindOfClass:[BXGPlayListItemCell class]]) {
            
            [[BXGDownloader shareInstance] removeObserver:cells[i] andVideoIdxkey:((BXGPlayListItemCell*)cells[i]).videoModel.idx];
        }
    }
}

@end
