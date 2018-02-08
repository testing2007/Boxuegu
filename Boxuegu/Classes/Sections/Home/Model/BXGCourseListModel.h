//
//  BXGCourseListModel.h
//  Boxuegu
//
//  Created by apple on 2017/10/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@class BXGHomeCourseModel;

@interface BXGCourseListModel : BXGBaseModel

@property(nonatomic, strong) NSArray<BXGHomeCourseModel*> *careerCourse;
@property(nonatomic, strong) NSArray<BXGHomeCourseModel*> *boutiqueMicroCourse;
@property(nonatomic, strong) NSArray<BXGHomeCourseModel*> *freeMicroCourse;

@end
