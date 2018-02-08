//
//  BXGProDayPlanModel.h
//  Boxuegu
//
//  Created by RW on 2017/4/26.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGProCourseModel.h"

/**
 职业课程天计划模型
 */
@interface BXGProDayPlanModel : BXGBaseModel

/// 是否休息
@property (nonatomic, assign) BOOL rest_has;

/// 是否有串讲
@property (nonatomic, assign) BOOL chuanjiang_has;

/// 计划Id
@property (nonatomic, strong) NSString * plan_id;

/// 职业课程知识点信息
@property (nonatomic, strong) NSMutableArray<BXGProCourseModel *> *list;

/// 是否加载失败
@property (nonatomic, assign) BOOL isFailed;

@end
