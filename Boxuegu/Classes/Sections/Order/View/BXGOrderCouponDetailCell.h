//
//  BXGOrderCouponDetailCell.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/25.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BXGOrderCouponModel;
@interface BXGOrderCouponDetailCell : UITableViewCell
@property (nonatomic, strong) BXGOrderCouponModel *couponModel;
@property (nonatomic, assign) BOOL isArrow;
@end
