//
//  BXGWechatPayReq.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/11/10.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApiObject.h>

@interface BXGWechatPayReq : BXGBaseModel
@property (nonatomic, strong) NSString *partnerId;
/** 预支付订单 */
@property (nonatomic, strong) NSString *prepayId;
/** 随机串，防重发 */
@property (nonatomic, strong) NSString *nonceStr;
/** 时间戳，防重发 */
@property (nonatomic, strong) NSString *timeStamp;
/** 商家根据财付通文档填写的数据和签名 */
@property (nonatomic, strong) NSString *package;
/** 商家根据微信开放平台文档对数据做的签名 */
@property (nonatomic, strong) NSString *sign;


@end
