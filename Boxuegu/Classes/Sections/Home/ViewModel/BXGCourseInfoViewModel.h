//
//  BXGCourseInfoViewModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"

typedef NS_ENUM(NSUInteger, BXGCourseInfoApplyType) {
    BXGCourseInfoApplyTypeNone,
    BXGCourseInfoApplyTypeNoLogin,
    BXGCourseInfoApplyTypeApplied,
    BXGCourseInfoApplyTypeNotApplied,
};

@class BXGCourseInfoChapterModel;
@class BXGCourseLecturerModel;
@class BXGHomeCourseModel;
@interface BXGCourseInfoViewModel : BXGBaseViewModel

#pragma mark - Interface

- (instancetype _Nonnull)initWithCourseId:(NSString * _Nonnull)courseId;
- (instancetype _Nonnull)initWithCourseModel:(BXGHomeCourseModel * _Nonnull)courseModel;
@property (nonatomic, strong) NSString * _Nullable courseId;
@property (nonatomic, strong) BXGHomeCourseModel * _Nullable courseModel;
@property (nonatomic, assign) BXGCourseInfoApplyType applyType;

/// 获取: 课程是否已购买
- (void)loadCourseIsApplyWithCourseId:(NSString * _Nullable)courseId
                     andFinishedBlock:(void(^ _Nullable)(NSNumber * _Nullable isApply)) finishedBlock;
/// 判断: 该课程下是否有视频
- (void)checkCourseExistVideos:(NSString *_Nonnull)courseId andFinished:(void(^ _Nullable)(BOOL isExist,NSString * _Nullable msg))finished;
- (void)loadCourseInfoDetailWithRefresh:(BOOL)isRefresh Finished:(void(^ _Nullable)(BXGHomeCourseModel * _Nullable courseModel))finished;
@end
