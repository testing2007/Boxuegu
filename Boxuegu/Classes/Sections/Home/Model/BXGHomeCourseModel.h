//
//  BXGHomeCourseModel.h
//  Boxuegu
//
//  Created by apple on 2017/10/18.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGHomeCourseModel : BXGBaseModel

@property (nonatomic, strong) NSString *courseId;       //课程ID
@property (nonatomic, strong) NSString *courseName;     //课程名称
@property (nonatomic, strong) NSString *courseImg;      //课程展示图
@property (nonatomic, strong) NSString *des;            //课程描述
@property (nonatomic, strong) NSNumber *videoCount;     //课程总课时
@property (nonatomic, strong) NSNumber *learndCount;    //学习人数
@property (nonatomic, strong) NSNumber *originalPrice;  //课程原价
@property (nonatomic, strong) NSNumber *currentPrice;   //课程现价
@property (nonatomic, strong) NSNumber *courseType;     //课程类型 0-就业课 1-微课
@property (nonatomic, strong) NSNumber *isFree;         //是否免费 0-否 1-是
@property (nonatomic, strong) NSNumber *useStart;
@property (nonatomic, strong) NSNumber *subjectId;
@property (nonatomic, strong) NSNumber *isApply;
@property (nonatomic, strong) NSNumber *existTry;
@end


