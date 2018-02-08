//
//  BXGAttentionViewModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGAttentionViewModel.h"
#import "BXGNetworkParser.h"

@interface BXGAttentionViewModel()
@property (nonatomic, assign) NSInteger currentPageNo;
@property (nonatomic, assign) NSInteger totalPageCount;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *postModelArray;
@end
@implementation BXGAttentionViewModel

- (NSMutableArray *)postModelArray {

    if(!_postModelArray){
    
        _postModelArray = [NSMutableArray new];
    }
    return _postModelArray;
}

- (void)loadPostListWithIsReflesh:(BOOL)isReflesh andFinished:(void(^)(NSArray<BXGCommunityPostModel *> *modelArray, BOOL isNoMore))finishedBlock; {
    
    __weak typeof (self) weakSelf = self;
    
    if(!finishedBlock){
        
        finishedBlock(nil, false);
        self.currentPageNo = 0;
        self.postModelArray = nil;
        return;
    }
    
    BXGUserModel *userModel = [BXGUserCenter share].userModel;
    if(!userModel) {
        
        finishedBlock(nil, false);
        self.currentPageNo = 0;
        self.postModelArray = nil;
        return;
    }
    NSString *sign = userModel.sign;
    NSNumber *uuid = userModel.itcast_uuid;
    
    if(isReflesh) {
    
        self.currentPageNo = 0;
        self.postModelArray = nil;
    }
    
    [self.networkTool requestAttentionListWithUUID:uuid andPageNo:@(self.currentPageNo + 1) andPageSize:@20 andSign:sign andFinished:^(id  _Nullable responseObject) {
        
        [BXGNetworkParser communityNetworkParser:responseObject andFinished:^(NSInteger status, NSString *message, id result) {
            
            BOOL isNoMoreData = false;
            if(status == 200 && result) {
                
                NSMutableArray *array = [NSMutableArray new];
//                id totalPageCount = result[@"totalPageCount"];
//                if([totalPageCount isKindOfClass:[NSNumber class]]) {
//
//                    weakSelf.totalPageCount = [totalPageCount integerValue];
//
//                }
                weakSelf.currentPageNo += 1;
                id items = result[@"items"];
                if([items isKindOfClass:[NSArray class]]) {
                    
                    for (NSInteger i = 0; i < [items count]; i++) {
                        
                        BXGCommunityPostModel *model = [BXGCommunityPostModel yy_modelWithDictionary:items[i]];

                        if(model) {
                            
                            [array addObject:model];
                        }
                    }
                    if(array.count <= 0) {
                    
                        isNoMoreData = true;
                    }else {
                    
                        isNoMoreData = false;
                        [weakSelf.postModelArray addObjectsFromArray:array];
                    }
                }
                
                finishedBlock(weakSelf.postModelArray, isNoMoreData);
                return;
                
            }else {
                
                finishedBlock(nil, false);
                self.currentPageNo = 0;
                self.postModelArray = nil;
            }
        }];
        
    } Failed:^(NSError * _Nonnull error) {
        
        finishedBlock(nil, false);
        self.currentPageNo = 0;
        self.postModelArray = nil;
    }];
}




- (void)thumbPostWithPostId:(NSNumber *)postId
                 andOperate:(BOOL)isThumb
              andPostUserId:(NSNumber *)postUserId
                andFinished:(void(^ _Nullable)(BOOL succeed))finishedBlock {
    
    NSNumber *uuid = [BXGUserCenter share].userModel.itcast_uuid;
    NSString *sign = [BXGUserCenter share].userModel.sign;
    
    [self.networkTool requestCommunityUpdatePraiseStatusWithPosetId:postId
                                                            andUUID:uuid
                                                         andOperate:@(isThumb)
                                                   andPraisedUserId:postUserId
                                                            andSign:sign
                                                        andFinished:^(id  _Nullable responseObject) {
        
        [BXGNetworkParser communityNetworkParser:responseObject andFinished:^(NSInteger status, NSString *message, id result) {
            
            if(status == 200){
                
                if(finishedBlock) {
                    
                    finishedBlock(true);
                    
                }
            }else {
                
                if(finishedBlock) {
                    
                    finishedBlock(false);
                }
            }
        }];
        
    } Failed:^(NSError * _Nonnull error) {
        
        if(finishedBlock) {
            
            finishedBlock(false);
        }
    }];
}
- (void)loadHomePostListWithIsReflesh:(BOOL)isReflesh andFinished:(void(^)(NSArray<BXGCommunityPostModel *> *modelArray, BOOL isReflesh))finishedBlock; {

    Weak(weakSelf);
    
    if(!finishedBlock){
        
        finishedBlock(nil, false);
        self.currentPageNo = 0;
        self.postModelArray = nil;
        return;
    }
    
    BXGUserModel *userModel = [BXGUserCenter share].userModel;
    if(!userModel) {
        
        finishedBlock(nil, false);
        self.currentPageNo = 0;
        self.postModelArray = nil;
        return;
    }
    NSString *sign = userModel.sign;
    NSNumber *uuid = userModel.itcast_uuid;
    
    if(isReflesh) {
        
        self.currentPageNo = 0;
        self.postModelArray = nil;
    }

    [self.networkTool requestUserHomePostListWithSign:sign andHomeUserId:uuid andUserId:uuid andPageSize:@10 andPageNo:@(self.currentPageNo + 1) andFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser communityNetworkParser:responseObject andFinished:^(NSInteger status, NSString *message, id result) {
            
            BOOL isNoMoreData = false;
            if(status == 200 && result) {
                
                NSMutableArray *array = [NSMutableArray new];
                weakSelf.currentPageNo += 1;
                id items = result[@"items"];
                if([items isKindOfClass:[NSArray class]]) {
                    
                    for (NSInteger i = 0; i < [items count]; i++) {
                        
                        BXGCommunityPostModel *model = [BXGCommunityPostModel yy_modelWithDictionary:items[i]];
                        if(model) {
                            
                            [array addObject:model];
                        }
                    }
                    if(array.count <= 0){
                    
                        isNoMoreData = true;
                    }else {
                    
                        isNoMoreData = false;
                        [weakSelf.postModelArray addObjectsFromArray:array];
                    }
                }
                
                finishedBlock(weakSelf.postModelArray, isNoMoreData);
                return;
                
            }else {
                
                finishedBlock(nil, true);
                self.currentPageNo = 0;
                self.postModelArray = nil;
            }
        }];
    } Failed:^(NSError * _Nonnull error) {
        finishedBlock(nil, true);
        self.currentPageNo = 0;
        self.postModelArray = nil;
    }];
}
@end
