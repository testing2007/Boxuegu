//
//  BXGCourseProgressInfoModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/26.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCourseProgressInfoModel.h"

@implementation BXGCourseProgressInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"chapterList":[BXGCourseProgressChapterModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"descriptionX" :@"description"};
}
@end
