//
//  BXGCourseInfoPointModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseInfoPointModel.h"
#import "BXGCourseInfoVideoModel.h"

@implementation BXGCourseInfoPointModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"videos":[BXGCourseInfoVideoModel class]};
}
@end
