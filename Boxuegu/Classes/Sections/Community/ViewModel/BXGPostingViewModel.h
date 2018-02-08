//
//  BXGPostingViewModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
#import "BXGPostTopicModel.h"
#import "BXGCommunityUserModel.h"
@interface BXGPostingViewModel : BXGBaseViewModel

- (void)loadPostTopicListWithFinished:(void(^)(NSArray<BXGPostTopicModel *>* topicModelArray))finishedBlock;
- (void)loadMyFanListWithUUID:(NSNumber *)uuid andisUpdate:(BOOL)isRefresh andFinished:(void(^)(NSArray *modelArray))finishedBlock;
- (void)loadAttentionPersonListWithUUID:(NSNumber *)uuid andIsMore:(BOOL)isMore andFinished:(void(^)(NSArray *modelArray,BOOL isLast))finishedBlock;


// 添加 已选择的提醒用户
// - (void)

// 读取 已选择提醒用户

@property (nonatomic, strong) NSMutableArray<BXGCommunityUserModel *> *selectedCommunityUserModelArray;
@end
