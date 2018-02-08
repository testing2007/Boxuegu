//
//  BXGCourseInfoChapterModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseInfoChapterModel.h"
#import "BXGCourseInfoSectionModel.h"
@implementation BXGCourseInfoChapterModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"chapters":[BXGCourseInfoSectionModel class]};
}
@end
