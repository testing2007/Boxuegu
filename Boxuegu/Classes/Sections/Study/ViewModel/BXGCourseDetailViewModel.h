//
//  BXGCourseDetailViewModel.h
//  Boxuegu
//
//  Created by HM on 2017/6/14.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
#import "BXGCourseModel.h"
#import "BXGCourseOutlineChapterModel.h"
#import "BXGUserModel.h"
#import "BXGProDayPlanModel.h"
#import "BXGLearnedHistoryModel.h"
#import "BXGHistoryModel.h"
#import "BXGStudentCriticizeTotalModel.h"

@interface BXGCourseDetailViewModel : BXGBaseViewModel

// 课程详情接口模型
@property (nonatomic, copy) NSString * _Nullable courseId;
@property (nonatomic, strong) BXGCourseModel *courseModel;

@property (nonatomic, strong) BXGHistoryModel *learnedHistoryModel;

// 课程详情接口初始化函数
+ (instancetype)viewModelWithModel:(BXGCourseModel *)model;
+ (instancetype)viewModelWithLearndHistoryModel:(BXGHistoryModel *)model;

// 课程大纲
@property (nonatomic, strong) NSMutableArray<BXGCourseOutlineChapterModel *> *courseOutlineModelArray;
@property (nonatomic, strong) NSMutableArray<BXGCourseOutlinePointModel *> *courseOutlineAllPointModelArray;
@property (nonatomic, strong) NSMutableArray<BXGCourseOutlineVideoModel *> *courseOutlineAllVideoModelArray;

- (void)loadCurrentCourseOutLineIsUpdate:(BOOL)isUpdate andFinished:(void(^)(BOOL succeed, NSString *errorMessage))finishedBlock;

/// 职业课程 展示缓存数据
@property (atomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *,BXGProDayPlanModel *>*> *proCourseModelCacheDict;

- (void)loadProDayPlanWithDate:(NSDate *)date andFinished:(void(^)(id responseObject))completedBlock Failed:(void(^)(NSError* error))failedBlock;
- (void)updateProDayPlanWithDate:(NSDate *)date andFinished:(void(^)(id responseObject))completedBlock Failed:(void(^)(NSError* error))failedBlock;





// 所有点的序列
// @property (nonatomic, strong) NSArray<BXGCourseOutlinePointModel *> *courseOutlineAllPointArray;

- (BXGCourseOutlinePointModel *)nextOutlinePointModel:(BXGCourseOutlinePointModel *)pointModel;
- (BXGCourseOutlineVideoModel *)firseOutlineVideoModel:(BXGCourseOutlinePointModel *)pointModel;
- (BXGCourseOutlinePointModel *)firseOutlinePointModel;

- (BXGCourseOutlineChapterModel *)chapterForPointModel:(BXGCourseOutlinePointModel *)pointModel;
- (BXGCourseOutlineVideoModel *)findOutlineVideoModelWithVideoId:(NSString *)videoId;
- (BXGCourseOutlinePointModel *)findOutlinePointModelWithPointId:(NSString *)pointId;
/**
 同步当前视频为学习中
 */

- (void)updateUserStudyStateToBeginWithVideoId:(NSString *)videoId andCourseId:(NSString *)courseId;

/**
 同步当前视频为学习完
 */
- (void)updateUserStudyStateToFinishWithVideoId:(NSString *)videoId andCourseId:(NSString *)courseId;

// 1.1.1 更新学习状态
- (void)updateUserStudyStateWithVideoModel:(BXGCourseOutlineVideoModel *)videoModel andState:(BXGStudyStatus)status;

- (void)saveHistoryWithVideoModel:(BXGCourseOutlineVideoModel *)videoModel andPer:(double)per;


// 1.1.1 +
+ (instancetype)viewModelWithCourseId:(NSString *)courseId;

// 1.2.1
- (void)loadCoursePointAndVideoWithSectionId:(NSString *)sectionId andFinishedBlock:(void(^ _Nullable)(BOOL success, NSArray * _Nullable modelArray, NSString * _Nullable message))finishedBlock;

- (void)loadCourseOutLineFinished:(void(^_Nullable)(BOOL success, NSArray * _Nullable modelArray, NSArray * _Nullable pointModelArray,NSString * _Nullable message))finishedBlock;

- (NSArray *_Nullable)processOutlineData;


//- (void)loadStudentCriticizedListWithPage:(NSString *_Nullable)page andPageSize:(NSString *_Nullable)pageSize andFinishedBlock:(void(^ _Nullable)(BOOL success, NSArray * _Nullable modelArray, NSString * _Nullable message))finishedBlock;
- (void)loadStudentCriticizedListWithRefresh:(BOOL)isRefresh
                            andFinishedBlock:(void(^ _Nullable)(BOOL success,BXGStudentCriticizeTotalModel * _Nullable totalModel, NSArray * _Nullable modelArray, NSString * _Nullable message))finishedBlock;



@property (nonatomic, strong) NSMutableArray * _Nullable praiseCourseArray;
@property (nonatomic, assign) NSInteger praiseCourseCurrentPage;
@property (nonatomic, assign) BOOL praiseCourseIsEnd;
#define K_PRAISE_COURSE_CURRENT_PAGESIZE 20

- (void)commitStudentCriticizeWithVideoId:(NSString *_Nullable)videoId andPointId:(NSString* _Nullable)pointId andStarLevel:(NSNumber *_Nullable)starLevel andContent:(NSString *_Nullable)content finishedBlock:(void(^_Nullable)(BOOL success))finishedBLock;
@end
