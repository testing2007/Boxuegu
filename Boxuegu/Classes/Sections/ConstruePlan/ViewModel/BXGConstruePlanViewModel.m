//
//  BXGConstruePlanViewModel.m
//  Boxuegu
//
//  Created by Renying Wu on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGConstruePlanViewModel.h"
#import "BXGConstruePlanMonthItemModel.h"
#import "BXGConstruePlanDayModel.h"
#import "BXGConstruePlanStatusModel.h"

@implementation BXGConstruePlanViewModel

/**
 获取直播月计划
 
 @param menuId 学科方向id (目前服务端已做处理 客户端设置为nil就可以)
 */
- (void)loadConstruePlanByMonthWithMenuId:(NSString * _Nullable)menuId
                                 Finished:(void(^_Nullable)(NSArray<BXGConstruePlanMonthItemModel *> * _Nullable modelArray,
                                                            NSString * _Nullable msg))finished {
    
    [self.networkTool appRequestConstruePlanByMonthWithMenuId:nil Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status == 200 && [result isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray new];
            for(NSInteger i = 0; i < [result count]; i++) {
                BXGConstruePlanMonthItemModel *model = [BXGConstruePlanMonthItemModel yy_modelWithDictionary:result[i]];
                if(model) {
                    [array addObject:model];
                }
            }
            finished(array.copy, @"加载成功");
            return;
        }
        finished(nil,message);
        return;
    }];
}

/**
 获取直播日计划
 
 @param day 获取计划的日期
 @param menuId 学科方向id (目前服务端已做处理 客户端设置为nil就可以)
 */
- (void)loadConstruePlanByDay:(NSDate *_Nullable)day
                   WithMenuId:(NSString * _Nullable)menuId
                     Finished:(void(^_Nullable)(NSArray<BXGConstruePlanDayModel *> * _Nullable modelArray,
                                                NSString * _Nullable msg))finished {
    
    NSString *formatDate = [[BXGDateTool share] formaterForRequest:day];
    
    [self.networkTool appRequestConstruePlanByDayWithMenuId:nil Day:formatDate Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status == 200 && [result isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray new];
            for(NSInteger i = 0; i < [result count]; i++) {
                BXGConstruePlanDayModel *model = [BXGConstruePlanDayModel yy_modelWithDictionary:result[i]];
                if(model) {
                    [array addObject:model];
                }
            }
            finished(array.copy,@"加载成功");
            return;
        }
        finished(nil,message);
    }];
}

/**
 获取直播计划状态
 
 @param planId 直播计划id
 */
- (void)checkConstrueStatusWithPlanId:(NSString * _Nullable)planId Finished:(void(^_Nullable)(NSString * _Nullable planId, BXGConstruePlanStatus status, NSString * _Nullable msg))finished {
    
    [self.networkTool appRequestConstrueCheckStatusWithPlanId:planId Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status == 200 && [result isKindOfClass:[NSDictionary class]]) {
            
           BXGConstruePlanStatusModel *model = [BXGConstruePlanStatusModel yy_modelWithDictionary:result];
            if(model && model.idx && model.status){
                // 成功回调
                finished(model.idx, model.status.integerValue, @"加载成功");
                return;
            }
        }
        // 失败回调
        finished(nil, -1, message);
        return;
    }];
}

@end
