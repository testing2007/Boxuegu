//
//  UIExtTableView.h
//  demo-CCMedia
//
//  Created by RW on 2017/6/7.
//  Copyright © 2017年 Renying Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIExtTableView : UITableView

#pragma mark - Data Sourse
@property (nonatomic, copy) NSInteger(^numberOfRowsInSectionBlock)(__weak UITableView *tableView, NSInteger section);

@property (nonatomic, copy) NSInteger(^numberOfSectionsInTableViewBlock)(__weak UITableView *tableView);

@property (nonatomic, copy) UITableViewCell *(^cellForRowAtIndexPathBlock)(__weak UITableView *tableView,__weak NSIndexPath *indexPath);

#pragma mark - Delegate
@property (nonatomic, copy) void(^didSelectRowAtIndexPathBlock)(__weak UITableView *tableView,__weak NSIndexPath *indexPath);

@end
