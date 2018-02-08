//
//  BXGMicroFilterDirectionModel.m
//  Boxuegu
//
//  Created by apple on 2017/10/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMicroFilterDirectionModel.h"
#import "BXGMicroFilterSubjectModel.h"

@implementation BXGMicroFilterDirectionModel

+(NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"subject" : [BXGMicroFilterSubjectModel class]};
}

@end
