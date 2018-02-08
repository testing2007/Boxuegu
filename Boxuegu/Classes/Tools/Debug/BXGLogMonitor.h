//
//  BXGLogMonitor.h
//  MultimediaEditor
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXGLogMonitor : NSObject

+(instancetype)share;

@property (nonatomic, assign, readonly) BOOL bEnableLog;
///最大请求记录数: 如果maxLimits=0 表示没有限制, 否则按设定值, 默认值10;
@property (nonatomic, assign) NSInteger maxLimits;

-(void)setEnableLog:(BOOL)enableLog;

-(void)addLogInfo:(NSString*)logInfo;
-(NSString*)logInfo;
-(void)clear;


@end
