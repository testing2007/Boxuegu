//
//  BXGMoreMicroCourseVC.h
//  Boxuegu
//
//  Created by apple on 2017/10/10.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseRootVC.h"
#import "BXGHome.h"

@interface BXGMoreMicroCourseVC : BXGBaseRootVC
@property(nonatomic, assign) COURSE_TYPE type;
//@property(nonatomic, assign) STATISIC_ENTER_FILTER_TYPE statisticEnterFilterType;

@property(nonatomic, strong) NSNumber *directionId;//学科方向
@property(nonatomic, strong) NSNumber *subjectId;//学科
@property(nonatomic, strong) NSNumber *tagId;//分类
@property(nonatomic, strong) NSNumber *levelId;//课程等级:0-基础 1-进阶 2-提高
@property(nonatomic, strong) NSNumber *contentTypeId;//课程内容:0-全部 1-知识点精讲 2-项目实战
@property(nonatomic, strong) NSNumber *orderTypeId; //排序方式:0-综合 1-最新 2-最热
@property(nonatomic, strong) NSNumber *freeId;//精品微课:0; 免费微课:1

@end
