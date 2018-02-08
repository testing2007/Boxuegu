//
//  BXGNetWorkTool+Consult.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/10/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGNetWorkTool.h"

@interface BXGNetWorkTool (Consult)

/// 收集意向录入信息 /consult/entering/collectRecord
- (void)consultRequestCollectRecordWithUserId:(NSString *_Nullable)userId
                                      andName:(NSString *_Nullable)name
                                 andSubjectId:(NSString *_Nullable)subjectId
                                andCourseName:(NSString *_Nullable)courseName
                                    andWechat:(NSString *_Nullable)wechat
                                        andQQ:(NSString *_Nullable)qq
                                    andMobile:(NSString *_Nullable)mobile
                                  andFinished:(BXGNetworkCallbackBlockType _Nullable) callback;

/**
 查询咨询电话 /consult/common/queryConsultTel
 */
- (void)consultRequestQueryConsultTelWithFinished:(BXGNetworkCallbackBlockType _Nullable) callback;
@end
