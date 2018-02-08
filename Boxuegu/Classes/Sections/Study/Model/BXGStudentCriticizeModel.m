//
//  BXGStudentCriticizeModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGStudentCriticizeModel.h"

@implementation BXGStudentCriticizeModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"items":[BXGStudentCriticizeItemModel class]};
    
}
@end
