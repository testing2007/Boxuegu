//
//  BXGReportViewModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
#import "BXGReportTypeModel.h"

@interface BXGReportViewModel : BXGBaseViewModel
- (void)loadReportTypeListWithFinished:(void(^)(NSArray<BXGReportTypeModel *> *modelArray))finishedBlock;

- (void)reportPostWithReportTypeId:(NSNumber *)reportTypeId content:(NSString *)content reportUserId:(NSNumber *)reportUserId postId:(NSNumber *)postId finished:(void(^)(BOOL succeed))finishedBlock;

- (void)reportCommentWithReportTypeId:(NSNumber *)reportTypeId content:(NSString *)content reportUserId:(NSNumber *)reportUserId postId:(NSNumber *)postId commentId:(NSNumber *)commentId finished:(void(^)(BOOL succeed))finishedBlock;
@end
