//
//  RWTableView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/14.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ScrollViewDidScrollBlockType)(UIScrollView *scrollView);
@interface RWTableView : UITableView
// - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

#pragma mark - Data Sourse
@property (nonatomic, copy) NSInteger(^numberOfRowsInSectionBlock)(__weak UITableView *tableView, NSInteger section);

@property (nonatomic, copy) NSInteger(^numberOfSectionsInTableViewBlock)(__weak UITableView *tableView);

@property (nonatomic, copy) UITableViewCell *(^cellForRowAtIndexPathBlock)(__weak UITableView *tableView,__weak NSIndexPath *indexPath);


#pragma mark - Delegate
@property (nonatomic, copy) void(^didSelectRowAtIndexPathBlock)(__weak UITableView *tableView,__weak NSIndexPath *indexPath);
@property (nonatomic, copy) UIView *(^viewForHeaderInSectionBlock)(__weak UITableView *tableView, NSInteger section);
@property (nonatomic, copy) UIView *(^viewForFooterInSectionBlock)(__weak UITableView *tableView, NSInteger section);
@property (nonatomic, copy) CGFloat(^heightForHeaderInSectionBlock)(__weak UITableView *tableView, NSInteger section);
@property (nonatomic, copy) CGFloat(^heightForFooterInSectionBlock)(__weak UITableView *tableView, NSInteger section);
@property (nonatomic, copy) ScrollViewDidScrollBlockType scrollViewDidScrollBlock;
@end
