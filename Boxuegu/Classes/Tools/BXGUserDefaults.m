//
//  BXGUserInfoTool.m
//  Boxuegu
//
//  Created by HM on 2017/4/20.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGUserDefaults.h"

@interface BXGUserDefaults()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

@implementation BXGUserDefaults
@synthesize arrHistorySearchRecord = _arrHistorySearchRecord;

- (NSUserDefaults *)userDefaults {

    return [NSUserDefaults standardUserDefaults];
}


static BXGUserDefaults *instance;
+(instancetype)share {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [BXGUserDefaults new];
    });
    return instance;
}

-(BOOL)isLogin {

    NSNumber *isLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"];
    if(isLogin == nil) {
    
        return false;
    }
    
    return [isLogin boolValue];
}

-(void)setIsLogin:(BOOL)isLogin {

    [[NSUserDefaults standardUserDefaults] setObject:@(isLogin) forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)setUserModel:(BXGUserModel *)userModel {

    if(!userModel) {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userModel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    NSDictionary *dict = [userModel dictionaryWithValuesForKeys:@[@"sign",@"user_id",@"head_img",@"nickname",@"username",@"cc_user_id",@"cc_api_key",@"psw",@"itcast_uuid",@"cc_live_user_id",@"cc_live_playback_key"]];
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userModel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BXGUserModel *)userModel {

    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userModel"];
    if(dict){
        return [BXGUserModel yy_modelWithDictionary:dict];
    }else {
    
        return nil;
    }
}

- (void)setCurrentPayCourseId:(NSString *)currentPayCourseId {

    [[NSUserDefaults standardUserDefaults] setObject:currentPayCourseId forKey:@"currentPayCourseModel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BXGStudyPayCourseModel *)currentPayCourseModel {

    return [[NSUserDefaults standardUserDefaults] objectForKey:@"currentPayCourseModel"];
}

-(void)setLastGetVCodeDate:(NSDate *)lastGetVCodeDate {

    [[NSUserDefaults standardUserDefaults] setObject:lastGetVCodeDate forKey:@"lastGetVCodeDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (NSDate *)lastGetVCodeDate {
    
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastGetVCodeDate"];
    
    return date;
}

- (void)setLastUserID:(NSString *)lastUserID {
    
    [[NSUserDefaults standardUserDefaults] setObject:lastUserID forKey:@"lastUserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)lastUserID {

    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUserID"];
    return userID;
}

- (NSString *)courseName {

    NSString *courseName = [[NSUserDefaults standardUserDefaults] objectForKey:@"courseName"];
    return courseName;
}

- (void)setCourseName:(NSString *)courseName {

    [[NSUserDefaults standardUserDefaults] setObject:courseName forKey:@"courseName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)logoutOperation{

    self.isLogin = false;
    self.userModel = nil;
    self.courseName = nil;
    self.currentPayCourseId = nil;
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearLastVideoModel{

    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"LastPlayedPoint"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#define K_KEY_IS_ALLOW_CELLULAR_WATCH @"isAllowCellularWatch"
#define K_KEY_IS_ALLOW_CELLULAR_DOWNLOAD @"isAllowCellularDownload"
#define K_KEY_IS_ALLOW_PUSH_NOTIFICATION @"isAllowPushNotification"

#pragma mark - "我的" 设置

/// 允许使用3G/4G网络观看视频

- (BOOL)isAllowCellularWatch {

    return [self.userDefaults boolForKey:K_KEY_IS_ALLOW_CELLULAR_WATCH];
}

- (void)setIsAllowCellularWatch:(BOOL)isAllowCellularWatch {

    
    [self.userDefaults setBool:isAllowCellularWatch forKey:K_KEY_IS_ALLOW_CELLULAR_WATCH];
    [self.userDefaults synchronize];
}

/// 允许使用3G/4G网络下载视频


- (BOOL)isAllowCellularDownload {
    
    return [self.userDefaults boolForKey:K_KEY_IS_ALLOW_CELLULAR_DOWNLOAD];
}

- (void)setIsAllowCellularDownload:(BOOL)isAllowCellularDownload {

    [self.userDefaults setBool:isAllowCellularDownload forKey:K_KEY_IS_ALLOW_CELLULAR_DOWNLOAD];
    [self.userDefaults synchronize];
}
/// 允许推送消息

- (BOOL)isAllowPushNotification {

    return [self.userDefaults boolForKey:K_KEY_IS_ALLOW_PUSH_NOTIFICATION];
}

- (void)setIsAllowPushNotification:(BOOL)isAllowPushNotification {

    [self.userDefaults setBool:isAllowPushNotification forKey:K_KEY_IS_ALLOW_PUSH_NOTIFICATION];
    [self.userDefaults synchronize];
}

#define K_KEY_COMMUNITY_POST_BTN_CENTER_POINT_X @"communityPostBtnCenterPointX"
#define K_KEY_COMMUNITY_POST_BTN_CENTER_POINT_Y @"communityPostBtnCenterPointY"

- (void)setCommunityPostBtnCenterPoint:(NSValue *)communityPostBtnCenterPoint {
    
    NSNumber *pointX = nil;
    NSNumber *pointY = nil;
    
    if(communityPostBtnCenterPoint) {
    
        CGPoint point = communityPostBtnCenterPoint.CGPointValue;
        pointX =  @(point.x);
        pointY =  @(point.y);
    }
    
    [self.userDefaults setValue:pointX forKey:K_KEY_COMMUNITY_POST_BTN_CENTER_POINT_X];
    [self.userDefaults setValue:pointY forKey:K_KEY_COMMUNITY_POST_BTN_CENTER_POINT_Y];
    [self.userDefaults synchronize];
}

- (NSValue *)communityPostBtnCenterPoint {

    NSNumber *pointX = [self.userDefaults valueForKey:K_KEY_COMMUNITY_POST_BTN_CENTER_POINT_X];
    NSNumber *pointY = [self.userDefaults valueForKey:K_KEY_COMMUNITY_POST_BTN_CENTER_POINT_Y];
    
    if(pointX && pointY) {
    
        
        CGPoint point = CGPointMake(pointX.floatValue, pointY.floatValue);
        NSValue *value = [NSValue valueWithCGPoint:point];
        return value;
    }else {
    
        return nil;
    }
}
#define kLastLoginSocialPlatForm @"kLastLoginSocialPlatForm"


#define K_MAX_HISTORY_SEARCH_RECORD 10 //
/**
 保存搜索记录

 @param arrHistorySearchRecord 按最近优先已排序数组
 */
#define K_KEY_HISTORY_SEARCH_RECORD @"historySearchRecord"
- (void)setArrHistorySearchRecord:(NSArray<NSString *> *)arrHistorySearchRecord {
    _arrHistorySearchRecord = [NSMutableArray arrayWithArray:arrHistorySearchRecord];
    if(_arrHistorySearchRecord.count > K_MAX_HISTORY_SEARCH_RECORD) {
        [_arrHistorySearchRecord removeObjectsInRange:NSMakeRange(K_MAX_HISTORY_SEARCH_RECORD, _arrHistorySearchRecord.count-K_MAX_HISTORY_SEARCH_RECORD)];
    }
    [self.userDefaults setValue:_arrHistorySearchRecord forKey:K_KEY_HISTORY_SEARCH_RECORD];
    [self.userDefaults synchronize];
}

- (NSArray*)arrHistorySearchRecord {
    _arrHistorySearchRecord = [[[NSUserDefaults standardUserDefaults]objectForKey:K_KEY_HISTORY_SEARCH_RECORD] mutableCopy];
    if(!_arrHistorySearchRecord) {
        _arrHistorySearchRecord = [NSMutableArray new];
    }
    return _arrHistorySearchRecord;
}

- (BXGSocialPlatformType)lastLoginSocialPlatform {
    NSNumber *value = [self.userDefaults valueForKey:kLastLoginSocialPlatForm];
    return value.integerValue;
}

- (void)setLastLoginSocialPlatform:(BXGSocialPlatformType)lastLoginSocialPlatform {
    [self.userDefaults setValue:@(lastLoginSocialPlatform) forKey:kLastLoginSocialPlatForm];
    [self.userDefaults synchronize];
}

@end
