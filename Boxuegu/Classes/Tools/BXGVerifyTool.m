//
//  BXGVerifyTool.m
//  Boxuegu
//
//  Created by HM on 2017/4/27.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGVerifyTool.h"

@interface BXGVerifyTool()
@property (nonatomic, strong) NSRegularExpression *expression;

@end

@implementation BXGVerifyTool


#pragma mark - Verify Function
//新密码校验
//
//1、格式：密码由6-20数字、字母或字符组成， 不能包含空格；
//2、密码格式不正确（前端校验）：密码格式错误，请重新输入
//3、密码为空（前端校验）：密码为空：请输入登录密码
//4、两次密码不一致（前端校验）：两次密码不一致，请重新输入

// 支持中文、字母、数字、'-'、'_'的组合，4-20个字符

+ (BOOL)verifyUserNameFormat:(NSString *)userName;{
    
    return [self verifyString:userName pattern:@"^[\u4e00-\u9fa5A-Za-z0-9_-]{0,10}$"];
}

+ (BOOL)verifyPswFormat:(NSString *)psw {

    // return [self verifyString:psw pattern:@"^[a-zA-Z0-9_-]{6,20}$"];
    
    return [self verifyString:psw pattern:@"^[A-Za-z0-9\x21-\x7e]{6,18}$"];
    
    // "^([A-Z]|[a-z]|[0-9]|[`~!@#$%^&*()+=|{}':;',\\\\[\\\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“'。，、？]){6,20}$"
}

//+ (BOOL)verifyNickNameFormat:(NSString *)nickName {
//
//    return [self verifyString:nickName pattern:@"[4-9]{11}"];
//}
+ (BOOL)verifyFeedbackMin:(NSString *)text {
    
    return [self verifyString:text pattern:@"^.{0,4}$"];
    // return true;
}
+ (BOOL)verifyFeedbackMax:(NSString *)text {
    
    return [self verifyString:text pattern:@"^.{5,120}$"];
    // return true;
}

+ (BOOL)verifyCodeFormat:(NSString *)code {
    
    return [self verifyString:code pattern:@"^[0-9]{6}$"];
    // return true;
}

+ (BOOL)verifyEmail:(NSString *)email {
    
    return [self verifyString:email pattern:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}
+ (BOOL)verifyPhoneNumber:(NSString *)phoneNumber {
    
    return [self verifyString:phoneNumber pattern:@"^[0-9]{11}$"];
    
//    if([self verifyString:phoneNumber pattern: @"^(133|153|180|181|189)[0-9]{8}$"]) {
//        
//        NSLog(@"中国电信手机号码开头数字 2G/3G号段(CDMA2000网络)133、153、180、181、189");
//        return true;
//    }
//    if([self verifyString:phoneNumber pattern: @"^(177|173)[0-9]{8}$"]) {
//        
//        NSLog(@"中国电信手机号码开头数字 4G号段 177、173");
//        return true;
//    }
//    if([self verifyString:phoneNumber pattern: @"^(130|131|132|155|156)[0-9]{8}$"]) {
//        
//        NSLog(@"中国联通 2G号段(GSM网络)130、131、132、155、156");
//        return true;
//    }
//    if([self verifyString:phoneNumber pattern: @"^145[0-9]{8}$"]) {
//        
//        NSLog(@"中国联通 3G上网卡145");
//        return true;
//    }
//    if([self verifyString:phoneNumber pattern: @"^(185|186)[0-9]{8}$"]) {
//        
//        NSLog(@"中国联通 3G号段(WCDMA网络)185、186");
//        return true;
//    }
//    if([self verifyString:phoneNumber pattern: @"^(176|185)[0-9]{8}$"]) {
//        
//        NSLog(@"中国联通 4G号段 176、185");
//        return true;
//    }
//    
//    if([self verifyString:phoneNumber pattern: @"^(13[5-9]|15[0-289]|18[2-4])[0-9]{8}$|^134[0-8][0-9]{7}$"]) {
//        
//        NSLog(@"中国移动 2G号段(GSM网络)有134x(0-8)、135、136、137、138、139、150、151、152、158、159、182、183、184");
//        return true;
//    }
//    
//    if([self verifyString:phoneNumber pattern: @"^(157|187|188)[0-9]{8}$"]) {
//        
//        NSLog(@"中国移动 3G号段(TD-SCDMA网络)有157、187、188");
//    }
//    
//    if([self verifyString:phoneNumber pattern: @"^147[0-9]{8}$"]) {
//        
//        NSLog(@"中国移动 3G上网卡 147");
//    }
//    
//    if([self verifyString:phoneNumber pattern: @"^178[0-9]{8}$"]) {
//        
//        NSLog(@"中国移动 4G号段 178");
//    }
    
    return false;
}

+ (BOOL)verifyString:(NSString *)str pattern:(NSString *)pattern {
    
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *result = [expression matchesInString:str options:NSMatchingReportCompletion range:NSMakeRange(0, str.length)];
    
    if(result.count){
        return true;
    }else {
        return false;
    }
}

//正则去除网络标签
+ (NSString *)getZZwithString:(NSString *)string{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                                                                                    options:0
                                                                                      error:nil];
    string = [regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    return string;
}

+ (BOOL)verifyHttpProtocolFormat:(NSString*)strURL {
    if(strURL) {
        if([strURL rangeOfString:@"http://" options:NSCaseInsensitiveSearch].location != NSNotFound ||
           [strURL rangeOfString:@"https://" options:NSCaseInsensitiveSearch].location != NSNotFound ) {
            return YES;
        }
    }
    return NO;
}
+ (BOOL)verifyQQ:(NSString *)qq {
    return [self verifyString:qq pattern:@"[1-9][0-9]{4,14}"];
}
+ (BOOL)containsEmoji:(NSString *)str; {
    __block BOOL returnValue = NO;
    if(str == nil) {
        return true;
    }
    [str enumerateSubstringsInRange:NSMakeRange(0, [str length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar high = [substring characterAtIndex: 0];
                              
                              // Surrogate pair (U+1D000-1F9FF)
                              if (0xD800 <= high && high <= 0xDBFF) {
                                  const unichar low = [substring characterAtIndex: 1];
                                  const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                  
                                  if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                      returnValue = YES;
                                  }
                                  
                                  // Not surrogate pair (U+2100-27BF)
                              } else {
                                  if (0x2100 <= high && high <= 0x27BF){
                                      returnValue = YES;
                                  }
                              }
                          }];
    return returnValue;
}
@end
