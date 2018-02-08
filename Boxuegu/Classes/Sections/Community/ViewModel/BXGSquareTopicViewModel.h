//
//  BXGSquareTopicViewModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"

@interface BXGSquareTopicViewModel : BXGBaseViewModel
- (instancetype)initWithTopicId:(NSNumber *)topicId;
- (void)loadPostListWithTopicId:(NSNumber *)topicId isReflesh:(BOOL)isReflesh andFinished:(void(^)(NSArray *modelArray,BOOL isNoMore))finishedBlock;
@end
