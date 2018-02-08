//
//  BXGCourseInfoOutlineVC.m
//  boxueguDemo
//
//  Created by RenyingWu on 2017/10/17.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import "BXGCourseInfoOutlineVC.h"
#import "RWMultiTableView.h"
#import <Masonry.h>
#import "BXGStudyChapterHeaderView.h"
#import "BXGPlayerListSectionCell.h"
#import "BXGPlayListPointCell.h"
#import "BXGPlayListItemCell.h"
#import "BXGCourseInfoSectionModel.h"
#import "BXGCourseInfoPointModel.h"
#import "BXGCourseInfoPointCell.h"
#import "BXGCourseInfoOutlineViewModel.h"

@interface BXGCourseInfoOutlineVC ()
@property (nonatomic, strong) RWMultiTableView *mTableView;
@property (nonatomic, strong) NSArray *courseOutlineArray;
@property (nonatomic, strong) BXGCourseInfoOutlineViewModel *viewModel;
@property (nonatomic, strong) NSArray<BXGCourseInfoChapterModel *> *chapterModels;
@end

@implementation BXGCourseInfoOutlineVC

#pragma mark - Interface

- (instancetype)initWithViewModel:(BXGCourseInfoOutlineViewModel *)viewModel {
    self = [super init];
    if(self) {
        _viewModel = viewModel;
    }
    return self;
}

#pragma mark - Getter / Setter

- (void)setChapterModels:(NSArray<BXGCourseInfoChapterModel *> *)chapterModels {
    Weak(weakSelf);
    _chapterModels = chapterModels;
    [self.mTableView installDataSourse];
    if(_chapterModels.firstObject) {
        [weakSelf.mTableView openSection:0];
    }
     [weakSelf.mTableView reloadData];
}

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    [self installUI];
    [self loadData];

}
#pragma mark - Data

- (void)loadData {
    
    Weak(weakSelf);
    [self.view installLoadingMaskView];
    [self.viewModel loadCourseInfoOutlineWithFinishedBlock:^(NSMutableArray<BXGCourseInfoChapterModel *> *chapterModels) {
        [weakSelf.view removeMaskView];
        [weakSelf.mTableView removeMaskView];
        
        if(chapterModels == nil) {
            
            [weakSelf.mTableView installMaskView:BXGButtonMaskViewTypeLoadFailed andInset:UIEdgeInsetsMake(0, 0, 0, 0) buttonBlock:^{
                [weakSelf loadData];
            }];
            return;
        }
        
        if(chapterModels.count <= 0) {
            [self.mTableView installMaskView:BXGMaskViewTypeNoData];
            return;
        }
        
        weakSelf.chapterModels = chapterModels;
    }];
}

#pragma mark - UI

- (void)installUI {
    Weak(weakSelf);
    RWMultiTableView *mTableView = [RWMultiTableView new];
    [self.view addSubview:mTableView];
    weakSelf.mTableView = mTableView;
    if (@available(iOS 11.0, *)) {
        mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    };
                                                 
    // Config
    mTableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    [mTableView registerClass:[BXGStudyChapterHeaderView class] forHeaderFooterViewReuseIdentifier:@"BXGStudyPlayListHeaderCell"];
    [mTableView registerClass:[BXGPlayerListSectionCell class] forCellReuseIdentifier:@"BXGPlayerListSectionCell"];
    [mTableView registerClass:[BXGPlayListPointCell class] forCellReuseIdentifier:@"BXGPlayListPointCell"];
    [mTableView registerClass:[BXGCourseInfoPointCell class] forCellReuseIdentifier:@"BXGCourseInfoPointCell"];
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
                return chapterModel.chapters;
            }
            if([parentItem.model isKindOfClass:[BXGCourseInfoSectionModel class]]){
                
                BXGCourseInfoSectionModel *sectionModel = (BXGCourseInfoSectionModel *)parentItem.model;
                return sectionModel.points;
            }
        }
        return nil;
    };
    mTableView.cellForRowBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, RWMultiItem *item) {
        if(item.model) {
            if([item.model isKindOfClass:[BXGCourseInfoSectionModel class]]) {
                BXGPlayListPointCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGPlayListPointCell" forIndexPath:indexPath];
                cell.sectionModel = (BXGCourseInfoSectionModel *)item.model;
                return cell;
            }
            if([item.model isKindOfClass:[BXGCourseInfoPointModel class]]) {
                BXGCourseInfoPointCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BXGCourseInfoPointCell" forIndexPath:indexPath];
                cell.pointModel = (BXGCourseInfoPointModel *)item.model;
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
            [tableView reloadVisibleData];
        }else {
            [tableView openSection:section];
            item.isOpen = true;
            [tableView reloadVisibleData];
        }
    };
    mTableView.didSelectRowBlock = ^(RWMultiTableView *tableView, NSIndexPath *indexPath, RWMultiItem *item) {
        if([item.model isKindOfClass:[BXGCourseOutlineVideoModel class]]) {
            
        }
    };
    mTableView.scrollViewDidScrollBlock = ^(UIScrollView *scrollView) {
        [weakSelf.foldDelegate checkFoldWithScrollView:scrollView];
    };
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.foldDelegate checkFoldWithScrollView:scrollView];
}
@end
