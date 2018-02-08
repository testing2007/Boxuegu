//
//  BXGCouponModel.h
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"

@class BXGOrderCouponModel;

@interface BXGCouponModel : BXGBaseViewModel

@property(nonatomic, strong) NSArray<BXGOrderCouponModel*> *items;

@end
