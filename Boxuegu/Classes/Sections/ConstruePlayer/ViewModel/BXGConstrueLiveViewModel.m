//
//  BXGConstrueLiveViewModel.m
//  Boxuegu
//
//  Created by wurenying on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGConstrueLiveViewModel.h"
#import "BXGConstrueIntroduceModel.h"
#import "BXGConstrueReplayModel.h"

@implementation BXGConstrueLiveViewModel


- (void)loadConstrueIntroducePlanId:(NSString *)planId Finished:(void(^)(BXGConstrueIntroduceModel *model, NSString * msg))finished {
    
    [self.networkTool appRequestConstrueIntroduceWithPlanId:planId Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status == 200 && [result isKindOfClass:[NSDictionary class]]) {
            
            BXGConstrueIntroduceModel *model = [BXGConstrueIntroduceModel yy_modelWithDictionary:result];
            if(model) {
                finished(model,@"加载成功");
                return;
            }
        }
        // 失败回调
        finished(nil,message);
        return;
    }];
}

- (void)loadConstrueReplayListWithPlanId:(NSString *)planId Finished:(void(^)(NSArray<BXGConstrueReplayModel *> *modelArray, NSString * msg))finished {
//    NSString *planId = @"104";
    [self.networkTool appRequestConstrueReplayListWithPlanId:planId Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status == 200 && [result isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *modelArray = [NSMutableArray new];
            for(NSInteger i = 0; i < [result count]; i++) {
                BXGConstrueReplayModel *model = [BXGConstrueReplayModel yy_modelWithDictionary:result[i]];
                [modelArray addObject:model];
            }
            // 成功
            finished(modelArray.copy,@"加载成功");
            return;
        }
        // 失败回调
        finished(nil,message);
        return;
    }];
}



///// 直播: 课程简介 /bxg/appConstruePlan/getConstruePlanById
//- (void)appRequestConstrueIntroduceWithPlanId:(NSString * _Nullable)planId
//                                     Finished:(BXGNetworkCallbackBlockType _Nullable)finished;
//
///// 直播: 回放列表 /bxg/appConstruePlan/getCallBackPlanById
//- (void)appRequestConstrueReplayListWithPlanId:(NSString * _Nullable)planId
//                                      Finished:(BXGNetworkCallbackBlockType _Nullable)finished;
//
///// 直播: 获取直播状态 /bxg/appConstruePlan/checkPlanStatusById
//- (void)appRequestConstrueCheckStatusWithPlanId:(NSString * _Nullable)planId
//                                       Finished:(BXGNetworkCallbackBlockType _Nullable)finished;
@end
