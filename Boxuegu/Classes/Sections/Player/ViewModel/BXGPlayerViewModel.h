//
//  BXGPlayerViewModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/21.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
#import "BXGCourseOutlinePointModel.h"
#import "BXGCourseModel.h"


@interface BXGPlayerViewModel : BXGBaseViewModel

// required
- (instancetype)initWithCourseModel:(BXGCourseModel *)courseModel andPontModelArray:(NSArray *)pointArray;
- (instancetype)initWithCourseModel:(BXGCourseModel *)courseModel;

@property (nonatomic, strong) BXGCourseModel *courseModel;
@property (nonatomic, strong) NSArray *pointModelArray;

#pragma mark - 学习进度相关

//- (void)updateUserStudyStateToBeginWithVideoId:(NSString *)videoId andCourseId:(NSString *)courseId;
//- (void)updateUserStudyStateToFinishWithVideoId:(NSString *)videoId andCourseId:(NSString *)courseId ;
- (void)updateUserStudyStateWithIsLearning:(BOOL)isLearning andVideoId:(NSString *)videoId andCourseId:(NSString *)courseId;
- (NSString *)localPathForVideoModel:(BXGCourseOutlineVideoModel *)videoModel;
- (void)saveHistoryWithVideoModel:(BXGCourseOutlineVideoModel *)videoModel andPer:(double)per;
- (BXGCourseOutlinePointModel *)firstPointModel;
- (BXGCourseOutlineVideoModel *)firstVideoModel:(BXGCourseOutlinePointModel *)pointModel;
- (BXGCourseOutlineVideoModel *)nextVideoModel:(BXGCourseOutlineVideoModel *)videoModel;
- (BXGCourseOutlinePointModel *)nextPointModel:(BXGCourseOutlinePointModel *)pointModel;
- (BXGCourseOutlineVideoModel *)videoModelWithVideoId:(NSString *)videoId;
- (BXGCourseOutlinePointModel *)pointModelWithPointId:(NSString *)pointId;

- (BXGCourseOutlineVideoModel *)videoModelForLastLearned;

@end
