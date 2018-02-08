//
//  BXGProCoursePlanViewModel.h
//  Boxuegu
//
//  Created by HM on 2017/6/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGProCourseModel.h"
#import "BXGCourseOutlineChapterModel.h"
#import "BXGProDayPlanModel.h"

#import "BXGStudyPayCourseModel.h"
#import "BXGBaseViewModel.h"
#import "BXGCourseModel.h"

// 1.1.1

#import "BXGCourseDetailViewModel.h"
#import "BXGBaseViewModel.h"
#import "BXGCourseProgressInfoModel.h"

@interface BXGProCoursePlanViewModel : BXGBaseViewModel


// 课程详情接口模型
@property (nonatomic, strong) BXGCourseModel * _Nullable courseModel;

// 课程详情接口初始化函数
+ (instancetype _Nonnull )viewModelWithModel:(BXGCourseModel * _Nonnull)model;
+ (instancetype _Nonnull)viewModelWithCourseId:(NSString * _Nonnull)courseId;

#pragma mark - 内存缓存数据
/// 学习中心 职业课程 展示缓存数据
@property (atomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *,BXGProDayPlanModel *>*> * _Nullable proCourseModelCacheDict;
/// 日期数据
@property (nonatomic, strong) NSArray <NSDate *> * _Nonnull weekDateArray;




- (void)loadProDayPlanWithDate:(NSDate * _Nullable)date andFinished:(void (^ _Nullable)(BOOL success, BXGProDayPlanModel * _Nullable model, NSString * _Nullable message))finishedBlock;
- (void)loadProDayPlanWithDate:(NSDate * _Nullable)date andFinished:(void(^ _Nullable)(id  _Nullable responseObject))completedBlock Failed:(void(^ _Nullable)(NSError* _Nullable error))failedBlock;
- (void)loadCourseProgressFinished:(void(^ _Nullable)(BOOL success, BXGCourseProgressInfoModel * _Nullable model, NSString * _Nullable message))finishedBlock;
- (void)updateProDayPlanWithDate:(NSDate * _Nullable)date andFinished:(void(^ _Nullable)(id _Nullable responseObject))completedBlock Failed:(void(^ _Nullable)(NSError* _Nullable  error))failedBlock;
// 进度

- (void)loadCourseChapterList:(void(^ _Nullable)(BOOL success, NSArray * _Nullable modelArray, NSString * _Nullable message))finishedBlock;

- (void)loadCoursePointAndVideo:(void(^ _Nullable)(BOOL success, NSArray * _Nullable modelArray, NSString * _Nullable message))finishedBlock;

- (void)loadLastLearnHistoryWithFinished:(void(^ _Nullable)(id _Nullable model))finishedBlock;



@end
