//
//  BXGOrderSaveOrderModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderSaveOrderModel.h"

@implementation BXGOrderSaveOrderModel
- (instancetype)initWithFreeCourseId:(NSString *)courseId; {
    self = [super init];
    if(self) {
        NSDictionary *courseCoupon = @{courseId:@(-1)};
        self.courseCoupon = courseCoupon;
        self.payType = @"0";
        self.orderFrom = @"4";
        self.totalAmount = @"0";
    }
    return self;
}

- (instancetype)initCourseCouponDict:(NSDictionary*)courseCouponDict
                              andTotalAmount:(NSString*)totalAmount
                                andOrderFrom:(NSString*)orderFrom
                                  andPayType:(NSString*)payType {
    self = [super init];
    if(self) {
        self.courseCoupon = courseCouponDict;
        self.payType = payType;
        self.orderFrom = orderFrom;
        self.totalAmount =totalAmount;
    }
    return self;
}

@end
