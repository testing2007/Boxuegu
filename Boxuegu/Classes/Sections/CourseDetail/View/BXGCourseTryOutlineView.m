//
//  BXGCourseTryOutlineView.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//
#import "BXGCourseTryOutlineViewModel.h"
#import "BXGCourseTryOutlineView.h"
#import "RWMultiTableView.h"
#import "BXGStudyChapterHeaderView.h"
#import "BXGCourseInfoPointCell.h"
#import "BXGCourseOutlineTryCell.h"

#import "BXGCourseInfoChapterModel.h"
#import "BXGCourseInfoSectionModel.h"
#import "BXGCourseInfoPointModel.h"
#import "BXGCourseInfoVideoModel.h"
#import "BXGPlayListPointCell.h"

@interface BXGCourseTryOutlineView()
@property (nonatomic, strong) BXGCourseTryOutlineViewModel *viewModel;
@property (nonatomic, strong) NSString *courseId;
@property (nonatomic, strong) RWMultiTableView *mTableView;
@property (nonatomic, strong) NSArray *chapterModels;
@end

@implementation BXGCourseTryOutlineView

- (BXGCourseTryOutlineViewModel *)viewModel {
    if(_viewModel == nil){
        _viewModel = [[BXGCourseTryOutlineViewModel alloc]initWithCourseId:_courseId];
    }
    return _viewModel;
}

- (instancetype)initWithCourseId:(NSString *)courseId {
    self = [super initWithFrame:CGRectZero];
    if(self){
        Weak(weakSelf);
        _courseId = courseId;
        [self installUI];
        [self.viewModel loadDataForSampleOutlineWithFinihsed:^(NSArray<BXGCourseInfoChapterModel *> *models) {
            weakSelf.chapterModels = models;
            [weakSelf updateUI];
        }];
    }
    return self;
}
- (void)updateUI{
    [self.mTableView installDataSourse];
    [self.mTableView reloadData];
}

- (void)installUI {
    Weak(weakSelf);
    
    RWMultiTableView *mTableView = [RWMultiTableView new];
    [self addSubview:mTableView];
    weakSelf.mTableView = mTableView;
    if (@available(iOS 11.0, *)) {
        mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    };
    
    // Config
    mTableView.backgroundColor = [UIColor grayColor];
    mTableView.bounces = false;
    [mTableView registerClass:[BXGStudyChapterHeaderView class] forHeaderFooterViewReuseIdentifier:@"BXGStudyPlayListHeaderCell"];
    [mTableView registerClass:[BXGPlayListPointCell class] forCellReuseIdentifier:@"BXGPlayListPointCell"];
    [mTableView registerClass:[BXGCourseInfoPointCell class] forCellReuseIdentifier:@"BXGCourseInfoPointCell"];
    [mTableView registerClass:[BXGCourseOutlineTryCell class] forCellReuseIdentifier:@"BXGCourseOutlineTryCell"];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Layout
    [mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    // Data Sourse
    mTableView.rootModelForTableViewBlock = ^NSArray *(UITableView *tableView) {
        return weakSelf.chapterModels;
    };
    mTableView.subModelsForTableViewBlock = ^NSArray *(UITableView *tableView, NSInteger section, RWMultiItem *parentItem) {
        if(parentItem.model) {
            if([parentItem.model isKindOfClass:[BXGCourseInfoChapterModel class]]){
                BXGCourseInfoChapterModel *chapterModel = (BXGCourseInfoChapterModel *)parentItem.model;
                NSMutableArray *array = [NSMutableArray new];
                for (NSInteger i = 0; i < chapterModel.chapters.count; i++) {
                    [array addObjectsFromArray:chapterModel.chapters[i].points];
                }
                return array;
            }
            if([parentItem.model isKindOfClass:[BXGCourseInfoPointModel class]]){
                BXGCourseInfoPointModel *pointModel = (BXGCourseInfoPointModel *)parentItem.model;
                return pointModel.videos;
            }
        }
        return nil;
    };
    
    mTableView.cellForRowBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, RWMultiItem *item) {
        
        if(item.model) {
            if([item.model isKindOfClass:[BXGCourseInfoPointModel class]]) {
                BXGPlayListPointCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGPlayListPointCell" forIndexPath:indexPath];
                cell.infoPointModel = (BXGCourseInfoPointModel *)item.model;
                return cell;
            }
            if([item.model isKindOfClass:[BXGCourseInfoVideoModel class]]) {
                BXGCourseOutlineTryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGCourseOutlineTryCell" forIndexPath:indexPath];
                cell.model = (BXGCourseInfoVideoModel *)item.model;
                cell.isPlaying = false;
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
        if([item.model isKindOfClass:[BXGCourseInfoChapterModel class]]) {
            BXGCourseInfoChapterModel *chapterModel = (BXGCourseInfoChapterModel *)item.model;
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
            
            //BXGCourseOutlineVideoModel *videoModel = (BXGCourseOutlineVideoModel *)item.model;
            //            if(weakSelf.clickVideoModelBlock) {
            //
            //                weakSelf.clickVideoModelBlock(item.model);
            //            };
        }
    };
    
    [mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
}
@end
