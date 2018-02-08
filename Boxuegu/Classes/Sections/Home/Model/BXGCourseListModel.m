//
//  BXGCourseListModel.m
//  Boxuegu
//
//  Created by apple on 2017/10/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseListModel.h"
#import "BXGHomeCourseModel.h"

@implementation BXGCourseListModel

+(NSDictionary*)modelContainerPropertyGenericClass {
 return @{@"careerCourse":[BXGHomeCourseModel class],
          @"boutiqueMicroCourse" : [BXGHomeCourseModel class],
          @"freeMicroCourse" : [BXGHomeCourseModel class]};
}

@end
