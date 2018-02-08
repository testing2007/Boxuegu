//
//  BXGMiniCoursePlayerContentVC.m
//  Boxuegu
//
//  Created by mynSoo on 2017/7/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMiniCoursePlayerContentVC.h"
// VC
#import "BXGDownloadSelectPageVC.h"

// View
#import "BXGStudyChapterHeaderView.h"
#import "BXGPlayerListSectionCell.h"
#import "BXGPlayListPointCell.h"
#import "BXGPlayListItemCell.h"

// Model
#import "BXGCourseOutlineChapterModel.h"
#import "BXGStudyViewModel.h"

// ViewModel
#import "BXGStudyPlayerViewModel.h"
#import "BXGCourseOutlinePointModel.h"

// Tools
#import "BXGResourceManager.h"
#import "BXGDownloader.h"
#import "BXGHUDTool.h"

// Lib
#import "RWMultiTableView.h"
#import "BXGMaskView.h"

@interface BXGMiniCoursePlayerContentVC ()

/// Model
@property (nonatomic, strong) NSArray<BXGCourseOutlineChapterModel*> *chapterModelArray;
@property (nonatomic, weak) BXGCourseOutlineVideoModel *hilightedVideoModel;
@property (nonatomic, weak) BXGCourseOutlineVideoModel *searchVideoModel;

#pragma mark 状态 表示
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, strong) NSIndexPath *searchIndexPath;
#pragma mark UI

/// 主列表
@property (nonatomic, weak) RWMultiTableView *mTableView;

#pragma mark - appV1.2.1 property
@property (nonatomic, strong) NSArray *courseOutlineArray; // 课程大纲模型数组
@end

@implementation BXGMiniCoursePlayerContentVC

#pragma mark - Init

- (instancetype)initWithCourseModel:(BXGCourseModel *)courseModel; {
    
    self = [super init];
    if(self) {
        
        BXGCourseDetailViewModel *viewModel = [BXGCourseDetailViewModel viewModelWithModel:courseModel];
        self.viewModel = viewModel;
    }
    return self;
}

- (void)dealloc {
    
    NSArray *cells = [self.mTableView visibleCells];
    for(int i=0; i<cells.count; ++i) {
        
        if([cells[i] isKindOfClass:[BXGPlayListItemCell class]]) {
            
            [[BXGDownloader shareInstance] removeObserver:cells[i] andVideoIdxkey:((BXGPlayListItemCell*)cells[i]).videoModel.idx];
        }
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof (self) weakSelf = self;
    
    [self installUI];
    [weakSelf loadOutline];
}

#pragma mark - Install UI

- (void)installUI {
    
    __weak typeof (self) weakSelf = self;
    
    RWMultiTableView *mTableView = [RWMultiTableView new];
    
    mTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mTableView];
    mTableView.bounces = true;
    [mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [mTableView registerClass:[BXGStudyChapterHeaderView class] forHeaderFooterViewReuseIdentifier:@"BXGStudyPlayListHeaderCell"];
    [mTableView registerClass:[BXGPlayerListSectionCell class] forCellReuseIdentifier:@"BXGPlayerListSectionCell"];
    [mTableView registerClass:[BXGPlayListPointCell class] forCellReuseIdentifier:@"BXGPlayListPointCell"];
    [mTableView registerClass:[BXGPlayListItemCell class] forCellReuseIdentifier:@"BXGPlayListItemCell"];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    weakSelf.mTableView = mTableView;
    
    mTableView.rootModelForTableViewBlock = ^NSArray *(UITableView *tableView) {
        
        // weakSelf.courseDetailViewModel.courseOutlineModelArray;
        return weakSelf.courseOutlineArray;
    };
    
    mTableView.subModelsForTableViewBlock = ^NSArray *(UITableView *tableView, NSInteger section, RWMultiItem *parentItem) {
        
        if(parentItem.model) {
            
            if([parentItem.model isKindOfClass:[BXGCourseOutlineChapterModel class]]){
                
                BXGCourseOutlineChapterModel *chapterModel = (BXGCourseOutlineChapterModel *)parentItem.model;
                NSMutableArray *pointModelArray = [NSMutableArray new];
                for(NSInteger i = 0; i < chapterModel.jie.count; i ++) {
                    
                    [pointModelArray addObjectsFromArray:chapterModel.jie[i].dian];
                    
                }
                return pointModelArray;
            }
            
            if([parentItem.model isKindOfClass:[BXGCourseOutlinePointModel class]]){
                
                BXGCourseOutlinePointModel *pointModel = (BXGCourseOutlinePointModel *)parentItem.model;
                return pointModel.videos;
            }
        }
        return nil;
    };
    
    mTableView.cellForRowBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, RWMultiItem *item) {
        
        if(item.model) {
            
            if([item.model isKindOfClass:[BXGCourseOutlinePointModel class]]){
                
                
                BXGCourseOutlinePointModel *pointModel = (BXGCourseOutlinePointModel *)item.model;
                //BXGPlayListPointCell *cell =[tableView dequeueReusableCellWithIdentifier:@"BXGPlayListPointCell" forIndexPath:indexPath];
                // [tableView dequeueReusableCellWithIdentifier:@"" forIndexPath:indexPath];
                //cell.pointModel = pointModel;
                BXGPlayListPointCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGPlayListPointCell" forIndexPath:indexPath];
                //BXGCourseOutlinePointModel * pointModel = (BXGCourseOutlinePointModel *)[dataSource itemforIndexPath:indexPath.row].model;
                cell.title = pointModel.name;
                cell.pointModel = pointModel;
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
                
            }
            
            if([item.model isKindOfClass:[BXGCourseOutlineVideoModel class]]){
                
                BXGCourseOutlineVideoModel *videoModel = (BXGCourseOutlineVideoModel *)item.model;
                BXGPlayListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGPlayListItemCell" forIndexPath:indexPath];
                //if(videoModel == self.currentVideoModel){
                if(videoModel == weakSelf.hilightedVideoModel){
                    // if(self.currentPlayItem == [dataSource itemforIndexPath:indexPath.row]){
                    
                    // 正在播放
                    cell.isPlaying = true;
                }else {
                    
                    // 不正在播放
                    cell.isPlaying = false;
                }
                cell.videoModel = videoModel;
                if(weakSelf.searchVideoModel) {
                    
                    if(weakSelf.searchVideoModel == videoModel) {
                        
                        weakSelf.searchIndexPath = indexPath;
                    }
                }
                return cell;
                
            }
            
        }
        return nil;
        
    };;
    
    mTableView.heightForHeaderInSectionBlock = ^CGFloat(RWMultiTableView *tableView, NSInteger section) {
        
        return 44;
    };
    mTableView.viewForHeaderInSectionBlock = ^UIView *(RWMultiTableView *tableView, NSInteger section, RWMultiItem *item) {
        
        BXGStudyChapterHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BXGStudyPlayListHeaderCell"];
        
        if([item.model isKindOfClass:[BXGCourseOutlineChapterModel class]]) {
            
            BXGCourseOutlineChapterModel *chapterModel = (BXGCourseOutlineChapterModel *)item.model;
            view.title = chapterModel.name;
            view.isOpen = item.isOpen;
        }
        return view;
    };
    
    mTableView.heightForRowBlock = ^CGFloat(RWMultiTableView *tableView, NSInteger section, RWMultiItem *item) {
        
        if(item.level == 0) {
            
            return 54;
            
        }else {
            
            return 33;
        }
    };
    
    
    mTableView.didSelectHeaderViewAtSectionBlock = ^(RWMultiTableView *tableView, NSInteger section, RWMultiItem *item) {
        
        if(item.isOpen) {
            
            [tableView closeSection:section];
            item.isOpen = false;
            // [tableView reloadData];
            [tableView reloadVisibleData];
            
        }else {
            
            [tableView openSection:section];
            item.isOpen = true;
            [tableView reloadVisibleData];
            
        }
    };
    
    mTableView.willDisplayCellBlock = ^(RWMultiTableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath, RWMultiItem *item) {
        if([item.model isKindOfClass:[BXGCourseOutlineVideoModel class]]){
            
            BXGCourseOutlineVideoModel *videoModel = (BXGCourseOutlineVideoModel *)item.model;
            NSString* videoIdx = videoModel.idx;
            BXGPlayListItemCell *vcell = (BXGPlayListItemCell *)cell;
            [[BXGDownloader shareInstance] addObserver:vcell withVideoIdxKey:videoIdx];
        }
    };
    
    mTableView.didEndDisplayingCellBlock = ^(RWMultiTableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath, RWMultiItem *item) {
        
        if([item.model isKindOfClass:[BXGCourseOutlineVideoModel class]]){
            BXGCourseOutlineVideoModel *videoModel = (BXGCourseOutlineVideoModel *)item.model;
            
            NSString* videoIdx = videoModel.idx;
            [[BXGDownloader shareInstance] removeObserver:cell andVideoIdxkey:videoIdx];
        }
    };
    
    
    mTableView.didSelectRowBlock = ^(RWMultiTableView *tableView, NSIndexPath *indexPath, RWMultiItem *item) {
        
        if([item.model isKindOfClass:[BXGCourseOutlineVideoModel class]]) {
            
            //BXGCourseOutlineVideoModel *videoModel = (BXGCourseOutlineVideoModel *)item.model;
            if(weakSelf.clickVideoModelBlock) {
                
                weakSelf.clickVideoModelBlock(item.model);
            };
        }
    };
}

#pragma mark - Load Data

- (void)loadOutline {

    __weak typeof (self) weakSelf = self;
    [weakSelf.view installLoadingMaskView];
    [self.viewModel loadCourseOutLineFinished:^(BOOL success, NSArray * _Nullable modelArray, NSArray * _Nullable pointModelArray, NSString * _Nullable message) {
        [weakSelf.view removeMaskView];
        
        if(success) {
        
            weakSelf.courseOutlineArray = modelArray;
            if(weakSelf.settingPointModelArrayBlock) {
            
                
                [weakSelf.mTableView installDataSourse];
                [weakSelf.mTableView openAllSection];
                [weakSelf.mTableView reloadVisibleData];
                weakSelf.settingPointModelArrayBlock(pointModelArray);
            
            // [[BXGHUDTool share] showHUDWithString:@"课程大纲加载成功" View:weakSelf.view];
            }
            
        }else {
        
            [[BXGHUDTool share] showHUDWithString:@"课程大纲加载失败" View:weakSelf.view];
            
            // 课程大纲加载失败
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                [weakSelf.navigationController popViewControllerAnimated:true];
            });
            
            
        }
        
    }];
}

- (void)scrollToModel:(id)model; {
    
    RWMultiItem *item = [self.mTableView searchItemWithModel:model];
    
    if(item){
        
        NSIndexPath *indexPath= [self.mTableView indexPathForItem:item];
        
        [self.mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
    }else {
        
        [self.mTableView scrollsToTop];
    }
}

- (void)updateHighlightVideoModel:(BXGCourseOutlineVideoModel *)videoModel {

    __weak typeof (self) weakSelf = self;
    weakSelf.hilightedVideoModel = videoModel;
    [weakSelf.mTableView reloadVisibleData];
}
@end
