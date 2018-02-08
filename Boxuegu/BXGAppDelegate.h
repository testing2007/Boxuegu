//
//  BXGAppDelegate.h
//  Boxuegu
//
//  Created by RW on 2017/5/11.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DWDrmServer.h"
#import "BXGAppDelegate.h"

// 微信支付
#import <WXApi.h>

@interface BXGAppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DWDrmServer *drmServer;

@end
