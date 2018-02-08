//
//  BXGConstruePlanViewModel.h
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"

typedef NS_ENUM(NSUInteger, BXGConstruePlanStatus) {
    BXGConstruePlanStatusNone = -1,     // 未知状态
    BXGConstruePlanStatusNotStart = 0,  // 直播未开始
    BXGConstruePlanStatusOnAir = 1,     // 正在直播
    BXGConstruePlanStatusEnded = 2,     // 直播已结束 (未生成回放)
    BXGConstruePlanStatusReplay = 3,    // 直播已结束 (已生成回放)
};

@class BXGConstruePlanMonthItemModel;
@class BXGConstruePlanDayModel;

/**
 直播计划 ViewModel
 */
@interface BXGConstruePlanViewModel : BXGBaseViewModel

/**
 获取直播月计划
 
 @param menuId 学科方向id (目前服务端已做处理 客户端设置为nil就可以)
 */
- (void)loadConstruePlanByMonthWithMenuId:(NSString * _Nullable)menuId
                                 Finished:(void(^_Nullable)(NSArray<BXGConstruePlanMonthItemModel *> * _Nullable modelArray,
                                                            NSString * _Nullable msg))finished;

/**
 获取直播日计划

 @param day 获取计划的日期
 @param menuId 学科方向id (目前服务端已做处理 客户端设置为nil就可以)
 */
- (void)loadConstruePlanByDay:(NSDate *_Nullable)day
                   WithMenuId:(NSString * _Nullable)menuId
                     Finished:(void(^_Nullable)(NSArray<BXGConstruePlanDayModel *> * _Nullable modelArray,
                                                NSString * _Nullable msg))finished;

/**
 获取直播计划状态

 @param planId 直播计划id
 */
- (void)checkConstrueStatusWithPlanId:(NSString * _Nullable)planId Finished:(void(^_Nullable)(NSString * _Nullable planId, BXGConstruePlanStatus status, NSString * _Nullable msg))finished;
@end
