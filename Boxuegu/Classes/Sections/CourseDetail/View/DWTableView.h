#import <UIKit/UIKit.h>

@interface DWTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

typedef NSString* (^DWTableViewTitleForHeaderInSectionBlock)(UITableView *tableView, NSInteger section);
@property (copy, nonatomic) DWTableViewTitleForHeaderInSectionBlock tableViewTitleForHeaderInSection;

typedef NSString* (^DWTableViewTitleForFooterInSectionBlock)(UITableView *tableView, NSInteger section);
@property (copy, nonatomic) DWTableViewTitleForFooterInSectionBlock tableViewTitlForFooterInSection;

typedef NSInteger(^DWTableViewNumberOfRowsInSectionBlock)(UITableView *tableView, NSInteger section);
@property (copy, nonatomic)DWTableViewNumberOfRowsInSectionBlock tableViewNumberOfRowsInSection;

typedef UITableViewCell *(^DWTableViewCellForRowAtIndexPathBlock)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy, nonatomic)DWTableViewCellForRowAtIndexPathBlock tableViewCellForRowAtIndexPath;

typedef void(^DWTableViewDidSelectRowAtIndexPathBlock)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy, nonatomic)DWTableViewDidSelectRowAtIndexPathBlock tableViewDidSelectRowAtIndexPath;

typedef void(^DWTableViewDidDeselectRowAtIndexPathBlock)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy, nonatomic)DWTableViewDidDeselectRowAtIndexPathBlock tableViewDidDeselectRowAtIndexPath;

//typedef BOOL (^DWTableViewCanEditRowAtIndexPathBlock)(UITableView *tableView, NSIndexPath *indexPath);
//@property (copy, nonatomic)DWTableViewCanEditRowAtIndexPathBlock  tableViewCanEditRowAtIndexPath;

//typedef UITableViewCellEditingStyle (^DWTableViewEditingStyleForRowAtIndexPathBlock)(UITableView *tableView, NSIndexPath *indexPath);
//@property (copy, nonatomic)DWTableViewEditingStyleForRowAtIndexPathBlock tableViewEditingStyleForRowAtIndexPath;
//
//typedef void (^DWTableViewCommitEditingStyleforRowAtIndexPathBlock)(UITableView * tableView, UITableViewCellEditingStyle editingStyle, NSIndexPath *indexPath);
//@property (copy, nonatomic)DWTableViewCommitEditingStyleforRowAtIndexPathBlock tableViewCommitEditingStyleforRowAtIndexPath;

typedef void (^DWTableViewDeleteRowsAtIndexPathsBlock)(NSArray<NSIndexPath *> *indexPaths, UITableViewRowAnimation animation);
@property (copy, nonatomic)DWTableViewDeleteRowsAtIndexPathsBlock tableViewDeleteRowsAtIndexPaths;

typedef NSInteger (^DWNumberOfSectionsInTableViewBlock)(UITableView * tableView);
@property (copy, nonatomic)DWNumberOfSectionsInTableViewBlock numberOfSectionsInTableView;

typedef void(^DWTableViewWillDisplayCellForRowAtIndexPathBlock)(UITableView* tableView, UITableViewCell* cell, NSIndexPath* indexPath);
@property (copy, nonatomic)DWTableViewWillDisplayCellForRowAtIndexPathBlock tableViewWillDisplayCellForRowAtIndexPath;

typedef void(^DWTableViewDidEndDisplayingCellForRowAtIndexPathBlock)(UITableView* tableView, UITableViewCell* cell, NSIndexPath* indexPath);
@property (copy, nonatomic)DWTableViewDidEndDisplayingCellForRowAtIndexPathBlock tablViewDidEndDisplayingCellForRowAtIndexPath;

typedef UIView* (^DWTableViewViewForHeaderInSectionBlock)(UITableView* tableView, NSInteger section);
@property (copy, nonatomic) DWTableViewViewForHeaderInSectionBlock tableViewViewForHeaderInSection;

//typedef UIView* (^DWTableViewViewForFooterInSectionBlock)(UITableView* tableView, NSInteger section);
//@property (copy, nonatomic) DWTableViewViewForFooterInSectionBlock tableViewViewForFooterInSection;

typedef CGFloat (^DWTableViewHeightForRowAtIndexPathBlock)(UITableView *tableView, NSIndexPath *indexPath);
@property(nonatomic, copy) DWTableViewHeightForRowAtIndexPathBlock tableViewHeightForRowAtIndexPath;

typedef CGFloat (^DWTableViewHeightForHeaderInSectionBlock)(UITableView *tableView, NSInteger section);
@property(nonatomic, copy) DWTableViewHeightForHeaderInSectionBlock tableViewHeightForHeaderInSection;

//typedef CGFloat (^DWTableViewHeightForFooterInSectionBlock)(UITableView *tableView, NSInteger section);
//@property(nonatomic, copy) DWTableViewHeightForFooterInSectionBlock tableViewHeightForFooterInSection;

- (void)resetDelegate;

@end
