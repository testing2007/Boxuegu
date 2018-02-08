//
//  BXGOrderPayWechatModel.h
//  Boxuegu
//
//  Created by apple on 2017/11/11.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderPayBaseModel.h"
#import <WXApiObject.h>

@interface BXGOrderPayWechatModel : BXGOrderPayBaseModel

@property (nonatomic, strong) NSString *partnerid;
/** 预支付订单 */
@property (nonatomic, strong) NSString *prepayid;
/** 随机串，防重发 */
@property (nonatomic, strong) NSString *noncestr;
/** 时间戳，防重发 */
@property (nonatomic, strong) NSString *timestamp;
/** 商家根据财付通文档填写的数据和签名 */
@property (nonatomic, strong) NSString *package;
/** 商家根据微信开放平台文档对数据做的签名 */
@property (nonatomic, strong) NSString *sign;

- (PayReq *)generateWeChatPayReq;

@end
