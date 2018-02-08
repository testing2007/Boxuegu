//
//  BXGMeOrderVC.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseRootVC.h"
//待支付", @"已完成", @"已失效
typedef NS_ENUM(NSUInteger, BXGMeOrderSelectedType) {
    BXGMeOrderSelectedTypeWaitingPay = 0,
    BXGMeOrderSelectedTypeDone = 1,
    BXGMeOrderSelectedTypeExpired = 2,
};

@interface BXGMeOrderVC : BXGBaseRootVC
@property (nonatomic, assign) BXGMeOrderSelectedType selectedType;
@end
