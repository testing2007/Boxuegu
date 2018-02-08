//
//  BXGMicroFilterSubjectModel.m
//  Boxuegu
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMicroFilterSubjectModel.h"
#import "BXGMicroFilterCategoryModel.h"

@implementation BXGMicroFilterSubjectModel

+(NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"tag" : [BXGMicroFilterCategoryModel class]};
}

@end
