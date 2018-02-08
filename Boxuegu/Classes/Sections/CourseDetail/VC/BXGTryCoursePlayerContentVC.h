//
//  BXGTryCoursePlayerContentVC.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBasePlayerContentVC.h"
@class BXGHomeCourseModel;
typedef NS_ENUM(NSUInteger, BXGTryCourseType) {
    BXGTryCourseTypeMiniCourse = 1,
    BXGTryCourseTypeProCourse = 0,
};


@interface BXGTryCoursePlayerContentVC : BXGBasePlayerContentVC
//- (instancetype)initWithCourseId:(NSString *)courseId andCourseType:(BXGTryCourseType)courseType;
- (instancetype)initWithCourseModel:(BXGHomeCourseModel *)courseModel                                                                                                                                            andCourseType:(BXGTryCourseType)courseType;
@end
