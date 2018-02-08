//
//  BXGHome.h
//  Boxuegu
//
//  Created by apple on 2017/10/11.
//  Copyright © 2017年 itcast. All rights reserved.
//

#ifndef BXGHome_h
#define BXGHome_h

typedef NS_ENUM(NSInteger, COURSE_TYPE) {
    UNKNOWN_COURSE_TYPE = 0,
    CAREER_COURSE_TYPE,      //就业班
    BOUTIQUE_MICRO_COURSE_TYPE,      //精品微课
    FREE_MICRO_COURSE_TYPE,      //免费微课
};

////为百度统计而用, 进入课程筛选类型
//typedef NS_ENUM(NSUInteger, STATISIC_FILTER_ENTER_TYPE) {
//    STATISIC_FILTER_ENTER_TYPE_BOUTIQUE_MICRO = 0, //精品微课
//    STATISIC_FILTER_ENTER_TYPE_FREE_MICRO,         //免费微课
//    STATISIC_FILTER_ENTER_TYPE_CATEGORY,           //分类
//};

#endif /* BXGHome_h */
