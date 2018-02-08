//
//  BXGProCoursePlanViewModel.m
//  Boxuegu
//
//  Created by Renying Wu on 2017/6/15.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGProCoursePlanViewModel.h"

#import "BXGConstrueModel.h"
#import "BXGCourseOutlineChapterModel.h"
#import "BXGProDayPlanModel.h"
#import "BXGCourseDetailViewModel.h"

#import "BXGStudyPayCourseModel.h"
#import "BXGCourseProgressInfoModel.h"
#define kPageSize 2
#define kFirstPage @"1"
#define kPageSizeMAX @"10000"

typedef enum : NSUInteger {
    BXGCourseTypePro,
    BXGCourseTypeMini,
    BXGCourseTypeProConstrue,
} BXGCourseType;


@interface BXGProCoursePlanViewModel()
@end

@implementation BXGProCoursePlanViewModel

- (instancetype)init {
    
    self = [super init];
    if(self) {
        
        self.proCourseModelCacheDict = [NSMutableDictionary new];
    }
    return self;
}
+ (instancetype)viewModelWithCourseId:(NSString *)courseId; {

    BXGProCoursePlanViewModel *instance = [BXGProCoursePlanViewModel new];
    BXGCourseModel *courseModel = [[BXGCourseModel alloc] init];
    courseModel.course_id = courseId;
    instance.courseModel = courseModel;
    return instance;
    
}


+ (instancetype)viewModelWithModel:(BXGCourseModel *)model; {
    
    BXGProCoursePlanViewModel *instance = [BXGProCoursePlanViewModel new];
    instance.courseModel = model;
    return instance;
    
}

- (void)setCourseModel:(BXGCourseModel *)courseModel {
    
    _courseModel = courseModel;
    if(courseModel){
        
        // TODO : init
    }
}

#pragma mark - Getter Setter


-(NSString *)currentOutlineCourseId {
    
    return [BXGUserDefaults share].currentPayCourseId;
}

- (void)setCurrentOutlineCourseId:(NSString *)currentOutlineCourseId {
    
    [BXGUserDefaults share].currentPayCourseId = currentOutlineCourseId;
}

- (NSString *)courseName {
    
    return [BXGUserDefaults share].courseName;
}

- (void)setCourseName:(NSString *)courseName {
    
    [BXGUserDefaults share].courseName = courseName;
}

- (NSArray<NSDate *> *)weekDateArray {
    
    if(!_weekDateArray){
        
        _weekDateArray = [[BXGDateTool share] getWeekDate];
        
    }
    return _weekDateArray;
}

#pragma mark - 功能

- (void)loadProDayPlanWithDate:(NSDate *)date andFinished:(void (^)(BOOL success, BXGProDayPlanModel *model, NSString *message))finishedBlock {

    __weak typeof (self) weakSelf = self;
    
    // 1.处理日期转换
    NSString *dateString = [[BXGDateTool share] formaterForRequest:date];
    
    // 2.安全判断
    BXGUserModel *userModel = weakSelf.userModel;
    BXGCourseModel *courseModel = weakSelf.courseModel;

    if(!courseModel || !userModel || !date || !dateString || dateString.length <= 0){
        
        finishedBlock(false,nil,@"参数错误");
        return;
    }
    
    // 3.配置参数
    NSString *userId = userModel.user_id;
    NSString *courseId = courseModel.course_id;
    NSString *sign = userModel.sign;
    
    // 4.请求数据
    [self.networkTool requestMyVocationalWithUserID:userId andCourseId: courseId andSign:sign andDate:dateString andPage:kFirstPage andPageSize:kPageSizeMAX andFinished:^(id  _Nullable responseObject) {
        
        BXGProDayPlanModel *dayPlanModel;
        if(responseObject) {
            
            NSNumber *successValue = responseObject[@"success"];
            
            if([successValue isKindOfClass:[NSNumber class]] && [successValue boolValue] == true) {
                
                NSDictionary *resultObject = responseObject[@"resultObject"];
                
                if(resultObject && [resultObject isKindOfClass:[NSDictionary class]]) {
                
                    dayPlanModel = [BXGProDayPlanModel yy_modelWithJSON:resultObject];
                    finishedBlock(true,dayPlanModel,@"加载成功");
                    
                }else {
                    
                    finishedBlock(true,nil,@"加载成功");
                }
            }
            else {
            
                finishedBlock(false,nil,@"加载失败");
            }
            
        }else {
            
            finishedBlock(false,nil,@"加载失败");
            return;
        }
        
    } Failed:^(NSError * _Nonnull error) {
        
        finishedBlock(false,nil,@"加载失败");
    }];
    
    
}


- (void)loadProDayPlanWithDate:(NSDate *)date andFinished:(void(^)(id responseObject))completedBlock Failed:(void(^)(NSError* error))failedBlock; {
    __weak typeof (self) weakSelf = self;
    
    // 处理日期转换
    NSString *dateString = [[BXGDateTool share] formaterForRequest:date];
    
    BXGCourseModel *courseModel = weakSelf.courseModel;
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

- (void)loadCourseProgressFinished:(void(^)(BOOL success, BXGCourseProgressInfoModel *model, NSString *message))finishedBlock {

    NSString *userId = self.userModel.user_id;
    NSString *sign = self.userModel.sign;
    NSString *courseId = self.courseModel.course_id;
    
    
    
    
    
    [self.networkTool requestCourseProgessWithUserId:userId andCourseId:courseId andSign:sign Finished:^(id  _Nullable responseObject) {
        
        if(!responseObject){
            
            finishedBlock(false,nil,nil);
            return;
        }
        
        NSNumber *successValue = responseObject[@"success"];
        if(!successValue || ![successValue isKindOfClass:[NSNumber class]] || [successValue boolValue] != true) {
        
            finishedBlock(false,nil,nil);
            return;
        }
            
        NSDictionary *resultObject = responseObject[@"resultObject"];
        if(!resultObject || ![resultObject isKindOfClass:[NSDictionary class]]){
        
            finishedBlock(false,nil,nil);
            return;
        }
        
        BXGCourseProgressInfoModel *model = [BXGCourseProgressInfoModel yy_modelWithJSON:resultObject];
        if(!model) {
        
            finishedBlock(false,nil,nil);
            return;
        }
        
        // 成功
        finishedBlock(true,model,nil);
        
        
    } Failed:^(NSError * _Nonnull error) {
        
        finishedBlock(false,nil,nil);
        return;
    }];
//    if()
//    BXGCourseProgressInfoModel
}


- (void)updateProDayPlanWithDate:(NSDate *)date andFinished:(void(^)(id responseObject))completedBlock Failed:(void(^)(NSError* error))failedBlock {
    
    __weak typeof (self) weakSelf = self;
    // 处理日期转换
    NSString *dateString = [[BXGDateTool share] formaterForRequest:date];
    
    
    
    BXGUserModel *userModel = weakSelf.userModel;
    BXGCourseModel *courseModel = weakSelf.courseModel;
    
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

- (void)updateWeekDateArray {
    
    _weekDateArray = nil;
    _weekDateArray = [[BXGDateTool share] getWeekDate];
}


- (void)catchUserLoginNotificationWith:(BOOL)isLogin {
    
    if(!isLogin){
        
        // -- 用户退出登录时候操作 --
        
        
    }
}

#pragma Operation


- (void)loadCourseChapterList:(void(^ _Nullable)(BOOL success, NSArray * _Nullable modelArray, NSString * _Nullable message))finishedBlock; {

    NSString *courseId = self.courseModel.course_id;
    BXGUserModel *userModel = self.userModel;
    NSString *userId = userModel.user_id;
    NSString *sign = userModel.sign;
    
    [self.networkTool requestCourseChapterList:courseId andUserId:userId andSign:sign Finished:^(id  _Nullable responseObject) {
        
        id success = responseObject[@"success"];
        if([success isKindOfClass:[NSNumber class]] && [success boolValue]) {
        
            NSMutableArray *muArray = [NSMutableArray new];
            id resultObject = responseObject[@"resultObject"];
            if([resultObject isKindOfClass:[NSArray class]]) {
            
                for(NSInteger i = 0; i < [resultObject count]; i ++) {
                
                   BXGCourseOutlineChapterModel *model = [BXGCourseOutlineChapterModel yy_modelWithDictionary:resultObject[i]];
                    if(model) {
                    
                        [muArray addObject:model];
                    }
                }
            }
            finishedBlock(true,muArray,nil);
            
        }else {
        
            finishedBlock(false,nil,nil);
        }
        
    } Failed:^(NSError * _Nonnull error) {
        
        finishedBlock(false,nil,nil);
        
    }];
}
- (void)loadLastLearnHistoryWithFinished:(void(^ _Nullable)(id _Nullable model))finishedBlock {
    
    if(!self.userModel || !self.courseModel) {
        
        return finishedBlock(nil);
    }
    
    NSString *sign = self.userModel.sign;
    NSString *userId = self.userModel.user_id;
    NSString *course_id = self.courseModel.course_id;
    
    [self.networkTool requestLastlearnHistoryWithSign:sign andUserId:userId andCourseId:course_id andFinished:^(id  _Nullable responseObject) {
        
        if(responseObject) {
            
            BXGHistoryModel *model;
            id success = responseObject[@"success"];
            if([success isKindOfClass:[NSNumber class]] && [success boolValue]) {
                
                id result = responseObject[@"resultObject"];
                if([result isKindOfClass:[NSDictionary class]]) {
                    
                    model = [BXGHistoryModel yy_modelWithDictionary:result];
                }
                
            }
            if(finishedBlock) {
                
                finishedBlock(model);
            }
            
        }else {
            
            if(finishedBlock) {
                
                finishedBlock(nil);
            }
        }
        
        
    } Failed:^(NSError * _Nonnull error) {
        
        if(finishedBlock) {
            
            finishedBlock(nil);
        }
    }];
}
@end

