//
//  BXGProCourseModel.h
//  Boxuegu
//
//  Created by HM on 2017/4/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 职业课程知识点模型(最小)
 */
@interface BXGProCourseModel : BXGBaseModel

@property (nonatomic, strong) NSString *course_id;
@property (nonatomic, strong) NSString *plan_date;
@property (nonatomic, strong) NSString *charpter_id;
@property (nonatomic, assign) BOOL chuanjiang_has;
@property (nonatomic, strong) NSString *grade_id;
@property (nonatomic, assign) BOOL rest_has;
@property (nonatomic, strong) NSString *plan_template_id;
@property (nonatomic, strong) NSString *plan_id;
@property (nonatomic, strong) NSString *charpter_name;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString *parent_id; // jie_id
@property (nonatomic, strong) NSString *video_count;
@property (nonatomic, strong) NSString *learned_count;


// 1.1.1 added


@end
