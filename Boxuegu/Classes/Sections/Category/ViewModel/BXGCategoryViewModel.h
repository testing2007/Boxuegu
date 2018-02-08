//
//  BXGCategoryViewModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
#import "BXGCategorySubjectModel.h"
#import "BXGHomeCourseModel.h"
#import "BXGCategoryMiniCourseModel.h"

@interface BXGCategoryViewModel : BXGBaseViewModel
- (void)loadCourseCategorySubjectWithFinished:(void(^)(NSMutableArray<BXGCategorySubjectModel*> *models))finishedBlock;
- (void)loadCourseCategoryInfoWithSubjectId:(NSString *)subjectId
                                andFinished:(void(^)(BOOL succeed, BXGHomeCourseModel *proCourseModel,
                                                     NSArray<BXGCategoryMiniCourseModel *> *miniCourseModels))finishedBlock;
@end
