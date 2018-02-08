//
//  BXGStudyPlayerListTableViewController.h
//  Boxuegu
//
//  Created by RW on 2017/4/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWMultiDataSourse.h"
@class RWMultiTableView;
typedef CGFloat(^HeightForRowBlockType)(RWMultiTableView *tableView,NSInteger section, RWMultiItem *item);
typedef CGFloat(^HeightForHeaderInSectionBlockType)(RWMultiTableView *tableView,NSInteger section);
typedef UIView *(^ViewForHeaderInSectionBlockType)(RWMultiTableView *tableView,NSInteger section, RWMultiItem *item);
typedef void(^DidSelectRowBlockType)(RWMultiTableView *tableView, NSIndexPath *indexPath, RWMultiItem *item);
typedef NSArray *(^RootModelForTableViewBlockType)(RWMultiTableView *tableView);
typedef NSArray *(^SubModelsForTableViewBlockType)(RWMultiTableView *tableView,NSInteger section, RWMultiItem *parentItem);
typedef void(^EndLayoutSubviewsBlockType)(RWMultiTableView *tableView);
typedef UITableViewCell*(^CellForRowBlockType)(RWMultiTableView *tableView, NSIndexPath *indexPath, RWMultiItem *item);
typedef void(^DidSelectHeaderViewAtSectionBlockType)(RWMultiTableView *tableView, NSInteger section, RWMultiItem *item);
typedef void(^WillDisplayCellBlockType)(RWMultiTableView *tableView,UITableViewCell *cell,NSIndexPath *indexPath, RWMultiItem *item);
typedef void(^DidEndDisplayingCellBlockType)(RWMultiTableView *tableView,UITableViewCell *cell,NSIndexPath *indexPath, RWMultiItem *item);
typedef BOOL(^EnumerateAllItemBlockType)(RWMultiTableView *tableView,RWMultiItem *item);
typedef void(^ScrollViewDidScrollBlockType)(UIScrollView *scrollView);

@interface RWMultiTableView : UITableView

@property (nonatomic, strong) NSMutableArray<RWMultiDataSourse *> *sectionDataSourseArray;

@property (nonatomic, copy) CellForRowBlockType cellForRowBlock;

@property (nonatomic, copy) RootModelForTableViewBlockType rootModelForTableViewBlock;
@property (nonatomic, copy) SubModelsForTableViewBlockType subModelsForTableViewBlock;



#pragma mark - delegate
@property (nonatomic, copy) DidSelectRowBlockType didSelectRowBlock;
//@property (nonatomic, copy) DidDeselectRowBlockType didDeselectRowBlock;

@property (nonatomic, copy) HeightForRowBlockType heightForRowBlock;
@property (nonatomic, copy) DidSelectHeaderViewAtSectionBlockType didSelectHeaderViewAtSectionBlock;
@property (nonatomic, copy) HeightForHeaderInSectionBlockType heightForHeaderInSectionBlock;
@property (nonatomic, copy) ViewForHeaderInSectionBlockType viewForHeaderInSectionBlock;

@property (nonatomic, copy) EndLayoutSubviewsBlockType endLayoutSubviewsBlock;

@property (nonatomic, copy) WillDisplayCellBlockType willDisplayCellBlock;
@property (nonatomic, copy) DidEndDisplayingCellBlockType didEndDisplayingCellBlock;
@property (nonatomic, copy) ScrollViewDidScrollBlockType scrollViewDidScrollBlock;
typedef void(^willDisplayCell)(RWMultiTableView *tableView,UITableViewCell *cell,NSInteger section, RWMultiItem *item);
typedef void(^didEndDisplayingCell)(RWMultiTableView *tableView,UITableViewCell *cell,NSInteger section, RWMultiItem *item);


-(void) multiTableViewReloadData;

- (void)reloadDataWithFinishedBlock:(EndLayoutSubviewsBlockType)endBlock;
- (void)reloadVisibleData;
- (void)installDataSourse;

#pragma mark - operation
- (void)openSection:(NSInteger)section;
- (void)openAllSection;
- (void)closeSection:(NSInteger)section;
- (RWMultiItem *)searchItemWithModel:(id)model;
- (RWMultiItem *)searchItemWithItem:(RWMultiItem *)item;
- (NSIndexPath *)indexPathForItem:(RWMultiItem *)item;
- (NSInteger)sectionForItem:(RWMultiItem *)item;
- (void)scrollToItem:(RWMultiItem *)item;
- (void)openSectionWithItem:(RWMultiItem *)item;
- (void)enumerateAllItem:(EnumerateAllItemBlockType)enumerateBlock;
@end
