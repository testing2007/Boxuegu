//
//  BXGOrderCourseModel.h
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@class BXGOrderCouponModel;

@interface BXGOrderCourseModel : BXGBaseModel

@property(nonatomic, strong) NSString *idx; //课程id
@property(nonatomic, strong) NSString *name; //课程名称
@property(nonatomic, strong) NSString *price; //课程原价
@property(nonatomic, strong) NSString *amount; //课程计算优惠后价格
@property(nonatomic, strong) NSString *discount_amount; //课程折扣价格
@property(nonatomic, strong) NSString *expires;//课程服务有效期至  样式:"2018-10-20",
@property(nonatomic, strong) NSString *image; //课程图片
@property(nonatomic, strong) NSNumber *currentCoupon;//当前选择的优惠券id。优惠券id默认初始化为均为0；用户选择此课程不使用优惠券，则优惠券id=-1
@property(nonatomic, strong) NSNumber *useableCouponAmount;//课程可使用的优惠券数量
@property(nonatomic, strong) NSArray<BXGOrderCouponModel*> *coupons;

@end
