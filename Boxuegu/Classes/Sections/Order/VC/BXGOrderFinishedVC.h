//
//  BXGOrderFinishedVC.h
//  Boxuegu
//
//  Created by apple on 2017/10/26.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseRootVC.h"

@interface BXGOrderFinishedVC : BXGBaseRootVC

@property(nonatomic, assign) NSString *orderId;
@property(nonatomic, assign) NSString *orderNo;
@property(nonatomic, assign) OrderPayStatus orderPayStatus;

@end
