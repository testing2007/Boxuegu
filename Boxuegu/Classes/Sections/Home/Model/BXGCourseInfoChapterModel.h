//
//  BXGCourseInfoChapterModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"
@class BXGCourseInfoSectionModel;
@interface BXGCourseInfoChapterModel : BXGBaseModel
@property (nonatomic, strong) NSString *idx;
@property (nonatomic, strong) NSString *course_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSArray<BXGCourseInfoSectionModel *> *chapters;
@end
