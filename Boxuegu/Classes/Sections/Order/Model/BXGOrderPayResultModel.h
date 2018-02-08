//
//  BXGOrderPayResultModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/11/11.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@interface BXGOrderPayResultModel : BXGBaseModel
@property (nonatomic, strong) NSString *order_no;
@property (nonatomic, strong) NSString *actual_pay;
@property (nonatomic, strong) NSString *pay_time;
@property (nonatomic, strong) NSString *pay_type;
@property (nonatomic, strong) NSString *orderContent;
@end
