//
//  BXGOrderPayItemDetailModel.h
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGOrderPayItemDetailModel : BXGBaseModel

@property(nonatomic, strong) NSNumber *price; //课程原价
@property(nonatomic, strong) NSNumber *actual_pay; //实际应付
@property(nonatomic, strong) NSNumber *idx;
@property(nonatomic, strong) NSString *grade_name; //课程名称
@property(nonatomic, strong) NSString *smallimg_path; //课程图片

@end
