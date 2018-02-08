//
//  BXGLogMonitor.m
//  MultimediaEditor
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 itheima. All rights reserved.
//

#import "BXGLogMonitor.h"

#pragma mark 只负责调试打印在控制台
// LOG
#ifdef DEBUG
#define LOG_ON // Network Log 开关
#else
//#define LOG_ON
#endif

#pragma mark 运行时控制日志是否显示
#define kEnableLog  @"kEnableLog"

@interface BXGLogMonitor()
@property (nonatomic, assign, readwrite) BOOL bEnableLog;
@property (nonatomic, strong) NSMutableArray<NSString*> *arrLog;

@property (nonatomic, strong) dispatch_queue_t logSerialQueue;
@end

@implementation BXGLogMonitor

+(instancetype)share {
    static dispatch_once_t onceToken;
    static BXGLogMonitor *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [BXGLogMonitor new];
        [instance initLogConfig];
    });
    return instance;
}

-(NSMutableArray*)arrLog {
    if(!_arrLog) {
        _arrLog = [NSMutableArray new];
    }
    return _arrLog;
}

-(void)initLogConfig {
    NSNumber *numEnableLog = [[NSUserDefaults standardUserDefaults] objectForKey:kEnableLog];
    _bEnableLog = numEnableLog ? numEnableLog.boolValue : NO;

    _logSerialQueue = dispatch_queue_create("log_serial_queue", DISPATCH_QUEUE_SERIAL);
    
    _maxLimits = 10;//默认值是10;
}

-(void)setEnableLog:(BOOL)enableLog {
    self.bEnableLog = enableLog;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:enableLog] forKey:kEnableLog];
}

-(void)addLogInfo:(NSString*)logInfo {
    if([NSThread isMainThread]) {
        #ifdef LOG_ON
            printf("%s\n", [logInfo UTF8String]);
        #endif
    } else {
        #ifdef LOG_ON
            dispatch_async(dispatch_get_main_queue(), ^{
                printf("%s\n", [logInfo UTF8String]);
            });
        #endif
    }
    
    dispatch_async(_logSerialQueue, ^{
        if(!self.bEnableLog) {
            return ;
        }
        
        if(logInfo) {
            [self.arrLog addObject:logInfo];
        }
        
        if(_maxLimits>0) {
            if(self.arrLog.count>_maxLimits) {
                [self.arrLog removeObjectAtIndex:0];
            }
        }
    });
}

-(NSString*)logInfo {
    NSAssert([NSThread isMainThread], @"the function only can be called by main thread");
    
    NSString *strContent = nil;
    for(NSString *itemLog in self.arrLog){
        if(!strContent) {
            strContent = [NSString new];
        }
        strContent = [strContent stringByAppendingString:itemLog];
    }
    
    return strContent?:@"";
}

-(void)clear {
    NSAssert([NSThread isMainThread], @"the function only can be called by main thread");
    if(_arrLog && _arrLog.count>0) {
        [_arrLog removeAllObjects];
    }
}

@end
