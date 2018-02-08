//
//  BXGOrderPayItemDetailModel.m
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderPayItemDetailModel.h"

@implementation BXGOrderPayItemDetailModel

//订单详情 与 订单列表 接口需要共同使用
+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"idx" : @[@"course_id", @"id"],
//            @"idx" : @"id",
            @"smallimg_path" : @[@"course_img", @"smallimg_path"],
            @"grade_name" : @[@"course_name", @"grade_name"]
            };
} 

//+ (NSDictionary *)modelCustomPropertyMapper {
//    
//    return@{@"idx" :@"id"
//            ,@"jie":@[@"chapters",@"jie"]};
//}
//
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    
//    return @{@"jie":[BXGCourseOutlineSectionModel class],@"chapters":[BXGCourseOutlineSectionModel class]};
//}


@end
