//
//  BXGHomeViewModel.h
//  Boxuegu
//
//  Created by apple on 2017/10/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"

@class BXGHomeCourseListModel;
@class BXGHomeCourseModel;
@class BXGMicroFilterModel;
@class BXGBannerModel;

@interface BXGHomeViewModel : BXGBaseViewModel

- (void)loadCourseInfoFinished:(void(^)(BOOL bSuccess, BXGHomeCourseListModel *courseListModel))finishedBlock;

- (void)loadMoreCareerCourseFinished:(void(^)(BOOL bSuccess, NSArray<BXGHomeCourseModel*> *arrCourseModel))finishedBlock;

- (void)loadFilterCourseInfoWithCourseType:(NSNumber *)courseType
                              andMicroType:(NSNumber *)microType
                            andFinishBlock:(void(^)(BOOL bSuccess, BXGMicroFilterModel *model))finishedBlock;

- (void)loadFilterCourseInfoWithRefresh:(BOOL)bRefresh
                         andDirectionId:(NSNumber *)directionId
                           andSubjectId:(NSNumber *)subjectId
                               andTagId:(NSNumber *)tagId
                           andOrderType:(NSNumber *)orderType
                         andCourseLevel:(NSNumber *)courseLevel
                         andContentType:(NSNumber *)contentType
                                 isFree:(NSNumber *)bFree
                         andFinishBlock:(void(^)(BOOL bSuccess, NSError *error))finishedBlock;

- (void)loadBannerFinished:(void (^)(BOOL bSuccess, NSArray<BXGBannerModel*> *arrBannerModel))finishedBlock;

//微课筛选信息
@property(nonatomic, strong) NSArray<BXGHomeCourseModel *> *arrMicroFilterData;
@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, assign) BOOL bHaveMoreData;

@end
