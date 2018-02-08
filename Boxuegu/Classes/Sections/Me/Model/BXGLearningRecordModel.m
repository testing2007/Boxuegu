//
//  BXGLearningRecordModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/8.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGLearningRecordModel.h"

@implementation BXGLearningRecordModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"idx" :@"id"};
}
- (BXGCourseModel *)generateCourseModel; {

    BXGCourseModel *courseModel = [BXGCourseModel new];
    courseModel.course_id = self.course_id;
    courseModel.type = self.courseType;
    courseModel.smallimg_path = self.smallimgPath;
    courseModel.course_name = self.course_name;
    return courseModel;
}

- (BXGCourseOutlineSectionModel *)generateSectionModel; {

    BXGCourseOutlineSectionModel *sectionModel = [BXGCourseOutlineSectionModel new];
    sectionModel.idx = self.section_id;
    return sectionModel;
}
@end
