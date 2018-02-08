//
//  BXGMessageModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/6/19.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    BXGMessageTypeCourseMessage = 1,
    BXGMessageTypeEventMessage = 0,
    BXGMessageTypeFeedbackMessage = 5,
} BXGMessageType;

/**
 我的消息 - 消息模型
 */
@interface BXGMessageModel : BXGBaseModel

@property (nonatomic, strong) NSString *idx;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *type; // 1 课程消息 0.系统消息
@property (nonatomic, strong) NSString *plan_id;
@property (nonatomic, strong) NSNumber *readStatus; // 1.已读 0.未读
@property (nonatomic, strong) NSString *timeStamp; // 1.已读 0.未读
@property (nonatomic, strong) NSString *unReadCount;

@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *liveId;
@end
