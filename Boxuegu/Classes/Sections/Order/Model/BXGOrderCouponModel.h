//
//  BXGOrderCouponModel.h
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

typedef NS_ENUM(NSUInteger, BXGOrderCouponType) {
    BXGOrderCouponTypeEnable,
    BXGOrderCouponTypeExpired,
    BXGOrderCouponTypeUsed,
    BXGOrderCouponTypeDisable,
};

@interface BXGOrderCouponModel : BXGBaseModel

@property(nonatomic, strong) NSString *createPerson;
@property(nonatomic, strong) NSString *createTime;
@property(nonatomic, strong) NSString *idx;
@property(nonatomic, strong) NSString *serialNo;
@property(nonatomic, strong) NSString *type; //优惠券类型：代金券/CASH、折扣券/DISCOUNT
@property(nonatomic, strong) NSNumber *discount;
@property(nonatomic, strong) NSNumber *expireDay; //过期天数
@property(nonatomic, strong) NSString *courseNames;
@property(nonatomic, strong) NSNumber *courseAmount;
@property(nonatomic, strong) NSString *startTime;// "2017-10-17 09:21:21.0",
@property(nonatomic, strong) NSString *endTime;  // "2017-10-18 09:21:21.0",
@property(nonatomic, strong) NSNumber *couponGroupId;
@property(nonatomic, strong) NSString *limitCourse;
@property(nonatomic, strong) NSString *limitCatalog;
@property(nonatomic, strong) NSString *limitSubject;
@property(nonatomic, strong) NSNumber *isDelete;
// extension
@property (nonatomic, assign) BXGOrderCouponType enableType;
//"expectDiscountAmount":"100.00",
//"expires":"2017-11-30 14:20:15",
//"id":1022574,
//"name":"App优惠测试20171023",
//"type":"CASH",
//"value":"100.00"
@end
