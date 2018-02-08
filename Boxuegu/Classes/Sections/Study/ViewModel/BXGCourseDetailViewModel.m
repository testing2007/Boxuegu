//
//  BXGCourseDetailViewModel.m
//  Boxuegu
//
//  Created by Renying Wu on 2017/6/14.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseDetailViewModel.h"
#import "BXGUserModel.h"
#import "BXGUserDefaults.h"
#import "BXGHistoryModel.h"

#import "BXGCourseModel.h"
#import "BXGCourseTable.h"
#import "BXGHistoryTable.h"


#import "BXGStudentCriticizeTotalModel.h"

#define kFirstPage @"1"
#define kPageSizeMAX @"10000"


@interface BXGCourseDetailViewModel ()
@end


@implementation BXGCourseDetailViewModel

- (void)dealloc {
    
}

+ (instancetype)viewModelWithCourseId:(NSString *)courseId {
    
    BXGCourseDetailViewModel *instance = [BXGCourseDetailViewModel new];
    BXGCourseModel *courseModel = [BXGCourseModel new];
    courseModel.course_id = courseId;
    instance.courseModel = courseModel;
    instance.courseId = courseId;
    return instance;
}


+ (instancetype)viewModelWithModel:(BXGCourseModel *)model; {
    
    BXGCourseDetailViewModel *instance = [BXGCourseDetailViewModel new];
    instance.courseModel = model;
    return instance;
    
}

+ (instancetype)viewModelWithLearndHistoryModel:(BXGHistoryModel *)model; {
    
    BXGCourseDetailViewModel *instance = [BXGCourseDetailViewModel new];
    
    
    BXGCourseModel *courseModel= [BXGCourseModel new];
    courseModel.course_id = model.course_id;
    courseModel.course_name = model.course_name;
    courseModel.smallimg_path = model.smallimgPath;
    
    instance.courseModel = courseModel;
    instance.learnedHistoryModel = model;
    return instance;
    
}



// @property (nonatomic, strong) BXGLearnedHistoryModel *learnedHistoryModel;

- (void)setCourseModel:(BXGCourseModel *)courseModel {
    
    _courseModel = courseModel;
    if(courseModel){
        
        // TODO : init
    }
}

- (NSString *)courseId {
    
    return self.courseModel.course_id;
}

- (void)loadCurrentCourseOutLineIsUpdate:(BOOL)isUpdate andFinished:(void(^)(BOOL succeed, NSString *errorMessage))finishedBlock{
    
    __weak typeof (self) weakSelf = self;
    
    if(isUpdate){
        
    }else{
        
    }
    
    BXGCourseModel *courseModel = self.courseModel;
    if(!courseModel){
        
        finishedBlock(false,@"课程为空");
        return;
    }
    
    
    BXGUserModel *userModel = [BXGUserDefaults share].userModel;
    if(!userModel) {
        
        finishedBlock(false,@"用户为空");
        return;
    }
    
    [self.networkTool requestCourceOutlineWithCourseID:courseModel.course_id andUserID:userModel.user_id andSign:userModel.sign andFinished:^(id  _Nullable responseObject) {
        
        NSMutableArray <BXGCourseOutlineChapterModel*> *modelArray;
        if(responseObject) {
            
            id success = responseObject[@"success"];
            if(success && success != [NSNull null] && [success boolValue]){
                
                id resultObject = responseObject[@"resultObject"];
                if(resultObject && resultObject != [NSNull null]){
                    
                    modelArray = [NSMutableArray new];
                    for (NSInteger i = 0; i < [resultObject count]; i++) {
                        
                        BXGCourseOutlineChapterModel *model = [BXGCourseOutlineChapterModel yy_modelWithDictionary:resultObject[i]];
                        [modelArray addObject:model];
                    }
                    // 做缓存
                    weakSelf.courseOutlineModelArray = modelArray;
                    [weakSelf processOutlineData];
                    finishedBlock(true,nil);
                    
                }else {
                    
                    finishedBlock(false,@"课程大纲加载失败");
                }
                
            }else {
                
                finishedBlock(false,@"课程大纲加载失败");
            }
            
        }else {
            
            finishedBlock(false,@"课程大纲加载失败");
        }
        
    } Failed:^(NSError * _Nullable error) {
        
        finishedBlock(false,kBXGToastLodingError);
    }];
    
}


/**
 获取 天的计划列表
 
 */



- (void)loadProDayPlanWithDate:(NSDate *)date andFinished:(void(^)(id responseObject))completedBlock Failed:(void(^)(NSError* error))failedBlock; {
    __weak typeof (self) weakSelf = self;
    
    // 处理日期转换
    NSString *dateString = [[BXGDateTool share] formaterForRequest:date];
    BXGCourseModel  *courseModel = weakSelf.courseModel;
    // BXGStudyPayCourseModel *courseModel = weakSelf.currentPayCourseModel;
    if(courseModel) {
        
        NSMutableDictionary *oneCourseModelDict;
        id result = weakSelf.proCourseModelCacheDict[courseModel.course_id];
        
        if(!result || result == [NSNull null]) {
            
            oneCourseModelDict = [NSMutableDictionary new];
        }else {
            
            oneCourseModelDict = result;
        }
        
        id value = oneCourseModelDict[dateString];
        
        if(value && value != [NSNull null]){
            dispatch_async(dispatch_get_main_queue(), ^{
                completedBlock(value);
            });
            
        }else {
            [self updateProDayPlanWithDate:date andFinished:^(id responseObject) {
                completedBlock(responseObject);
            } Failed:^(NSError *error) {
                failedBlock(error);
            }];
        }
    }else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completedBlock(nil);
        });
        
    }
    
}

- (void)updateProDayPlanWithDate:(NSDate *)date andFinished:(void(^)(id responseObject))completedBlock Failed:(void(^)(NSError* error))failedBlock {
    
    __weak typeof (self) weakSelf = self;
    // 处理日期转换
    NSString *dateString = [[BXGDateTool share] formaterForRequest:date];
    
    
    
    BXGUserModel *userModel = weakSelf.userModel;
    //BXGStudyPayCourseModel *courseModel = weakSelf.currentPayCourseModel;
    BXGCourseModel * courseModel = self.courseModel;
    if(!courseModel){
        RWLog(@"没有课程信息");
        failedBlock(nil);
        return;
    }
    
    // 请求数据
    [self.networkTool requestMyVocationalWithUserID:userModel.user_id andCourseId: courseModel.course_id andSign:userModel.sign andDate:dateString andPage:kFirstPage andPageSize:kPageSizeMAX andFinished:^(id  _Nullable responseObject) {
        BXGProDayPlanModel *dayPlanModel;
        
        
        if(responseObject) {
            
            
            id successValue = responseObject[@"success"];
            if(successValue && successValue != [NSNull null] && [successValue isKindOfClass:[NSNumber class]] && [successValue boolValue] == true) {
                id resultObject = responseObject[@"resultObject"];
                
                if(resultObject && resultObject != [NSNull null] && [resultObject isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary *dict = resultObject;
                    dayPlanModel = [BXGProDayPlanModel yy_modelWithJSON:dict];
                    dayPlanModel.isFailed = false;
                }else {
                    
                    dayPlanModel = [BXGProDayPlanModel new];
                    dayPlanModel.isFailed = true;
                }
            }
            
        }else {
            
            return;
        }
        
        
        
        
        NSMutableDictionary *oneCourseDict;
        id value = weakSelf.proCourseModelCacheDict[courseModel.course_id];
        if(!value || value == [NSNull null] || ![value isKindOfClass:[NSMutableDictionary class]]) {
            
            oneCourseDict = [NSMutableDictionary new];
        }else
        {
            
            oneCourseDict = value;
        }
        
        oneCourseDict[dateString] = dayPlanModel;
        
        weakSelf.proCourseModelCacheDict[courseModel.course_id] = oneCourseDict;
        completedBlock(dayPlanModel);
        
    } Failed:^(NSError * _Nonnull error) {
        
        failedBlock(error);
    }];
}



/**
 同步当前视频为学习中
 */

- (void)updateUserStudyStateToBeginWithVideoId:(NSString *)videoId andCourseId:(NSString *)courseId{
    
    // 获取当前用户信息
    NSString *userId = self.userModel.user_id;
    NSString *sign = self.userModel.sign;
    
    // 获取当前用户sign
    
    // 2：学习中s
    [self.networkTool requestUpdateStudyStateWithUserId:userId andCourseId:courseId andVideoId:videoId andSign:sign andState:@"2" andFinished:^(id  _Nullable responseObject) {
        
        // 更新学习状态成功
    } Failed:^(NSError * _Nonnull error) {
        
        // 更新学习状态失败
    }];
    
}

// 1.1.1 更新学习状态
- (void)updateUserStudyStateWithVideoModel:(BXGCourseOutlineVideoModel *)videoModel andState:(BXGStudyStatus)status {
    
    // 获取当前用户信息
    NSString *userId = self.userModel.user_id;
    // 获取当前用户sign
    NSString *sign = self.userModel.sign;
    NSString *courseId = self.courseModel.course_id;
    NSString *videoId = videoModel.idx;
    
    // 更新本地数据
    if(videoModel.study_status.integerValue != BXGStudyStatusFinish) {
        
        videoModel.study_status = @(status);
    }
    // 更新服务器数据
    [self.networkTool requestUpdateStudyStateWithUserId:userId andCourseId:courseId andVideoId:videoId andSign:sign andState:@(status).description andFinished:^(id  _Nullable responseObject) {
        
        // 更新学习状态成功
    } Failed:^(NSError * _Nonnull error) {
        
        // 更新学习状态失败
    }];
    
}

/**
 同步当前视频为学习完
 */
- (void)updateUserStudyStateToFinishWithVideoId:(NSString *)videoId andCourseId:(NSString *)courseId {
    
    // 获取当前用户信息
    NSString *userId = self.userModel.user_id;
    NSString *sign = self.userModel.sign;
    
    // 获取当前用户sign
    
    // 1：已学习
    [self.networkTool requestUpdateStudyStateWithUserId:userId andCourseId: courseId andVideoId:videoId andSign: sign andState:@"1" andFinished:^(id  _Nullable responseObject) {
        
        // 更新学习状态成功
    } Failed:^(NSError * _Nonnull error) {
        
        // 更新学习状态失败
    }];
}

- (NSArray *)processOutlineData{
    
    NSMutableArray *allPointArray = [NSMutableArray new];
    NSMutableArray *allVideoArray = [NSMutableArray new];
    
    NSMutableArray<BXGCourseOutlineChapterModel*> *chapterModelArray = self.courseOutlineModelArray;
    
    
    for (NSInteger i = 0; i < chapterModelArray.count; i++) {
        
        BXGCourseOutlineChapterModel *chapterModel = chapterModelArray[i];
        NSMutableArray<BXGCourseOutlineSectionModel*> *sectionModelArray = chapterModel.jie;
        
        for (NSInteger j = 0; j < sectionModelArray.count; j++) {
            
            // point 层
            NSMutableArray<BXGCourseOutlinePointModel *> *pointModelArray = sectionModelArray[j].dian;
            
            NSMutableArray *removeArray = [NSMutableArray new];
            for(NSInteger k = 0; k < pointModelArray.count; k++) {
                
                BXGCourseOutlinePointModel *pointModel = pointModelArray[k];
                
                NSArray<BXGCourseOutlineVideoModel *> *videoArray = pointModel.videos;
                if(!pointModel.videos || pointModel.videos.count <= 0) {
                    
                    [removeArray addObject:pointModel];
                }else {
                    
                    pointModel.superChapterModel = chapterModel;
                    for(NSInteger m = 0; m < videoArray.count; m++) {
                        
                        BXGCourseOutlineVideoModel *videoModel = videoArray[m];
                        videoModel.superPointModel = pointModel;
                    }
                    [allVideoArray addObjectsFromArray:videoArray];
                }
            }
            
            for(NSInteger i = 0; i < removeArray.count; i++) {
                
                [pointModelArray removeObject:removeArray[i]];
            }
            
            [allPointArray addObjectsFromArray:pointModelArray];
        }
    }
    self.courseOutlineAllPointModelArray = allPointArray.copy;
    self.courseOutlineAllVideoModelArray = allVideoArray.copy;
    return allPointArray;
    
}



- (BXGCourseOutlinePointModel *)nextOutlinePointModel:(BXGCourseOutlinePointModel *)pointModel {
    
    
    if(self.courseOutlineAllPointModelArray && self.courseOutlineAllPointModelArray.count > 0){
        
        NSInteger index;
        index = [self.courseOutlineAllPointModelArray indexOfObject:pointModel];
        
        if(index != NSNotFound){
            
            index = index + 1;
            if(self.courseOutlineAllPointModelArray.count > index){
                
                return self.courseOutlineAllPointModelArray[index];
            }
        }
    }
    return nil;
    
}
- (BXGCourseOutlineVideoModel *)firseOutlineVideoModel:(BXGCourseOutlinePointModel *)pointModel {
    
    if(pointModel && pointModel.videos.count > 0){
        
        return pointModel.videos.firstObject;
    }
    return nil;
}

- (BXGCourseOutlinePointModel *)firseOutlinePointModel{
    
    if(self.courseOutlineAllPointModelArray && self.courseOutlineAllPointModelArray.count > 0){
        
        return self.courseOutlineAllPointModelArray.firstObject;
    }else
    {
        return nil;
    }
    
}

- (BXGCourseOutlinePointModel *)findOutlinePointModelWithPointId:(NSString *)pointId {
    
    if(!pointId){
        
        return nil;
    }
    
    if(self.courseOutlineAllPointModelArray && self.courseOutlineAllPointModelArray.count > 0){
        
        for(NSInteger i = 0; i < self.courseOutlineAllPointModelArray.count; i++){
            
            BXGCourseOutlinePointModel *pointModel = self.courseOutlineAllPointModelArray[i];
            if([pointModel.idx isEqualToString:pointId]) {
                
                return pointModel;
            }
        }
    }
    
    return nil;
    
}

- (BXGCourseOutlineVideoModel *)findOutlineVideoModelWithVideoId:(NSString *)videoId {
    
    if(!videoId){
        
        return nil;
    }
    
    if(self.courseOutlineAllVideoModelArray && self.courseOutlineAllVideoModelArray.count > 0){
        
        for(NSInteger i = 0; i < self.courseOutlineAllVideoModelArray.count; i++){
            
            BXGCourseOutlineVideoModel *videoModel = self.courseOutlineAllVideoModelArray[i];
            if([videoModel.idx isEqualToString:videoId]) {
                
                return videoModel;
            }
        }
    }
    
    return nil;
    
}


// TO DO 保存 当前章节

//

- (BXGCourseOutlineChapterModel *)chapterForPointModel:(BXGCourseOutlinePointModel *)pointModel; {
    
    return pointModel.superChapterModel;
}

- (void)saveHistoryWithVideoModel:(BXGCourseOutlineVideoModel *)videoModel andPer:(double)per {
    
    // 参数
    BXGCourseOutlinePointModel *pointModel = videoModel.superPointModel;
    BXGCourseOutlineChapterModel *chapterModel = pointModel.superChapterModel;
    BXGCourseModel *courseModel = self.courseModel;
    NSTimeInterval createTime = [[NSDate new] timeIntervalSince1970];
    
    // 安全判断
    
    // 赋值
    BXGHistoryModel *historyModel = [BXGHistoryModel new];
    historyModel.course_id = courseModel.course_id;
    historyModel.course_name = courseModel.course_name;
    historyModel.zhang_id = chapterModel.idx;
    historyModel.dian_id = pointModel.idx;
    historyModel.video_id = videoModel.idx;
    historyModel.video_name = videoModel.name;
    historyModel.per = per;
    historyModel.create_time = createTime;
    historyModel.smallimgPath = courseModel.smallimg_path;
    // 添加表
    
    BXGHistoryTable *table = [BXGHistoryTable new];
    if([table addOneRecord:historyModel]) {
        
        // 成功
        RWLog(@"成功");
    }else {
        
        // 失败
        RWLog(@"失败");
        
    }
}
- (void)loadCoursePointAndVideoWithSectionId:(NSString *)sectionId andFinishedBlock:(void(^ _Nullable)(BOOL success, NSArray * _Nullable modelArray, NSString * _Nullable message))finishedBlock; {
    
    NSString *courseId = self.courseModel.course_id;
    BXGUserModel *userModel = self.userModel;
    NSString *userId = userModel.user_id;
    NSString *sign = userModel.sign;
    
    [self.networkTool requestCourseSectionAndVideoList:courseId andUserId:userId andSectionId:sectionId andSign:sign Finished:^(id  _Nullable responseObject) {
        
        id success = responseObject[@"success"];
        if([success isKindOfClass:[NSNumber class]] && [success boolValue]) {
            
            NSMutableArray *modelArray = [NSMutableArray new];
            id resultObject = responseObject[@"resultObject"];
            if([resultObject isKindOfClass:[NSArray class]]){
                
                
                for(NSInteger i = 0; i < [resultObject count]; i++) {
                    
                    BXGCourseOutlinePointModel *model = [BXGCourseOutlinePointModel yy_modelWithDictionary:resultObject[i]];
                    if(model && model.videos && model.videos.count > 0) {
                        
                        [modelArray addObject:model];
                    }
                }
            }
            
            // 处理
            for (NSInteger i = 0; i < modelArray.count; i++) {
                
                BXGCourseOutlinePointModel *pointModel = modelArray[i];
                for (NSInteger j = 0; j < pointModel.videos.count; j++) {
                    
                    BXGCourseOutlineVideoModel *videoModel = pointModel.videos[j];
                    videoModel.superPointModel = pointModel;
                }
            }
            finishedBlock(true,modelArray,nil);
        }else {
            
            finishedBlock(false,nil,nil);
        }
        
    } Failed:^(NSError * _Nonnull error) {
        
        finishedBlock(false,nil,nil);
    }];
}

- (void)loadStudentCriticizedListWithRefresh:(BOOL)isRefresh
                            andFinishedBlock:(void(^ _Nullable)(BOOL success,BXGStudentCriticizeTotalModel *totalModel, NSArray * _Nullable modelArray, NSString * _Nullable message))finishedBlock; {
    
    __weak typeof (self) weakSelf = self;
    NSString *courseId = self.courseModel.course_id;
    NSString *sign = self.userModel.sign;
    if(isRefresh) {
        
        weakSelf.praiseCourseIsEnd = false;
        weakSelf.praiseCourseCurrentPage = 0;
        weakSelf.praiseCourseArray = nil;
        
    }
    
    self.praiseCourseCurrentPage += 1;
    NSInteger page = self.praiseCourseCurrentPage;
    
    if(!self.praiseCourseArray) {
        
        self.praiseCourseArray = [NSMutableArray new];
    }
    
    [self.networkTool requestStudentCriticizeListWithCourseId:courseId
     // andVideoId:videoId
                                                      andPage:@(page).description
                                                  andPageSize:@(K_PRAISE_COURSE_CURRENT_PAGESIZE).description andSign:sign
                                                     Finished:^(id  _Nullable responseObject) {
                                                         
                                                         id success = responseObject[@"success"];
                                                         if([success isKindOfClass:[NSNumber class]] && [success boolValue]) {
                                                             
                                                             
                                                             id resultObject = responseObject[@"resultObject"];
                                                             if([resultObject isKindOfClass:[NSDictionary class]]){
                                                                 // resultObject[@"criticize"]
                                                                 
                                                                 BXGStudentCriticizeTotalModel *model = [BXGStudentCriticizeTotalModel  yy_modelWithDictionary:resultObject];
                                                                 
                                                                 if(model.criticize) {
                                                                     //                                                                     if (model.criticize.currentPage == model.criticize.totalPageCount) {
                                                                     //
                                                                     //                                                                         weakSelf.praiseCourseIsEnd = true;
                                                                     //                                                                     }
                                                                     NSArray *modelArray;
                                                                     modelArray = model.criticize.items;
                                                                     weakSelf.praiseCourseIsEnd = (modelArray.count == 0 || modelArray.count < K_PRAISE_COURSE_CURRENT_PAGESIZE);
                                                                     if(modelArray) {
                                                                         
                                                                         [weakSelf.praiseCourseArray addObjectsFromArray:modelArray];
                                                                     }
                                                                 }
                                                                 
                                                                 finishedBlock(true,model,weakSelf.praiseCourseArray,nil);
                                                                 
                                                                 //                                                                 weakSelf.praiseCourseIsEnd = (modelArray.count == 0 || modelArray.count < K_PRAISE_COURSE_CURRENT_PAGESIZE);
                                                                 //                                                                 [weakSelf.praiseCourseArray addObjectsFromArray:modelArray];
                                                                 //                                                                 finishedBlock(true,weakSelf.praiseCourseArray,nil);
                                                                 
                                                             }
                                                             
                                                             
                                                             
                                                         }else {
                                                             
                                                             finishedBlock(false,nil,nil,nil);
                                                         }
                                                         
                                                         
                                                     } Failed:^(NSError * _Nonnull error) {
                                                         
                                                         finishedBlock(false,nil,nil,nil);
                                                     }];
}





- (void)commitStudentCriticizeWithVideoId:(NSString *_Nullable)videoId andPointId:(NSString* _Nullable)pointId andStarLevel:(NSNumber *_Nullable)starLevel andContent:(NSString *_Nullable)content finishedBlock:(void(^_Nullable)(BOOL success))finishedBLock; {
    
    NSString *userId = self.userModel.user_id;
    NSString *sign = self.userModel.sign;
    NSString *courseId = self.courseModel.course_id;
    
    [self.networkTool requestCommitStudentCriticizeWithUserId:userId CourseId:courseId PointId:pointId andVideoId:videoId andStarLevel:starLevel andContent:content andSign:sign Finished:^(id  _Nullable responseObject) {
        if(responseObject) {
            id success = responseObject[@"success"];
            if(success && success != [NSNull null] && [success boolValue]){
                
                finishedBLock(true);
                return;
            }
        }
        finishedBLock(false);
    } Failed:^(NSError * _Nonnull error) {
        finishedBLock(false);
    }];
}

- (void)loadCourseOutLineFinished:(void(^_Nullable)(BOOL success, NSArray * _Nullable modelArray, NSArray * _Nullable pointModelArray,NSString * _Nullable message))finishedBlock; {
    
    __weak typeof (self) weakSelf = self;
    
    BXGCourseModel *courseModel = self.courseModel;
    NSString *courseId;
    NSString *userId;
    NSString *sign;
    if(courseModel) {
        
        courseId = courseModel.course_id;
    }
    BXGUserModel *userModel = [BXGUserDefaults share].userModel;
    
    if(userModel) {
        
        userId = userModel.user_id;
        sign = userModel.sign;
    }
    
    [self.networkTool requestCourceOutlineWithCourseID:courseId andUserID:userId andSign:sign andFinished:^(id  _Nullable responseObject) {
        
        NSMutableArray <BXGCourseOutlineChapterModel*> *modelArray;
        if(responseObject) {
            
            id success = responseObject[@"success"];
            if(success && success != [NSNull null] && [success boolValue]){
                
                id resultObject = responseObject[@"resultObject"];
                if(resultObject && resultObject != [NSNull null]){
                    
                    modelArray = [NSMutableArray new];
                    for (NSInteger i = 0; i < [resultObject count]; i++) {
                        
                        BXGCourseOutlineChapterModel *model = [BXGCourseOutlineChapterModel yy_modelWithDictionary:resultObject[i]];
                        [modelArray addObject:model];
                    }
                    // 做缓存
                    weakSelf.courseOutlineModelArray = modelArray;
                    NSArray *pointModelArray = [weakSelf processOutlineData];
                    finishedBlock(true,modelArray,pointModelArray,nil);
                    
                }else {
                    
                    finishedBlock(false,nil,nil,@"课程大纲加载失败");
                }
                
            }else {
                
                finishedBlock(false,nil,nil,@"课程大纲加载失败");
            }
            
        }else {
            
            finishedBlock(false,nil,nil,@"课程大纲加载失败");
        }
        
    } Failed:^(NSError * _Nullable error) {
        
        finishedBlock(false,nil,nil,kBXGToastLodingError);
    }];
}
@end

