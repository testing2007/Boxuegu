//
//  BXGOrderSaveOrderModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGOrderSaveOrderModel : BXGBaseModel

- (instancetype)initCourseCouponDict:(NSDictionary*)courseCouponDict
                      andTotalAmount:(NSString*)totalAmount
                        andOrderFrom:(NSString*)orderFrom
                          andPayType:(NSString*)payType;

- (instancetype)initWithFreeCourseId:(NSString *)courseId;

@property (nonatomic, strong) NSDictionary *courseCoupon; // {"384":0,"443":0,"536":0}, 免费 "courseId":-1
@property (nonatomic, strong) NSString *totalAmount;
@property (nonatomic, strong) NSString *orderFrom; // App 4
@property (nonatomic, strong) NSString *payType;

//{"courseCoupon":{"384":0,"443":0,"536":0},"totalAmount":"1493.00","orderFrom":4,"payType":0}
@end
