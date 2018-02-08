//
//  BXGCourseTryOutlineViewModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
@class BXGCourseOutlineChapterModel;
@interface BXGCourseTryOutlineViewModel : BXGBaseViewModel
- (instancetype)initWithCourseId:(NSString *)courseId;
- (void)loadDataForSampleOutlineWithFinihsed:(void(^)(NSArray<BXGCourseOutlineChapterModel *> *models))finished;
@end
