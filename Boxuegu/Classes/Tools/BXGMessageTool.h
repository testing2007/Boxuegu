//
//  BXGMessageTool.h
//  Boxuegu
//
//  Created by Renying Wu on 2017/6/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXGMessageModel.h"

@interface BXGMessageTool : NSObject

/**
 BXGMessageTool

 @return 单例对象
 */
+ (instancetype)share;

/**
 未读消息总数 (修改这个值会全局发通知)
 */
@property (nonatomic, assign) NSInteger countOfNewMessage;

/**
 获取 未读消息总数
 */
- (void)loadAllNewMessageCountWithFinishedBlock:(void(^)(BOOL succeesd, NSString *message, NSInteger count))finishedBlock;

/**
 获取 消息种类列表
 */
- (void)loadMessageTypeListWithFinishedBlock:(void(^)(BOOL succeesd, NSString *message, NSArray *models))finishedBlock;

/**
 获取 消息详情列表

 @param type 消息种类
 @param isReflesh 是否要刷新
 */
- (void)loadMessageDetailListWithType:(BXGMessageType)type isReflesh:(BOOL)isReflesh FinishedBlock:(void(^)(BOOL succeesd, BOOL isNoMore, NSArray *models))finishedBlock;

/**
 更新消息状态 (已读状态)

 @param type 消息种类
 */
- (void)updateMessageStatusByType:(BXGMessageType)type Finished:(void(^)(BOOL succeesd, NSString *message, NSArray *models))finishedBlock;
@end
