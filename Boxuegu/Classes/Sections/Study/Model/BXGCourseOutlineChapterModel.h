//
//  BXGCourseOutlineChapterModel.h
//  Boxuegu
//
//  Created by RW on 2017/4/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGCourseOutlineSectionModel.h"

/**
 课程大纲章模型
 */
@interface BXGCourseOutlineChapterModel : BXGBaseModel

@property (nonatomic, strong) NSString *idx; /// 章id
@property (nonatomic, strong) NSString *name; /// 章名称
@property (nonatomic, strong) NSMutableArray<BXGCourseOutlineSectionModel*> *jie; /// 课程大纲节模型数组
@property (nonatomic, strong) NSNumber *sort; /// 排序号

// extension
@property (nonatomic, strong) NSArray<BXGCourseOutlinePointModel*> *dianArray; /// 所有的点
@end
