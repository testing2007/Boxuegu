//
//  BXGStudyPayCourseModel.h
//  Boxuegu
//
//  Created by RW on 2017/5/10.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 职业课程信息模型
 */
@interface BXGStudyPayCourseModel : BXGBaseModel

@property (nonatomic, strong) NSString *course_expiry_date;
@property (nonatomic, strong) NSString *course_id;
@property (nonatomic, strong) NSString *course_name;
@property (nonatomic, strong) NSString *isoneyuan_course;
@property (nonatomic, strong) NSString *smallimg_path;
@property (nonatomic, strong) NSString *teacher_name;

@end
