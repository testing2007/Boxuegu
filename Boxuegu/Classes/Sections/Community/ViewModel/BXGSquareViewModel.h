//
//  BXGSquareViewModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
#import "BXGPostTopicModel.h"
#import "BXGCommunityUserModel.h"

@interface BXGSquareViewModel : BXGBaseViewModel
- (void)loadPostTopicListWithFinished:(void(^)(NSArray<BXGPostTopicModel *>* topicModelArray))finishedBlock;
@end
