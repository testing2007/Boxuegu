//
//  BXGConstrueLiveViewModel.h
//  Boxuegu
//
//  Created by wurenying on 2018/1/11.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"

@class BXGConstrueIntroduceModel;
@class BXGConstrueReplayModel;

@interface BXGConstrueLiveViewModel : BXGBaseViewModel

- (void)loadConstrueIntroducePlanId:(NSString *)planId Finished:(void(^)(BXGConstrueIntroduceModel *model, NSString * msg))finished;

- (void)loadConstrueReplayListWithPlanId:(NSString *)planId Finished:(void(^)(NSArray<BXGConstrueReplayModel *> *modelArray, NSString * msg))finished;

@end
