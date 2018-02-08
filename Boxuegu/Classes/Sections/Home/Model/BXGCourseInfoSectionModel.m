//
//  BXGCourseInfoSectionModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseInfoSectionModel.h"
#import "BXGCourseInfoPointModel.h"

@implementation BXGCourseInfoSectionModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"points":[BXGCourseInfoPointModel class]};
}
@end
