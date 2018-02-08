//
//  BXGCategoryProCourseModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGCategoryProCourseModel : BXGBaseModel
@property (nonatomic, strong) NSString *courseId;
@property (nonatomic, strong) NSString *courseName;
@property (nonatomic, strong) NSString *courseImg;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *videoCount;
@property (nonatomic, strong) NSString *learndCount;
@end
