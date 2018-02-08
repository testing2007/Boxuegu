//
//  BXGMessageTool.m
//  Boxuegu
//
//  Created by Renying Wu on 2017/6/16.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGMessageTool.h"
#import "BXGMessageModel.h"
#import "BXGUserModel.h"
#import "BXGUserDefaults.h"
#import "BXGNotificationTool.h"
#import "BXGMessageNotiModel.h"

@interface BXGMessageTool()

// 通用属性
@property (nonatomic, readonly) BXGNetWorkTool *networkTool;
@property (nonatomic, readonly) BXGUserModel *userModel;

// 分页缓存
@property (nonatomic, assign) NSInteger coursePageNumber;
@property (nonatomic, assign) NSInteger eventPageNumber;
@property (nonatomic, assign) NSInteger feedbackPageNumber;
@property (nonatomic, strong) NSMutableArray<BXGMessageModel *> *courseMessageArray;
@property (nonatomic, strong) NSMutableArray<BXGMessageModel *> *eventMessageArray;
@property (nonatomic, strong) NSMutableArray<BXGMessageModel *> *feedbackMessageArray;

// 定时器
@property (nonatomic, strong) NSTimer *timer;

@end


@implementation BXGMessageTool

#pragma mark - Init

static BXGMessageTool *instance;
+ (instancetype)share {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[BXGMessageTool alloc]init];
    });
    return instance;
}

- (instancetype)init {
    
    
    self = [super init];
    if(self) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:60 * 5 target:self selector:@selector(intervalTimerOperation:) userInfo:nil repeats:true];
    }
    return self;
}

#pragma mark - Getter Setter

- (NSMutableArray *)courseMessageArray {

    if(!_courseMessageArray){
    
        _courseMessageArray = [NSMutableArray new];
    }
    return _courseMessageArray;
}

- (NSMutableArray *)eventMessageArray {
    
    if(!_eventMessageArray){
        
        _eventMessageArray = [NSMutableArray new];
    }
    return _eventMessageArray;
}

- (NSMutableArray<BXGMessageModel *> *)feedbackMessageArray {
    if(!_feedbackMessageArray){
        
        _feedbackMessageArray = [NSMutableArray new];
    }
    return _feedbackMessageArray;
}

- (BXGNetWorkTool *)networkTool {

    return [BXGNetWorkTool sharedTool];
}

- (BXGUserModel *)userModel {

    return [BXGUserDefaults share].userModel;
}

- (void)setCountOfNewMessage:(NSInteger)countOfNewMessage {
    _countOfNewMessage = countOfNewMessage;
    [BXGNotificationTool postNotificationForNewMessageCount:countOfNewMessage];
}

#pragma mark - Timer

- (void)intervalTimerOperation:(NSTimer *)timer {

    [self updateData];
}

- (void)updateData {
    
    [self loadAllNewMessageCountWithFinishedBlock:^(BOOL succeesd, NSString *message, NSInteger count) {
    }];
}

#pragma mark - Function

- (void)loadAllNewMessageCountWithFinishedBlock:(void(^)(BOOL succeesd, NSString *message, NSInteger count))finishedBlock; {
    Weak(weakSelf);
    [self.networkTool appRequestMyMessageCountWithFinished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        
        if(status == 200){
            if([result isKindOfClass:[NSDictionary class]]) {
                BXGMessageNotiModel *model = [BXGMessageNotiModel yy_modelWithDictionary:result];
                if(model){
                    weakSelf.countOfNewMessage = model.unReadCount.integerValue;
                }else {
                    weakSelf.countOfNewMessage = 0;
                }
            }
        }else{
            weakSelf.countOfNewMessage = 0;
        }
    }];
}

- (void)loadMessageTypeListWithFinishedBlock:(void(^)(BOOL succeesd, NSString *message, NSArray *models))finishedBlock; {

    [self.networkTool appRequestGetLastMessageByType:nil Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        if(status == 200) {
            NSMutableArray *models = [NSMutableArray new];
            if([result isKindOfClass:[NSArray class]]) {
                for (NSInteger i = 0; i < [result count]; i++) {
                    BXGMessageModel *model = [BXGMessageModel yy_modelWithDictionary:result[i]];
                    if(model) {
                        [models addObject:model];
                    }
                }
            }
            // 成功回调
            finishedBlock(true,@"成功",models);
        }else {
            // 失败回调
            finishedBlock(false,@"失败",nil);
        }
    }];
}

- (void)loadMessageDetailListWithType:(BXGMessageType)type isReflesh:(BOOL)isReflesh FinishedBlock:(void(^)(BOOL succeesd, BOOL isNoMore, NSArray *models))finishedBlock; {

    NSInteger page = 0;
    NSInteger pageSize = 10;
    
    if(isReflesh) {
        // 清空数据
        self.feedbackMessageArray = nil;
        self.courseMessageArray = nil;
        self.eventMessageArray = nil;
        
        self.coursePageNumber = 0;
        self.eventPageNumber = 0;
        self.feedbackPageNumber = 0;
    }
    
    switch (type) {
        case BXGMessageTypeCourseMessage:{
            self.coursePageNumber += 1;
            page = self.coursePageNumber;
        }break;
        case BXGMessageTypeEventMessage:{
            self.eventPageNumber += 1;
            page = self.eventPageNumber;
        }break;
        case BXGMessageTypeFeedbackMessage:{
            self.feedbackPageNumber += 1;
            page = self.feedbackPageNumber;
        }break;
        default:
            break;
    }
    
    [self.networkTool appRequestMessageListByType:@(type).description PageNumber:@(page).description PageSize:@(pageSize).description Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        Weak(weakSelf);
        BOOL isNoMore = false;
        if(status == 200){
            NSMutableArray *modelArray = [NSMutableArray new];
            if([result isKindOfClass:[NSArray class]]) {
                for (NSInteger i = 0; i < [result count]; i++) {
                    BXGMessageModel *model = [BXGMessageModel yy_modelWithDictionary:result[i]];
                    if(model){
                        [modelArray addObject:model];
                    }
                }
            }
            // 判断是否没有更多
            // pageSize
            if(modelArray.count <= 0 || modelArray.count < pageSize) {
                isNoMore = true;
            }
            
            // 成功回调
            switch (type) {
                case BXGMessageTypeCourseMessage:{
                    [weakSelf.courseMessageArray addObjectsFromArray:modelArray];
                    finishedBlock(true,isNoMore,self.courseMessageArray);
                }break;
                case BXGMessageTypeEventMessage:{
                    [weakSelf.eventMessageArray addObjectsFromArray:modelArray];
                    finishedBlock(true,isNoMore,self.eventMessageArray);
                }break;
                case BXGMessageTypeFeedbackMessage:{
                    [weakSelf.feedbackMessageArray addObjectsFromArray:modelArray];
                    finishedBlock(true,isNoMore,self.feedbackMessageArray);
                }break;
                default:
                    break;
            }

        }else {
            
            // 清空数据
            weakSelf.feedbackMessageArray = nil;
            weakSelf.courseMessageArray = nil;
            weakSelf.eventMessageArray = nil;
            
            weakSelf.coursePageNumber = 0;
            weakSelf.eventPageNumber = 0;
            weakSelf.feedbackPageNumber = 0;
            
            // 失败回调
            finishedBlock(false,false,nil);
        }
    }];
}

- (void)updateMessageStatusByType:(BXGMessageType)type Finished:(void(^)(BOOL succeesd, NSString *message, NSArray *models))finishedBlock; {
    Weak(weakSelf);
    [self.networkTool appRequestUpdateMessageStatusByType:@(type).description Finished:^(NSInteger status, NSString * _Nullable message, id  _Nullable result) {
        // TODO: 参数传递
        if(status == 200) {
            // 成功回调
            finishedBlock(true,@"成功",nil);
        }else{
            // 失败回调
            finishedBlock(false,@"失败",nil);
        }
        weakSelf.countOfNewMessage = 0;
    }];
}

@end
