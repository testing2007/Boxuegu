//
//  BXGProCoursePlayerVC.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/7/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BXGBasePlayerVC.h"
#import "BXGCourseOutlineSectionModel.h"
#import "BXGCourseModel.h"

@interface BXGProCoursePlayerVC : BXGBasePlayerVC

- (instancetype)initWithCourseModel:(BXGCourseModel *)courseModel;
@property (nonatomic, strong) BXGCourseOutlineSectionModel *model;

@end
