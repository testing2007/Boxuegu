//
//  BXGTryCoursePlayerContentVC.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGTryCoursePlayerContentVC.h"

//@interface BXGTryCoursePlayerContentVC ()

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
#import "MOPopWindow.h"

// Lib
#import "RWMultiTableView.h"
#import "BXGMaskView.h"
#import "BXGCourseTryOutlineViewModel.h"
#import "BXGCourseInfoPointCell.h"
#import "BXGCourseOutlineTryCell.h"
#import "BXGCourseInfoBottomTabView.h"
#import "BXGConsultCommitView.h"
#import "BXGOrderFillOrderVC.h"
#import "BXGHomeCourseModel.h"
#import "BXGConsultCommitViewModel.h"

@interface BXGTryCoursePlayerContentVC ()

@property (nonatomic, strong) BXGCourseTryOutlineViewModel *tryViewModel;
@property (nonatomic, strong) NSString *courseId;
@property (nonatomic, strong) NSArray<BXGCourseOutlineChapterModel*> *chapterModelArray;
/// Model

@property (nonatomic, weak) BXGCourseOutlineVideoModel *hilightedVideoModel;
@property (nonatomic, weak) BXGCourseOutlineVideoModel *searchVideoModel;
@property (nonatomic, assign) BXGTryCourseType courseType;
#pragma mark 状态 表示
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSIndexPath *searchIndexPath;

@property (nonatomic, weak) RWMultiTableView *mTableView; /// 主列表
@property (nonatomic, strong) NSArray *courseOutlineArray; // 课程大纲模型数组
@property (nonatomic, strong) BXGHomeCourseModel *courseModel;
@end

@implementation BXGTryCoursePlayerContentVC

#pragma mark - Init

- (instancetype)initWithCourseId:(NSString *)courseId andCourseType:(BXGTryCourseType)courseType; {
    if(self) {
        
        self.courseId = courseId;
        self.courseType = courseType;
    }
    return self;
}

- (instancetype)initWithCourseModel:(BXGHomeCourseModel *)courseModel                                                                                                                                            andCourseType:(BXGTryCourseType)courseType; {
    if(self) {
        
        self.courseId = courseModel.courseId;
        self.courseModel = courseModel;
        self.courseType = courseType;
    }
    return self;
}

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    [self installUI];
    [self loadOutline];
    Weak(weakSelf);
    self.sampleVideoPlayDoneBlock = ^{
        // 立即报名
        [weakSelf toFillOrder];
       
    };
    
    // TODO: 设置 Page Name
    if(self.viewModel.courseModel) {
        // 0-就业课 1-微课
        if(self.courseModel.courseType.integerValue) {
            // 微课
            if(self.courseModel.isFree.integerValue) {
                // 免费
                self.pageName = @"免费微课免费试学页";
            }else{
                // 精品微课
                self.pageName = @"精品微课免费试学页";
            }
        }else{
            // 就业课
            self.pageName = @"就业课免费试学页";
        }
    }else {
        self.pageName = @"就业课免费试学页";
    }
    
}
//- (void)checkCourseExistVideosWithExistBlock:(void(^)())existBlock {
//    Weak(weakSelf);
//    if(self.viewModel.courseModel) {
//        if([[BXGUserCenter share] checkSignInWithViewController:self]) {
//
//            if(self.viewModel.courseModel.useStart && self.viewModel.courseModel.useStart.integerValue == 1) {
//                [[BXGHUDTool share] showHUDWithString:@"请到web端，报名并参加入学测试！"];
//                return;
//            }
//
//            [[BXGHUDTool share] showLoadingHUDWithString:nil];
//            [weakSelf.viewModel checkCourseExistVideos:self.viewModel.courseId andFinished:^(BOOL isExist, NSString *msg) {
//                [[BXGHUDTool share] closeHUD];
//                if(isExist) {
//                    if(existBlock){
//                        existBlock();
//                    }
//                }else {
//                    [[BXGHUDTool share] showHUDWithString:msg];
//                }
//            }];
//        }
//    }
//}
- (void)toFillOrder {
    if(self.courseModel.useStart && self.courseModel.useStart.integerValue == 1) {
        [[BXGHUDTool share] showHUDWithString:@"请到web端，报名并参加入学测试！"];
        return;
    }
    
    if(self.courseId) {
        BXGOrderFillOrderVC *vc = [BXGOrderFillOrderVC new];
        vc.arrCourseId = @[self.courseId];
        [self.navigationController pushViewController:vc animated:true needLogin:true];
    }
}

#pragma mark - Install UI

- (void)installUI {
    Weak(weakSelf);
    RWMultiTableView *mTableView = [RWMultiTableView new];
//    mTableView.backgroundColor = [UIColor randomColor];
    [self.view addSubview:mTableView];
    weakSelf.mTableView = mTableView;
    if (@available(iOS 11.0, *)) {
        mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    };
    
    // Config
//    mTableView.backgroundColor = [UIColor grayColor];
    mTableView.backgroundColor = [UIColor whiteColor];
//    mTableView.bounces = false;
    [mTableView registerClass:[BXGStudyChapterHeaderView class] forHeaderFooterViewReuseIdentifier:@"BXGStudyPlayListHeaderCell"];
    [mTableView registerClass:[BXGPlayListPointCell class] forCellReuseIdentifier:@"BXGPlayListPointCell"];
    [mTableView registerClass:[BXGCourseInfoPointCell class] forCellReuseIdentifier:@"BXGCourseInfoPointCell"];
    [mTableView registerClass:[BXGCourseOutlineTryCell class] forCellReuseIdentifier:@"BXGCourseOutlineTryCell"];
    [mTableView registerClass:[BXGPlayListItemCell class] forCellReuseIdentifier:@"BXGPlayListItemCell"];
    
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Layout

    // Data Sourse
    mTableView.rootModelForTableViewBlock = ^NSArray *(UITableView *tableView) {
        return weakSelf.chapterModelArray;
    };
    mTableView.subModelsForTableViewBlock = ^NSArray *(UITableView *tableView, NSInteger section, RWMultiItem *parentItem) {
        if(parentItem.model) {
            if([parentItem.model isKindOfClass:[BXGCourseOutlineChapterModel class]]){
                BXGCourseOutlineChapterModel *chapterModel = (BXGCourseOutlineChapterModel *)parentItem.model;
                NSMutableArray *array = [NSMutableArray new];
                for (NSInteger i = 0; i < chapterModel.jie.count; i++) {
                    [array addObjectsFromArray:chapterModel.jie[i].dian];
                }
                return array;
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
            if([item.model isKindOfClass:[BXGCourseOutlinePointModel class]]) {
                BXGCourseInfoPointCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGCourseInfoPointCell" forIndexPath:indexPath];
                cell.pointModel = (BXGCourseOutlinePointModel *)item.model;
                return cell;
            }
            if([item.model isKindOfClass:[BXGCourseOutlineVideoModel class]]) {
                BXGCourseOutlineTryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGCourseOutlineTryCell" forIndexPath:indexPath];
                cell.model = (BXGCourseOutlineVideoModel *)item.model;
                if([weakSelf.hilightedVideoModel.idx isEqualToString:cell.model.idx]) {
                    cell.isPlaying = true;
                }else {
                    cell.isPlaying = false;
                }
                return cell;
            }
        }
        return nil;
    };
    
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
    
//    mTableView.heightForRowBlock = ^CGFloat(RWMultiTableView *tableView, NSInteger section, RWMultiItem *item) {
//        if(item.level == 0) {
//            return 54;
//        }else {
//            return 45;
//        }
//    };
    
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
    
    
    
    mTableView.didSelectRowBlock = ^(RWMultiTableView *tableView, NSIndexPath *indexPath, RWMultiItem *item) {
        
        if([item.model isKindOfClass:[BXGCourseOutlineVideoModel class]]) {
            
            //BXGCourseOutlineVideoModel *videoModel = (BXGCourseOutlineVideoModel *)item.model;
            //            if(weakSelf.clickVideoModelBlock) {
            //
            //                weakSelf.clickVideoModelBlock(item.model);
            //            };
        }
    };
    
//    mTableView.cellForRowBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, RWMultiItem *item) {
//
//        if(item.model) {
//
//            if([item.model isKindOfClass:[BXGCourseOutlinePointModel class]]){
//
//
//                BXGCourseOutlinePointModel *pointModel = (BXGCourseOutlinePointModel *)item.model;
//                //BXGPlayListPointCell *cell =[tableView dequeueReusableCellWithIdentifier:@"BXGPlayListPointCell" forIndexPath:indexPath];
//                // [tableView dequeueReusableCellWithIdentifier:@"" forIndexPath:indexPath];
//                //cell.pointModel = pointModel;
//                BXGPlayListPointCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGPlayListPointCell" forIndexPath:indexPath];
//                //BXGCourseOutlinePointModel * pointModel = (BXGCourseOutlinePointModel *)[dataSource itemforIndexPath:indexPath.row].model;
//                cell.title = pointModel.name;
//                cell.pointModel = pointModel;
//                cell.downloadBtnBlock = ^(BXGCourseOutlinePointModel *pointModel) {
//
//                    BXGCourseOutlinePointModel *copyPointModel = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:pointModel]];
//
//                    BOOL bAllDownloaded = [[BXGResourceManager shareInstance] isAllVideoDownloadedUnderPointMode:copyPointModel];
//                    if(bAllDownloaded)
//                    {
//                        [[BXGHUDTool share] showHUDWithString:@"本知识视频,您已经全部下载过了, 马上去学习吧"];
//                    }
//                    else
//                    {
//                        BXGCourseModel *courseModel = weakSelf.viewModel.courseModel;
//                        BXGDownloadSelectPageVC *vc = [BXGDownloadSelectPageVC new];
//                        [vc enterDownloadSelectPageWithCourseModel:courseModel pointModel:copyPointModel];
//                        [weakSelf.navigationController pushViewController:vc animated:true];
//                    }
//                };
//
//                return cell;
//
//            }
//
//            if([item.model isKindOfClass:[BXGCourseOutlineVideoModel class]]){
//
//                BXGCourseOutlineVideoModel *videoModel = (BXGCourseOutlineVideoModel *)item.model;
//                BXGCourseOutlineTryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGCourseOutlineTryCell" forIndexPath:indexPath];
//                //if(videoModel == self.currentVideoModel){
//                if(videoModel == weakSelf.hilightedVideoModel){
//                    // if(self.currentPlayItem == [dataSource itemforIndexPath:indexPath.row]){
//
//                    // 正在播放
//                    cell.isPlaying = true;
//                }else {
//
//                    // 不正在播放
//                    cell.isPlaying = false;
//                }
//                cell.model = videoModel;
//                if(weakSelf.searchVideoModel) {
//
//                    if(weakSelf.searchVideoModel == videoModel) {
//
//                        weakSelf.searchIndexPath = indexPath;
//                    }
//                }
//                return cell;
//
//            }
//
//        }
//        return nil;
        
//    };;
    
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
            
            return 45;
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

    mTableView.didSelectRowBlock = ^(RWMultiTableView *tableView, NSIndexPath *indexPath, RWMultiItem *item) {
        
        if([item.model isKindOfClass:[BXGCourseOutlineVideoModel class]]) {
            
            BXGCourseOutlineVideoModel *videoModel = (BXGCourseOutlineVideoModel *)item.model;
            if(weakSelf.clickVideoModelBlock) {
                weakSelf.clickVideoModelBlock(videoModel);
            };
        }
    };
    
    
    
    BXGCourseInfoBottomTabView *bottomTabView = [BXGCourseInfoBottomTabView new];
    
    switch (self.courseType) {
        
        case BXGTryCourseTypeMiniCourse:
            bottomTabView.type = BXGCourseInfoBottomTabTypeFreeCourse;
            break;
        case BXGTryCourseTypeProCourse:
            bottomTabView.type = BXGCourseInfoBottomTabTypeProCourseNoSample;
            break;
    }

     // 展示 咨询课程和立即报名
                                                 
    bottomTabView.didSelectedBtn = ^(BXGCourseInfoBottomTabResponseType type) {
        switch (type) {
                
            case BXGCourseInfoBottomTabResponseTypeSample:
//                [weakSelf toSampleCourse];
                break;
            case BXGCourseInfoBottomTabResponseTypeConsult:
                [weakSelf showConsult];
                if(self.viewModel.courseModel) {
                    // 0-就业课 1-微课
                    if(self.courseModel.courseType.integerValue) {
                        // 微课
                        if(self.courseModel.isFree.integerValue) {
                            // 免费
                        }else{
                            // 精品微课
//                            [[BXGBaiduStatistic share] statisticEventString:kBXGStatSamplePlayerMiniCourseEventType andLabel:nil];
                        }
                    }else{
                        // 就业课
                        [[BXGBaiduStatistic share] statisticEventString:kBXGStatSamplePlayerProCourseEventTypeConsult andLabel:nil];
                    }
                }
                break;
            case BXGCourseInfoBottomTabResponseTypeLearn:
//                [weakSelf toCourseDetail];
                break;
            case BXGCourseInfoBottomTabResponseTypeOrder:
                [weakSelf toFillOrder];
                if(self.viewModel.courseModel) {
                    // 0-就业课 1-微课
                    if(self.courseModel.courseType.integerValue) {
                        // 微课
                        if(self.courseModel.isFree.integerValue) {
                            // 免费
                        }else{
                            // 精品微课
                            [[BXGBaiduStatistic share] statisticEventString:kBXGStatSamplePlayerMiniCourseEventTypeFillOrder andLabel:nil];
                        }
                    }else{
                        // 就业课
                        [[BXGBaiduStatistic share] statisticEventString:kBXGStatSamplePlayerProCourseEventTypeFillOrder andLabel:nil];
                    }
                }
                break;
        }
    };
    [self.view addSubview:bottomTabView];
    [mTableView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    UIView *spView = [UIView new];
    spView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [self.view addSubview:spView];
    [spView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(mTableView.mas_bottom);
        make.height.offset(kBottomTabbarViewSpHeight);
    }];
    [bottomTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(spView.mas_bottom).offset(0);
        make.height.offset(kBottomTabbarViewHeight);
        make.bottom.offset(0);
        make.left.right.offset(0);
    }];
    
    [mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
//        make.height.offset(100);
    }];
}
#pragma mark - Getter Setter
- (BXGCourseTryOutlineViewModel *)tryViewModel {
    if(_tryViewModel == nil) {
        _tryViewModel = [[BXGCourseTryOutlineViewModel alloc]initWithCourseId:_courseId];
    }
    return _tryViewModel;
}

#pragma mark - Load Data

- (void)loadOutline {
    
    __weak typeof (self) weakSelf = self;
    [weakSelf.view installLoadingMaskView];
    [self.tryViewModel loadDataForSampleOutlineWithFinihsed:^(NSArray<BXGCourseOutlineChapterModel *> *models) {
        [weakSelf.view removeMaskView];
        if(models){
            
            weakSelf.chapterModelArray = models;
            NSMutableArray *pointModelArray = [NSMutableArray new];
            for (NSInteger i = 0; i < models.count; i++) {
                BXGCourseOutlineChapterModel *chapter = models[i];
                for (NSInteger j = 0; j < chapter.jie.count; j++) {
                    BXGCourseOutlineSectionModel *section = chapter.jie[j];
                    [pointModelArray addObjectsFromArray:section.dian];
                }
            }
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

/// 显示咨询
- (void)showConsult {
    BXGConsultCommitViewModel *consultVM = [[BXGConsultCommitViewModel alloc]initWithSubjectId:self.courseModel.subjectId.stringValue andCourseName:self.courseModel.courseName];
    
    UIView *cview = [[BXGConsultCommitView alloc]initWithViewModel:consultVM];
//    cview.bounds = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 200);
//    UIView *cview = [[BXGConsultCommitView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 200)];

    [self rw_presentContentView:cview restrainBlock:^(UIView *view) {
        [view addSubview:cview];
        [cview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.offset(0);
        }];
    } tapMaskBlock:^{
        [self dismissViewControllerAnimated:true completion:nil];

    } completion:^{
    }andShouldAutorotate:FALSE];
}
@end
