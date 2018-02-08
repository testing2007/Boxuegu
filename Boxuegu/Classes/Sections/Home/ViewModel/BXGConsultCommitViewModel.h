//
//  BXGConsultCommitViewModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/11/1.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"

@interface BXGConsultCommitViewModel : BXGBaseViewModel
- (void)postConsultCollectRecordWithName:(NSString *)name andWechat:(NSString *)wechat andQQ:(NSString *)qq andMobile:(NSString *)mobile Finished:(void(^)(BOOL succeed, NSString *msg))finished;
- (void)loadApplyInfoWithFinished:(void(^)(BOOL succeed, NSString *msg))finished;
- (void)loadConsultTelWithFinished:(void(^)(NSString *telString, NSString *msg))finished;

- (instancetype)initWithSubjectId:(NSString *)subjectId andCourseName:(NSString *)courseName;
- (instancetype)initWithSubjectName:(NSString *)subjectName andCourseName:(NSString *)courseName;
@end
