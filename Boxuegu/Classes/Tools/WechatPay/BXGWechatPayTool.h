//
//  BXGWechatPayTool.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/11/10.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BXGOrderPayWechatModel;

@interface BXGWechatPayTool : NSObject

+(void)callWeixin:(PayReq*)payReq;

@end
