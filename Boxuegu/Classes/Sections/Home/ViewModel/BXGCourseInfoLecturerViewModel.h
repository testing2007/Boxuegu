//
//  BXGCourseInfoLecturerViewModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
@class BXGCourseLecturerModel;
@interface BXGCourseInfoLecturerViewModel : BXGBaseViewModel
- (instancetype)initWithCourseId:(NSString *)courseId;
- (void)loadCourseCourseLecturerWithFinished:(void (^)(NSArray<BXGCourseLecturerModel *> *lecturerModels))finishedBlock;
@end
