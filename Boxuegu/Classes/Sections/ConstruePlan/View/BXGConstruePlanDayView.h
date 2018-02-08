//
//  BXGConstruePlanDayView.h
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BXGConstruePlanDayModel;

@interface BXGConstruePlanDayView : UIView
@property (nonatomic, strong) NSArray<BXGConstruePlanDayModel *> *modelArray;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) void(^onScrollToTopBlock)(BOOL isTop);
@property (nonatomic, copy) void(^onClickPlanBlock)(NSString *planId);
@property (nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UITableView *contentView;
@end
