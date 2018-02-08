//
//  BXGProCoursePlayerContentVC.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/22.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBasePlayerContentVC.h"
#import "BXGCourseModel.h"
#import "BXGCourseOutlineSectionModel.h"
@interface BXGProCoursePlayerContentVC : BXGBasePlayerContentVC

- (instancetype)initWithCourseModel:(BXGCourseModel *)courseModel;
- (instancetype)initWithCourseModel:(BXGCourseModel *)courseModel andSectionModel:(BXGCourseOutlineSectionModel *)sectionModel;
@end
