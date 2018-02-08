//
//  BXGCourseOutlineVideoModel.h
//  Boxuegu
//
//  Created by HM on 2017/4/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXGCourseOutlinePointModel;
/**
 课程大纲视频模型
 */
@interface BXGCourseOutlineVideoModel : BXGBaseModel<NSCoding>

@property (nonatomic, strong) NSString *idx; // BXG videoId
@property (nonatomic, strong) NSString *video_id; // CC videoId
@property (nonatomic, strong) NSString *name;
/// 1是解锁 0未解锁
@property (nonatomic, strong) NSNumber *lock_status;
@property (nonatomic, strong) NSNumber *sort;
/// 0 为学习, 1.已学习, 2.学习中
@property (nonatomic, strong) NSNumber *study_status;
#pragma mark - extension
@property (nonatomic, strong) BXGCourseOutlinePointModel *superPointModel;

@property (nonatomic, strong) NSString *last_learn_time;
@end
