//
//  BXGProDayPlanModel.m
//  Boxuegu
//
//  Created by RW on 2017/4/26.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGProDayPlanModel.h"

@implementation BXGProDayPlanModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"list":[BXGProCourseModel class]};
    
}
@end
