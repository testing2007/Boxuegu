//
//  BXGCourseOutlineSectionModel.h
//  Boxuegu
//
//  Created by HM on 2017/4/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGCourseOutlinePointModel.h"

/**
 课程大纲组模型
 */
@interface BXGCourseOutlineSectionModel : BXGBaseModel

@property (nonatomic, strong) NSMutableArray<BXGCourseOutlinePointModel *> *dian;
@property (nonatomic, strong) NSString *idx;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *sort;
@property (nonatomic, strong) NSString *videoCount;
@property (nonatomic, strong) NSString *learndCount;
@end
