//
//  BXGWechatPayTool.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/11/10.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGWechatPayTool.h"

@implementation BXGWechatPayTool


+(void)callWeixin:(PayReq*)payReq {
    //调起微信支付
//    PayReq* req             = [[PayReq alloc] init];
//    req.partnerId           = payReq.partnerId;
//    req.prepayId            = payReq.prepayId;
//    req.nonceStr            = payReq.nonceStr;
//    req.timeStamp           = [payReq.timeStamp integerValue];
//    req.package             = payReq.package;
//    req.sign                = payReq.sign;
    [WXApi sendReq:payReq];
}


@end
