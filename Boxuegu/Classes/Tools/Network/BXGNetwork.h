//
//  BXGNetwork.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/12/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#ifndef BXGNetwork_h
#define BXGNetwork_h
#import "BXGNetworkParser.h"
#import "BXGLogMonitor.h"

#define kTestUserBaseURLString @"http://online-test.boxuegu.com/"
//#define kTestUserBaseURLString @"http://172.16.1.37/"

#define kTestURL @"http://online-test2.boxuegu.com/"
#define BaseUrlStringTest03 @"http://211.103.142.26:5881/"
#define kTestConsultBaseUrlString @"http://consult-t.boxuegu.com/"
#define CommunityBaseUrlStringTest01 @"http://211.103.142.26:5881/"

#define BaseUrlStringOffcial @"https://app.boxuegu.com/"
#define BaseConsultUrlStringOffcial @"https://app.boxuegu.com/consult/"


#define NetworkTEST
#define NetworkOfficial

// APP
#ifdef DEBUG
#define MainBaseUrlString BaseUrlStringTest03
#else
#define MainBaseUrlString BaseUrlStringOffcial
#endif

// BBS
#ifdef DEBUG
#define CommunityBaseUrlString BaseUrlStringTest03
#else
#define CommunityBaseUrlString BaseUrlStringOffcial
#endif

// CONSULT
#ifdef DEBUG
#define kConsultBaseUrlString kTestConsultBaseUrlString
#else
#define kConsultBaseUrlString BaseConsultUrlStringOffcial
#endif

// USER
#ifdef DEBUG
#define kUserBaseURL kTestUserBaseURLString
#else
#define kUserBaseURL BaseUrlStringOffcial
#endif

#define RWNetworkLog(format, ...) \
do { \
NSString *strContent = [NSString stringWithFormat:@"[%s] [Thread:%p] %s [第%d行] %@\n",  __TIME__, [NSThread currentThread], __FUNCTION__, __LINE__, [NSString stringWithFormat:format, ## __VA_ARGS__]  ]; \
[[BXGLogMonitor share] addLogInfo:strContent]; \
} while(0);

//// LOG
//#ifdef DEBUG
//#define NETWORK_LOG_ON // Network Log 开关
//#else
////#define NETWORK_LOG_ON
//#endif
//
//#ifdef NETWORK_LOG_ON
//#define RWNetworkLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
//#else
//#define RWNetworkLog(fmt, ...)
//#endif

#endif /* BXGNetwork_h */
