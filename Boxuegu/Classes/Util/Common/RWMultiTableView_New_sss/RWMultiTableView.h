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
typedef void(^DidSelectRowBlockType)(RWMultiTableView *tableView, NSIndexPath* indexPath, RWMultiItem *item);

//typedef void(^DidDeselectRowBlockType)(UITableView *tableView, NSIndexPath *indexPath, RWMultiItem *item);
typedef NSArray *(^RootModelForTableViewBlockType)(RWMultiTableView *tableView);
typedef NSArray *(^SubModelsForTableViewBlockType)(RWMultiTableView *tableView,NSInteger section, RWMultiItem *parentItem);
typedef void(^EndLayoutSubviewsBlockType)(RWMultiTableView *tableView);

#pragma mark - DataSourse
typedef NSInteger(^NumberOfSectionsBlockType)(RWMultiTableView *tableView);
typedef NSInteger(^NumberOfLevelBlockType)(RWMultiTableView *tableView, NSInteger section);
typedef NSInteger(^NumberOfRowBlockType)(RWMultiTableView *tableView,NSInteger section, NSInteger level);

typedef UITableViewCell*(^CellForRowBlockType)(RWMultiTableView *tableView, NSIndexPath *indexPath, RWMultiItem *item);
typedef void(^DidSelectHeaderViewAtSectionBlockType)(RWMultiTableView *tableView, NSInteger section, RWMultiItem *item);

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
- (void)reloadDataWithFinishedBlock:(EndLayoutSubviewsBlockType)endBlock;
- (void)installDataSourse;

#pragma mark - operation
- (void)openSection:(NSInteger)section;
- (void)openAllSection;
- (void)closeSection:(NSInteger)section;
- (RWMultiItem *)searchItemWithModel:(id)model;




@end
