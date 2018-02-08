//
//  BXGOrderDetailModel.h
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@class BXGOrderCourseModel;

@interface BXGOrderDetailModel : BXGBaseModel
@property(nonatomic, strong) NSNumber *quantity;//此订单详情课程总数
@property(nonatomic, strong) NSString *total_amount;//此订单详情现价（优惠计算后）
@property(nonatomic, strong) NSString *discount_amount;//此订单详情折扣总价
@property(nonatomic, strong) NSArray<BXGOrderCourseModel*> *courses;//此订单详情包含的课程列表
@end
