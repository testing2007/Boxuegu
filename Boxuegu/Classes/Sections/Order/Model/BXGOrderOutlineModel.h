//
//  BXGOrderOutlineModel.h
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"
@class BXGOrderDetailModel;

@interface BXGOrderOutlineModel : BXGBaseModel

@property(nonatomic, strong) NSNumber *total_quantity; //订单总课程数
@property(nonatomic, strong) NSString *total_price; //订单未优惠前总价格
@property(nonatomic, strong) NSString *total_amount; //订单优惠后总价格
@property(nonatomic, strong) NSString *total_discount_amount; //订单优惠总价格
@property(nonatomic, strong) NSArray<BXGOrderDetailModel*> *detail;

@end
