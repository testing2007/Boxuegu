//
//  BXGStudentCriticizeTotalModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudentCriticizeTotalModel.h"

@implementation BXGStudentCriticizeTotalModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return@{@"idx" :@"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"criticize":[BXGStudentCriticizeModel class]};
}

@end
