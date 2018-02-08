//
//  BXGOrderPayItemModel.h
//  Boxuegu
//
//  Created by apple on 2017/10/23.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseModel.h"

@class BXGOrderPayItemDetailModel;
//订单列表 + 订单详情 共同使用
@interface BXGOrderPayItemModel : BXGBaseModel

@property(nonatomic, strong) NSString *idx; //订单id
@property(nonatomic, strong) NSString *order_no; //订单号
@property(nonatomic, strong) NSString *preferenty_way; //优惠方式
@property(nonatomic, strong) NSNumber *preferenty_money;//优惠金额
@property(nonatomic, strong) NSNumber *actual_pay;//实际支付
@property(nonatomic, strong) NSString *purchaser; //购买用户昵称
@property(nonatomic, strong) NSString *order_status; //订单支付状态 0:未支付 1:已支付 2:已关闭
@property(nonatomic, strong) NSString *original_cost; //原价
@property(nonatomic, strong) NSString *pay_account; //支付账号
@property(nonatomic, strong) NSString *pay_time; //支付时间
@property(nonatomic, strong) NSString *user_id; //当前登录用户
@property(nonatomic, strong) NSString *create_person; //创建人登录名
@property(nonatomic, strong) NSString *create_time; //样式:"2017-10-19",
@property(nonatomic, strong) NSString *order_from; //订单来源，0官网（本系统），1分销系统，2线下（刷数据）
@property(nonatomic, strong) NSNumber *pay_type; //支付类型 0:微信 1:支付宝 2:网银
@property(nonatomic, strong) NSArray<BXGOrderPayItemDetailModel*> *orderDetail;
@property(nonatomic, strong) NSString *expires; //样式: "2018-10-19"
@property(nonatomic, strong) NSNumber *discount_count; //满减金额总计

@end
