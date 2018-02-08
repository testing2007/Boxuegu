//
//  BXGUserViewModel.h
//  Boxuegu
//
//  Created by HM on 2017/4/14.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGBaseViewModel.h"

typedef enum : NSInteger {
    BXGUserLoginResultNetworkError = 0,
    BXGUserLoginResultSuccess = 1,
    BXGUserLoginResultUncorrected,
    BXGUserLoginResultUnsigned,
    BXGUserLoginResultFailed,
} BXGUserLoginResultState;

@interface BXGUserViewModel : BXGBaseViewModel

+ (instancetype _Nullable )share;

- (void)requestSendCodeForRegistWithMobile:(NSString *_Nullable)mobile Finished:(void(^_Nullable)(BOOL success))finishedBlock Failed:(void(^_Nullable)(id  _Nonnull errorMessage))failedBlock;

-(void)requestPhoneRegistWithUserName:(NSString*_Nonnull)userName passWord:(NSString*_Nullable)passWord mobile:(NSString*_Nullable)mobile code:(NSString*_Nonnull)code Finished:(void(^_Nullable)(id _Nonnull responseObject))finishedBlock Failed:(void(^_Nullable)(NSError * _Nullable  error))failedBlock;

-(void)requestLoginUserName:(NSString*_Nullable)userName passWord:(NSString*_Nullable)passWord Finished:(void(^_Nullable)(id _Nullable responseObject))finishedBlock Failed:(void(^_Nullable)(NSString * _Nullable))failedBlock;

-(void)requestRegistCodeWithMobile:(NSString*_Nullable)mobile Finished:(void(^_Nullable)(id _Nullable responseObject))finishedBlock Failed:(void(^_Nullable)(NSError * _Nullable error))failedBlock;

- (void)requestSendCodeForResetPswWithMobile:(NSString * _Nullable)mobile
                                    Finished:(void(^ _Nullable)(BOOL success,NSString * _Nullable errorMessage))finishedBlock;

- (void)loadAppRequestCodeWithMobile:(NSString * _Nullable)mobile
                          withIsBind:(BOOL)bBind
                            Finished:(void(^_Nullable)(BOOL success,NSString * _Nullable errorMessage))finishedBlock;

/**
 请求 重置密码
 */

-(void)requestResetPassWord:(NSString* _Nullable)passWord mobile:(NSString* _Nullable)mobile Finished:(void(^ _Nullable)(BOOL success,NSString * _Nullable errorMessage))finishedBlock;


/**
 校验动态码
 */

- (void)checkVerificationCodeForRegist:(NSString * _Nullable)code mobile:(NSString * _Nullable)mobile andFinished:(void(^_Nullable)(BOOL success))finishedBlock Failed:(void(^_Nullable)(id _Nullable errorMessage))failedBlock;
- (void)checkVerificationCodeForResetPsw:(NSString * _Nullable)code mobile:(NSString * _Nullable)mobile andFinished:(void(^_Nullable)(BOOL success))finishedBlock Failed:(void(^_Nullable)(id _Nullable errorMessage))failedBlock;

// - (void)loadProCourseNameStringWithFinished:(void(^_Nullable)(NSString * _Nullable result))completedBlock Failed:(void(^_Nullable)(NSError*_Nullable error))failedBlock;

- (void)saveLastUserID:(NSString *_Nullable)userId;
- (void)saveCourseName:(NSString *_Nullable)courseName;


/**
 获取上次登录ID

 @return return value description
 */
- (NSString *_Nullable)loadLastUserID;


/**
 请求发送动态码
 */

@end
