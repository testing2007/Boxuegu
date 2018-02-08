//
//  BXGOrderDetailCell.h
//  Boxuegu
//
//  Created by apple on 2017/10/24.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXGOrderDetailCell : UITableViewCell

@property(nonatomic, weak) UILabel *payStyleLabel; //支付方式
@property(nonatomic, weak) UILabel *amountLabel; //支付金额
@property(nonatomic, weak) UILabel *discountAmountLabel;
@property(nonatomic, weak) UILabel *overAmountLabel; //满减优惠
@property(nonatomic, weak) UILabel *payPriceLabel;//实付金额
@property(nonatomic, weak) UILabel *orderTimeLabel;//下单时间 格式:2016-12-12 09:29:37
@property(nonatomic, weak) UILabel *payTimeLabel;//支付时间

@end
