//
//  BXGHistoryModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGHistoryModel.h"

@implementation BXGHistoryModel

- (BXGCourseModel *)generateCourseModel {

    BXGCourseModel *courseModel;
    if(self.course_id){
    
        courseModel = [BXGCourseModel new];
        courseModel.course_id = self.course_id;
        courseModel.course_name = self.course_name;
        courseModel.smallimg_path = self.smallimgPath;
        courseModel.type = self.course_type;
    }
    return courseModel;
}

- (BXGCourseOutlineSectionModel *)generateSectionModel; {

    BXGCourseOutlineSectionModel *secionModel;
    if(self.jie_id){
        
        secionModel = [BXGCourseOutlineSectionModel new];
        secionModel.idx = self.jie_id;
    }
    return secionModel;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"idx" :@"id",
            @"jie_id" :@"section_id",
            @"dian_id" :@"point_id",
            @"course_type" :@"courseType",};
}
@end
