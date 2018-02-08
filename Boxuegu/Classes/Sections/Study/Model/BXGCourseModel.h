//
//  BXGCourseModel.h
//  Boxuegu
//
//  Created by Renying Wu on 2017/5/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

typedef enum : NSUInteger {
    
    BXGCourseModelTypeProCourse = 0, // 职业课
    BXGCourseModelTypeMiniCourse = 1, // 微课
}BXGCourseModelType;

/**
 学习中心 - 课程模型
 */
@interface BXGCourseModel : BXGBaseModel

@property (nonatomic, strong) NSString *course_name;
@property (nonatomic, strong) NSString *course_id;
@property (nonatomic, strong) NSString *smallimg_path;
@property (nonatomic, strong) NSString *learnd_sum; // 人数
@property (nonatomic, strong) NSString *teacher_name;
@property (nonatomic, strong) NSString *course_length;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *learnd_count; // 课时

// 学习计划
@property (nonatomic, strong) NSNumber *isExistPlan;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *parent_id;

// 追踪
@property (nonatomic, strong) NSString *chapter_id; // point id
@property (nonatomic, strong) NSString *video_id;
@property (nonatomic, strong) NSString *video_name;
@property (nonatomic, strong) NSString *last_learn_time;
@property (nonatomic, strong) NSString *smallimgPaht; // 接口变量名错误
@end
