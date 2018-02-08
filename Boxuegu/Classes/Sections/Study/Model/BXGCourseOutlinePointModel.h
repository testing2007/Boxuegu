//
//  BXGCourseOutlinePointModel.h
//  Boxuegu
//
//  Created by RW on 2017/4/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGCourseOutlineVideoModel.h"

@class BXGCourseOutlineChapterModel;

/**
 课程大纲点模型
 */
@interface BXGCourseOutlinePointModel : BXGBaseModel<NSCoding>

@property (nonatomic, strong) NSMutableArray<BXGCourseOutlineVideoModel *> *videos; // BXGCourseOutlineVideoModel
@property (nonatomic, strong) NSString *idx;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *parent_id;
@property (nonatomic, assign) NSNumber *lock_status;
@property (nonatomic, assign) NSNumber *barrier_status;
@property (nonatomic, strong) NSNumber *sort;

// extension
@property (nonatomic,weak) BXGCourseOutlineChapterModel *superChapterModel;
- (NSInteger)indexForVideoModel:(BXGCourseOutlineVideoModel *)videoModel;
- (NSInteger)indexForVideoId:(NSString *)videoId;
- (BXGCourseOutlineVideoModel *)videoModelForVideoId:(NSString *)videoId;
- (BXGCourseOutlineVideoModel *)videoModelForLastLearned;
@end
