//
//  BXGNetWorkTool+Consult.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGNetWorkTool+Consult.h"
#import "BXGNetwork.h"
#import "BXGNetworkParser.h"

#ifdef DEBUG
#define kConsultChannelId @"60";
#else
#define kConsultChannelId @"9";
#endif

@implementation BXGNetWorkTool (Consult)

#pragma mark - Base

- (void)consultBaseRequestType:(RequestType)type andURLString:(NSString * _Nullable)urlString andParameter:(id _Nullable)para andFinished:(BXGNetworkCallbackBlockType _Nullable) callback; {
    // common para
    [self requestType:type andBaseURLString:kConsultBaseUrlString andUrlString:urlString andParameter:para andFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser consultNetworkParser:responseObject andFinished:callback];
    } andFailed:^(NSError * _Nonnull error) {
        [BXGNetworkParser consultNetworkParser:error andFinished:callback];
    }];
}

#pragma mark - Request

/// 收集意向录入信息 /consult/entering/collectRecord
- (void)consultRequestCollectRecordWithUserId:(NSString *_Nullable)userId
                                      andName:(NSString *_Nullable)name
                                 andSubjectId:(NSString *_Nullable)subjectId
                                andCourseName:(NSString *_Nullable)courseName
                                    andWechat:(NSString *_Nullable)wechat
                                        andQQ:(NSString *_Nullable)qq
                                    andMobile:(NSString *_Nullable)mobile
                                     andFinished:(BXGNetworkCallbackBlockType _Nullable) callback;{
    // para
    NSMutableDictionary *para = [NSMutableDictionary new];
    para[@"id"] = userId;
    para[@"customerName"] = name;
    para[@"remark"] = courseName;
    para[@"customerWechat"] = wechat;
    para[@"customerQQ"] = qq;
    para[@"customerMobile"] = mobile;
    para[@"subjectId"] = subjectId; // 学科方向 (必选)
    para[@"channelId"] = kConsultChannelId;

    // url
    NSString *url = @"/consult/entering/collectRecord";
    
    // request
    [self consultBaseRequestType:POST andURLString:url andParameter:para andFinished:callback];
}

/// 查询咨询电话 /consult/common/queryConsultTel
- (void)consultRequestQueryConsultTelWithFinished:(BXGNetworkCallbackBlockType _Nullable) callback; {
    // para
    NSMutableDictionary *para = nil;
    
    // url
    NSString *url = @"/consult/common/queryConsultTel";
    
    // request
    [self consultBaseRequestType:POST andURLString:url andParameter:para andFinished:callback];
}

@end
