//
//  BXGSquareTopicViewModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGSquareTopicViewModel.h"
#import "BXGNetworkParser.h"
#import "BXGCommunityPostModel.h"

@interface BXGSquareTopicViewModel()
@property (nonatomic, strong) NSNumber *topicId;
@property (nonatomic, assign) NSInteger currentPageNo;
@property (nonatomic, assign) NSInteger totalPageCount;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *postModelArray;

@end


@implementation BXGSquareTopicViewModel

- (NSMutableArray *)postModelArray {

    if(!_postModelArray) {
    
        _postModelArray = [NSMutableArray new];
    }
    return _postModelArray;
}

- (instancetype)initWithTopicId:(NSNumber *)topicId; {

    
    self = [super init];
    if(self) {
        
        self.topicId = topicId;
        self.currentPageNo = 0;
        self.totalPageCount = 0;
    }
    return self;
}

- (void)loadPostListWithTopicId:(NSNumber *)topicId isReflesh:(BOOL)isReflesh andFinished:(void (^)(NSArray *modelArray, BOOL))finishedBlock {

    if(!finishedBlock){
        
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    
    
    if(isReflesh) {
    
        self.currentPageNo = 0;
        self.postModelArray = nil;
    }

    
    NSString *sign;
    NSNumber *uuid;
    if([BXGUserCenter share].userModel) {
    
        sign = [BXGUserCenter share].userModel.sign;
        uuid = [BXGUserCenter share].userModel.itcast_uuid;
    }

    [self.networkTool requestPostListWithTopicId:topicId andPageNo:@(self.currentPageNo + 1) andPageSize:@10  andFinished:^(id  _Nullable responseObject) {
        
        [BXGNetworkParser communityNetworkParser:responseObject andFinished:^(NSInteger status, NSString *message, id result) {
            
            if(status == 200 && result) {
                
                NSMutableArray *array = [NSMutableArray new];
                id totalPageCount = result[@"totalPageCount"];
                if([totalPageCount isKindOfClass:[NSNumber class]]) {
                    
                    weakSelf.totalPageCount = [totalPageCount integerValue];
                    weakSelf.currentPageNo += 1;
                }
                //
                id items = result[@"items"];
                if([items isKindOfClass:[NSArray class]]) {
                    
                    for (NSInteger i = 0; i < [items count]; i++) {
                        
                        BXGCommunityPostModel *model = [BXGCommunityPostModel yy_modelWithDictionary:items[i]];
                        if(model) {
                            
                            [array addObject:model];
                        }
                    }
                    [weakSelf.postModelArray addObjectsFromArray:array];
                    
                }
                
                finishedBlock(weakSelf.postModelArray, weakSelf.totalPageCount == weakSelf.currentPageNo);
                return;
                
                
                
            }else {
                
                NSLog(@"失败");
                
                self.currentPageNo = 0;
                self.postModelArray = nil;
                finishedBlock(nil,false);
            }
        }];
        
        
    } Failed:^(NSError * _Nonnull error) {
        
        self.currentPageNo = 0;
        self.postModelArray = nil;
        finishedBlock(nil,false);
    }];
}

- (void)loadPostListWithTopicId:(NSNumber *)topicId isloadMore:(BOOL)isloadMore andFinished:(void(^)(NSArray *modelArray,BOOL isNoMore))finishedBlock; {
    
    if(!finishedBlock){
    
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    
    
    
    NSString *sign;
    NSNumber *uuid;
    if([BXGUserCenter share].userModel) {
        
        sign = [BXGUserCenter share].userModel.sign;
        uuid = [BXGUserCenter share].userModel.itcast_uuid;
    }
    
    [self.networkTool requestPostListWithTopicId:topicId andPageNo:@(self.currentPageNo + 1) andPageSize:@20  andFinished:^(id  _Nullable responseObject) {
        
        [BXGNetworkParser communityNetworkParser:responseObject andFinished:^(NSInteger status, NSString *message, id result) {
            
            if(status == 200 && result) {
                
                NSMutableArray *array = [NSMutableArray new];
                id totalPageCount = result[@"totalPageCount"];
                if([totalPageCount isKindOfClass:[NSNumber class]]) {
                    
                    weakSelf.totalPageCount = [totalPageCount integerValue];
                    weakSelf.currentPageNo += 1;
                    
                    
                }
                //
                id items = result[@"items"];
                if([items isKindOfClass:[NSArray class]]) {
                    
                    for (NSInteger i = 0; i < [items count]; i++) {
                        
                        BXGCommunityPostModel *model = [BXGCommunityPostModel yy_modelWithDictionary:items[i]];
                        if(model) {
                            
                            [array addObject:model];
                        }
                    }
                    [weakSelf.postModelArray addObjectsFromArray:array];
                    
                }
                
                finishedBlock(weakSelf.postModelArray, weakSelf.totalPageCount == weakSelf.currentPageNo);
                return;
                
                
                
            }else {
                
                NSLog(@"失败");
                
                self.currentPageNo = 0;
                self.postModelArray = nil;
                finishedBlock(nil,false);
            }
        }];
        
        
    } Failed:^(NSError * _Nonnull error) {
        
        self.currentPageNo = 0;
        self.postModelArray = nil;
        finishedBlock(nil,false);
    }];
}
@end
