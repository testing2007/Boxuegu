//
//  BXGNetworkParser.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGNetworkParser.h"

@implementation BXGNetworkParser
+ (void)communityNetworkParser:(id)obj andFinished:(void(^)(BXGNetworkResultStatus status, NSString *message, id result))finishedBlock; {

    if([obj isKindOfClass:NSError.class]) {
        finishedBlock(500,kBXGToastNoNetworkError,nil);
        return;
    }
    
    if(!finishedBlock) {
    
        return;
    }
    
    if(!obj) {
    
        finishedBlock(0,kBXGToastLodingError,nil);
        return;
    }

    BXGCommunityParserItem *item = [BXGCommunityParserItem yy_modelWithDictionary:obj];
    
    if(!item) {
    
        finishedBlock(0,kBXGToastLodingError,nil);
        return;
    }
    
    NSInteger status = 0;
    if(item.status) {
    
        status = [item.status integerValue];
    }
    
    if(status == 1001) {
        finishedBlock(status,kBXGToastExpireError,item.result);
        [self userExpired];
    }else {
        finishedBlock(status,item.message,item.result);
    }
}

+ (void)mainNetworkParser:(id)obj andFinished:(void(^)(BXGNetworkResultStatus status, NSString *message, id result))finishedBlock; {
    
    if([obj isKindOfClass:NSError.class]) {
        finishedBlock(500,kBXGToastNoNetworkError,nil);
        return;
    }
    
    if(!finishedBlock) {
        return;
    }
    
    if(!obj) {
        
        finishedBlock(0,kBXGToastLodingError,nil);
        return;
    }
    
    BXGMainParserItem *item = [BXGMainParserItem yy_modelWithDictionary:obj];
    if(!item) {
        
        finishedBlock(0,kBXGToastLodingError,nil);
        return;
    }
    if([item.errorMessage isEqualToString:@"1001"]) {
        finishedBlock(BXGNetworkResultStatusExpired,kBXGToastExpireError,nil);
        [self userExpired];
    }else if (item.success && [item.success boolValue]){
        finishedBlock(BXGNetworkResultStatusSucceed,item.errorMessage,item.resultObject);
    }else {
        finishedBlock(BXGNetworkResultStatusFailed,item.errorMessage,item.resultObject);
    }
}

+ (void)consultNetworkParser:(id)obj andFinished:(void(^)(BXGNetworkResultStatus status, NSString *errorMsg, id result))finishedBlock; {
    [self mainNetworkParser:obj andFinished:finishedBlock];
}

+ (void)userNetworkParser:(id)obj andFinished:(void(^)(BXGNetworkResultStatus status, NSString *message, id result))finishedBlock; {
    
    if([obj isKindOfClass:NSError.class]) {
        finishedBlock(500,kBXGToastNoNetworkError,nil);
        return;
    }
    
    if(!finishedBlock) {
        return;
    }
    
    if(!obj) {
        
        finishedBlock(0,kBXGToastLodingError,nil);
        return;
    }
    
    BXGMainParserItem *item = [BXGMainParserItem yy_modelWithDictionary:obj];
    if(!item) {
        
        finishedBlock(0,kBXGToastLodingError,nil);
        return;
    }
    if([item.errorMessage isEqualToString:@"1002"]) {
        finishedBlock(1002,item.errorMessage,nil);
    }else if (item.success && [item.success boolValue]){
        finishedBlock(BXGNetworkResultStatusSucceed,item.errorMessage,item.resultObject);
    }else {
        finishedBlock(BXGNetworkResultStatusFailed,item.errorMessage,item.resultObject);
    }
}

+ (void)testNetworkParser:(id)obj andFinished:(void(^)(BXGNetworkResultStatus status, NSString *message, id result))finishedBlock; {
    
    if([obj isKindOfClass:NSError.class]) {
        finishedBlock(500,kBXGToastNoNetworkError,nil);
        return;
    }
    if(!finishedBlock) {
        
        return;
    }
    
    if(!obj) {
        
        finishedBlock(0,kBXGToastLodingError,nil);
        return;
    }
    
    BXGMainParserItem *item = [BXGMainParserItem yy_modelWithDictionary:obj];
    if(!item) {
        
        finishedBlock(0,kBXGToastLodingError,nil);
        return;
    }
    if([item.errorMessage isEqualToString:@"1001"]) {
        finishedBlock(BXGNetworkResultStatusExpired,kBXGToastExpireError,nil);
        [self userExpired];
    }else if (item.success && [item.success boolValue]){
        finishedBlock(BXGNetworkResultStatusSucceed,item.errorMessage,item.resultObject);
    }else {
        finishedBlock(BXGNetworkResultStatusFailed,item.errorMessage,item.resultObject);
    }
}

+ (void)userExpired; {
    [BXGNotificationTool postNotificationForUserExpired];
}

@end
