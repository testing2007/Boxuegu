//
//  BXGUserBaseInfoModel.m
//  Boxuegu
//
//  Created by apple on 2018/1/10.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "BXGUserBaseInfoModel.h"
#import "BXGUserStudyTargetModel.h"

@implementation BXGUserBaseInfoModel

+(NSDictionary*)modelContainerPropertyGenericClass {
    return @{ @"studyTarget" : [BXGUserStudyTargetModel class] };
}

@end
