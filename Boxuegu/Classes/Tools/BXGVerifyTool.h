//
//  BXGVerifyTool.h
//  Boxuegu
//
//  Created by HM on 2017/4/27.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXGVerifyTool : NSObject

+ (BOOL)verifyPswFormat:(NSString *)psw;
+ (BOOL)verifyPhoneNumber:(NSString *)phoneNumber;
+ (BOOL)verifyUserNameFormat:(NSString *)userName;
+ (BOOL)verifyFeedbackMin:(NSString *)text;
+ (BOOL)verifyFeedbackMax:(NSString *)text;
+ (BOOL)verifyCodeFormat:(NSString *)code;
+ (BOOL)verifyEmail:(NSString *)email;
+ (BOOL)verifyQQ:(NSString *)qq;
+ (NSString *)getZZwithString:(NSString *)string;

+ (BOOL)verifyHttpProtocolFormat:(NSString*)strURL;
+ (BOOL)containsEmoji:(NSString *)str;
@end

