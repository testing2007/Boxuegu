//
//  BXGCourseDetailCriticizedViewModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
@class BXGStudentCriticizeTotalModel;
@interface BXGCourseDetailCriticizedViewModel : BXGBaseViewModel
@property (nonatomic, assign) BOOL praiseCourseIsEnd;
- (instancetype _Nonnull )initWithCourseId:(NSString * _Nullable)courseId;
- (void)loadStudentCriticizedListWithRefresh:(BOOL)isRefresh
                            andFinishedBlock:(void(^ _Nullable)(BOOL success,BXGStudentCriticizeTotalModel * _Nullable totalModel, NSArray * _Nullable modelArray, NSString * _Nullable message))finishedBlock;
@end
