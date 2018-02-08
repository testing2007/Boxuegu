//
//  BXGThridParty.h
//  Boxuegu
//
//  Created by apple on 2017/11/3.
//  Copyright © 2017年 itcast. All rights reserved.
//

#ifndef BXGThridParty_h
#define BXGThridParty_h

// Lib 友盟
#import <UMMobClick/MobClick.h>

//#pragma mark UMeng Event
//#define VIDEO_PLAY_ERROR_EVENT @"video_play_error_event"

// 微信
#import <WechatOpenSDK/WXApi.h>

#ifdef DEBUG
#define kWeiXinAppId @"wxe16c69864fd9f634" // 测试环境
#define kWeiXinAppSc @"b14138e683f236181122d425b163d069" // 测试环境
#else
#define kWeiXinAppId @"wx5e2ef84016982adb" // 正式环境
#define kWeiXinAppSc @"d040105aa5f02454e63cbdc547feb590" // 正式环境
#endif

// QQ
#ifdef DEBUG
#define kQQAppId @"101447996"
#else
#define kQQAppId @"1106267625" // 正式环境
#endif

// 新浪
#ifdef DEBUG
#define kWeiboAppId @"2638498161"
#define kWeiboAppSc @"948ff27f09c9758aa614b4295e8550ee"
#else
#define kWeiboAppId @"945090867" // 正式环境
#define kWeiboAppSc @"b28e04f01fe528cb6d37a6f87a7632e7" // 正式环境
#endif

// 友盟
#ifdef DEBUG
#define kUmengAppKey @"58f753c2b27b0a0849000e20"
#else
#define kUmengAppKey @"58f753c2b27b0a0849000e20"
#endif


// 支付宝
#endif /* BXGThridParty_h */
