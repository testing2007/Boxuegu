//
//  BXGOrderPayWechatModel.m
//  Boxuegu
//
//  Created by apple on 2017/11/11.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGOrderPayWechatModel.h"

@implementation BXGOrderPayWechatModel
- (PayReq *)generateWeChatPayReq {
    
    PayReq *req = [PayReq new];
    req.partnerId = self.partnerid;
    req.prepayId = self.prepayid;
    req.nonceStr = self.noncestr;
    req.timeStamp = self.timestamp.intValue;
    req.package = self.package;
    req.sign = self.sign;
    return req;
}
@end
