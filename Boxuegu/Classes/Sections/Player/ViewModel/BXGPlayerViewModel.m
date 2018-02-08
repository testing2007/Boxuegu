//
//  BXGPlayerViewModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPlayerViewModel.h"
#import "BXGResourceManager.h"
#import "BXGHistoryModel.h"
#import "BXGHistoryTable.h"
#import "BXGLearnStatusTable.h"


@interface BXGPlayerViewModel()

@end

@implementation BXGPlayerViewModel

- (instancetype)initWithCourseModel:(BXGCourseModel *)courseModel andPontModelArray:(NSArray *)pointArray; {

    self = [super init];
    if(self) {
    
        self.courseModel = courseModel;
        self.pointModelArray = pointArray;    
    }
    
    return self;
}
- (instancetype)initWithCourseModel:(BXGCourseModel *)courseModel; {

    self = [super init];
    if(self) {
        
        self.courseModel = courseModel;
    }
    
    return self;
}

#pragma mark - 选集相关

- (BXGCourseOutlineVideoModel *)videoModelWithVideoId:(NSString *)videoId; {

    if(!videoId) {
     
        return nil;
    }
    for(NSInteger i = 0; i < self.pointModelArray.count; i++) {
    
        BXGCourseOutlinePointModel *pointModel = self.pointModelArray[i];
        
        for(NSInteger j = 0; j < pointModel.videos.count; j++) {
        
            BXGCourseOutlineVideoModel *videoModel = pointModel.videos[j];
            if([videoModel.idx isEqualToString:videoId]) {
            
                return videoModel;
            }
        }
    }
    return nil;
}

- (BXGCourseOutlinePointModel *)pointModelWithPointId:(NSString *)pointId; {
    
    if(!pointId) {
        
        return nil;
    }
    
    for(NSInteger i = 0; i < self.pointModelArray.count; i++) {
        
        BXGCourseOutlinePointModel *pointModel = self.pointModelArray[i];
        
        if([pointModel.idx isEqualToString:pointId]) {
            
            return pointModel;
        }
    }
    return nil;
}

- (BXGCourseOutlinePointModel *)firstPointModel {
    
    if(self.pointModelArray){
        
        return self.pointModelArray.firstObject;
    }else {
        
        return nil;
    }
}

- (BXGCourseOutlineVideoModel *)firstVideoModel:(BXGCourseOutlinePointModel *)pointModel; {
    
    if(pointModel.videos) {
        
        return pointModel.videos.firstObject;
    }
    return nil;
}

- (BXGCourseOutlineVideoModel *)nextVideoModel:(BXGCourseOutlineVideoModel *)videoModel {
    
    BXGCourseOutlinePointModel *pointModel = videoModel.superPointModel;
    if(!pointModel) {
        
        return nil;
    }
    NSInteger index = [pointModel indexForVideoId:videoModel.idx];
    if(index == NSNotFound) {
        
        return nil;
    }
    
    if(!pointModel.videos){
        
        return nil;
    }
    
    if((index + 1) >= pointModel.videos.count){
        
        return nil;
    }else {
        
        return pointModel.videos[index + 1];
    }
}

- (BXGCourseOutlinePointModel *)nextPointModel:(BXGCourseOutlinePointModel *)pointModel {
    
    if(!self.pointModelArray) {
        
        return nil;
    }
    NSInteger index = [self.pointModelArray indexOfObject:pointModel];
    
    if(index == NSNotFound) {
        
        return nil;
    }
    
    if((index + 1) >= self.pointModelArray.count){
        
        return nil;
    }else {
        
        return self.pointModelArray[index + 1];
    }
    return nil;
}

- (BXGCourseOutlineVideoModel *)videoModelForLastLearned;{
    
    NSTimeInterval lastTimeInterval = 0;
    NSInteger lastIndex = NSNotFound;
    BXGCourseOutlineVideoModel *lastVideoModel;
    
    if(!self.pointModelArray) {
        
        return nil;
    }
    
    for(NSInteger i = 0; i < self.pointModelArray.count; i ++) {
    
        BXGCourseOutlinePointModel *pointModel = self.pointModelArray[i];
        BXGCourseOutlineVideoModel *videoModel = [pointModel videoModelForLastLearned];
        if(videoModel){
        
            if(videoModel.last_learn_time) {
            
                NSDate *date = [[BXGDateTool share] dateFormFormaterStringForLongRequest:videoModel.last_learn_time];
                if(date){
                
                    NSTimeInterval timeInterval = date.timeIntervalSinceNow;
                    if(timeInterval >= lastTimeInterval || lastTimeInterval == 0) {
                        
                        lastTimeInterval = timeInterval;
                        lastIndex = i;
                        lastVideoModel = videoModel;
                    }
                }
            }
        }
    }
    
    if(lastVideoModel) {
    
        return lastVideoModel;
    }else {
        return  nil;
    }
}

#pragma mark - 播放进度相关
// double percent = [[BXGHistoryTable new] seekPercentWithCourseId:courseId andVideoId:videoId];
#pragma mark - 学习进度相关
/**
 同步当前视频为学习完
 */
- (void)updateUserStudyStateToFinishWithVideoId:(NSString *)videoId andCourseId:(NSString *)courseId {
    return;
    // 获取当前用户信息
    NSString *userId = self.userModel.user_id;
    NSString *sign = self.userModel.sign;
    
    // 获取当前用户sign
    
    // 1：已学习
    [self.networkTool requestUpdateStudyStateWithUserId:userId andCourseId: courseId andVideoId:videoId andSign: sign andState:@"1" andFinished:^(id  _Nullable responseObject) {
        
        // 更新学习状态成功
    } Failed:^(NSError * _Nonnull error) {
        
        // 更新学习状态失败
        
        BXGLearnStatusModel *model = [BXGLearnStatusModel new];
        model.video_id = videoId;
        model.studyStatus = @"1";
        BXGLearnStatusTable *table = [BXGLearnStatusTable new];
        if([table existRecord:videoId]){
        
            [table updateOneRecord:model];
        }else {
        
            [table addOneRecord:model];
        }
        
    }];
    
    
    
}
#pragma mark - 学习进度相关
/**
 同步当前视频为学习完
 */
- (void)updateUserStudyStateToBeginWithVideoId:(NSString *)videoId andCourseId:(NSString *)courseId {
    return;
    // 获取当前用户信息
    NSString *userId = self.userModel.user_id;
    NSString *sign = self.userModel.sign;
    
    // 获取当前用户sign
    
    // 1：已学习
    [self.networkTool requestUpdateStudyStateWithUserId:userId andCourseId: courseId andVideoId:videoId andSign: sign andState:@"2" andFinished:^(id  _Nullable responseObject) {
        
        // 更新学习状态成功
    } Failed:^(NSError * _Nonnull error) {
        
        BXGLearnStatusModel *model = [BXGLearnStatusModel new];
        model.video_id = videoId;
        model.studyStatus = @"2";
        // model.last_learn_time =
        BXGLearnStatusTable *table = [BXGLearnStatusTable new];
        if([table existRecord:videoId]){
            
            [table updateOneRecord:model];
        }else {
            
            [table addOneRecord:model];
        }
    }];
}






- (void)updateUserStudyStateWithIsLearning:(BOOL)isLearning andVideoId:(NSString *)videoId andCourseId:(NSString *)courseId {
    
    // 获取当前用户信息
    NSString *userId = self.userModel.user_id;
    NSString *sign = self.userModel.sign;
    
    // 获取当前用户sign
    
    NSString *state = @"1";
    
    if(isLearning) {
    
        state = @"2";
    }
    
    [self.networkTool requestUpdateStudyStateWithUserId:userId andCourseId: courseId andVideoId:videoId andSign: sign andState:state andFinished:^(id  _Nullable responseObject) {
        
        // 更新学习状态成功
        
    } Failed:^(NSError * _Nonnull error) {
        
        BXGLearnStatusModel *model = [BXGLearnStatusModel new];
        model.video_id = videoId;
        model.studyStatus = state;
        
        model.last_learn_time = [[BXGDateTool share] longRequestDateStringForDate:[NSDate date]];
        model.course_id = courseId;
        
        BXGLearnStatusTable *table = [BXGLearnStatusTable new];
        if([table existRecord:videoId]){
            
            [table updateOneRecord:model];
        }else {
            
            [table addOneRecord:model];
        }
    }];
}

#pragma mark - 下载相关

#pragma mark - 播放相关 - 本地或者在线 是否可以播放
- (NSString *)localPathForVideoModel:(BXGCourseOutlineVideoModel *)videoModel {

    NSString *localPath;
    BOOL result = [[BXGResourceManager shareInstance] isDownloadFileExistInLocalByVideoIdx:videoModel.idx withReturnLocalPath:&localPath];
    if(result) {
    
        return localPath;
    }else {
        return nil;
    }
}

- (void)saveHistoryWithVideoModel:(BXGCourseOutlineVideoModel *)videoModel andPer:(double)per {
    
    // 参数
    BXGCourseOutlinePointModel *pointModel = videoModel.superPointModel;
//    BXGCourseOutlineChapterModel *chapterModel = pointModel.superChapterModel;
    BXGCourseModel *courseModel = self.courseModel;
    NSTimeInterval createTime = [[NSDate new] timeIntervalSince1970];
    
    // 安全判断
    
    // 赋值
    BXGHistoryModel *historyModel = [BXGHistoryModel new];
    historyModel.course_id = courseModel.course_id;
    historyModel.course_name = courseModel.course_name;
    historyModel.jie_id = pointModel.parent_id;
    // historyModel.zhang_id = chapterModel.idx;
    historyModel.dian_id = pointModel.idx;
    historyModel.video_id = videoModel.idx;
    historyModel.video_name = videoModel.name;
    historyModel.per = per;
    historyModel.create_time = createTime;
    historyModel.smallimgPath = courseModel.smallimg_path;
    historyModel.course_type = courseModel.type;
    // 添加表
    
    BXGHistoryTable *table = [BXGHistoryTable new];
    if([table addOneRecord:historyModel]) {
        
        // 成功
        RWLog(@"成功");
        NSLog(@"save pointId:%@, videoId:%@",historyModel.dian_id ,historyModel.video_id);
    }else {
        
        // 失败
        RWLog(@"失败");
    }
}
@end
