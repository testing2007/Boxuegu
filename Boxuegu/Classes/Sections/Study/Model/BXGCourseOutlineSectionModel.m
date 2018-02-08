//
//  BXGCourseOutlineSectionModel.m
//  Boxuegu
//
//  Created by HM on 2017/4/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseOutlineSectionModel.h"

@implementation BXGCourseOutlineSectionModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"idx" :@"id",
            @"dian":@[@"dian",@"points"]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"dian":[BXGCourseOutlinePointModel class],@"points":[BXGCourseOutlinePointModel class]};
    
}
@end
