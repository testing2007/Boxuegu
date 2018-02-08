//
//  BXGPostingViewModel.m
//  Boxuegu
//
//  Created by RenyingWu on 2017/8/31.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPostingViewModel.h"
#import "BXGUserCenter.h"
#import "BXGCommunityUserModel.h"

@interface BXGPostingViewModel()
@property (nonatomic, assign) NSInteger attentionCurrentPage;
@property (nonatomic, assign) NSInteger attentionTotalPage;
@property (nonatomic, strong) NSMutableArray *attentionArray;
@end

@implementation BXGPostingViewModel

- (NSMutableArray *)selectedCommunityUserModelArray {

    if(!_selectedCommunityUserModelArray){
     
        _selectedCommunityUserModelArray = [NSMutableArray new];
    }
    return _selectedCommunityUserModelArray;
}

- (NSMutableArray *)attentionArray {

    if(!_attentionArray){
    
        _attentionArray = [NSMutableArray new];
    }
    return _attentionArray;
}

- (instancetype)init {

    self = [super init];
    if(self) {
    
        self.attentionCurrentPage = 0;
    }
    return self;
}

- (void)loadPostTopicListWithFinished:(void(^)(NSArray<BXGPostTopicModel *>* topicModelArray))finishedBlock {

    if(!finishedBlock) {
    
        return;
    }
    NSString *sign = [BXGUserCenter share].userModel.sign;
    [self.networkTool requestTopicListWithFinished:^(id  _Nullable responseObject) {
        
        if(responseObject) {
            
            NSMutableArray *modelArray;
            id status = responseObject[@"status"];
            if([status isKindOfClass:[NSNumber class]] && ([status integerValue] / 200) == 1) {
                
                id result = responseObject[@"result"];
                if([result isKindOfClass:[NSArray class]]) {
                    
                    modelArray = [NSMutableArray new];
                    for(NSInteger i = 0; i < [result count]; i++) {
                        
                        BXGPostTopicModel *model = [BXGPostTopicModel yy_modelWithDictionary:result[i]];
                        if(model) {
                            
                            [modelArray addObject:model];
                        }
                    }
                    
                }
                
            }
            
            finishedBlock(modelArray);
        }else {
            
            finishedBlock(nil);
        }
        
    } andSign:sign Failed:^(NSError * _Nonnull error) {
        
        finishedBlock(nil);
    }];
}


- (void)loadMyFanListWithUUID:(NSNumber *)uuid andisUpdate:(BOOL)isRefresh andFinished:(void(^)(NSArray *modelArray))finishedBlock {

    NSString *sign = [BXGUserCenter share].userModel.sign;
    uuid = [BXGUserCenter share].userModel.itcast_uuid;
//    [self.networkTool requestMyFanListWithUUID:uuid andPageNo:@"0" andPageSize:@"0" andSign:sign andFinished:^(id  _Nullable responseObject) {
//    
//    } Failed:^(NSError * _Nonnull error) {
//        
//    }];
    
}

- (void)loadAttentionPersonListWithUUID:(NSNumber *)uuid andIsMore:(BOOL)isMore andFinished:(void(^)(NSArray *modelArray,BOOL isLast))finishedBlock {
    
    __weak typeof (self) weakSelf = self;
    NSString *sign = [BXGUserCenter share].userModel.sign;
    uuid = [BXGUserCenter share].userModel.itcast_uuid;
    
    
    
    if(!isMore && self.attentionArray.count > 0) {
    
        finishedBlock(self.attentionArray, weakSelf.attentionCurrentPage >= weakSelf.attentionTotalPage);
        return;
        
//        if(weakSelf.attentionCurrentPage >= weakSelf.attentionTotalPage) {
//            
//            finishedBlock(self.attentionArray,true);
//            return;
//        }
    }
    
    NSNumber *page = @(self.attentionCurrentPage + 1);
    
//    self.networkTool requattenpe
    
    [self.networkTool requestAttentionPersonListWithUUID:uuid andPageNo:page andPageSize:@(20) andSign:sign andFinished:^(id  _Nullable responseObject) {
        
        if(responseObject) {
         
            NSMutableArray *modelArray = [NSMutableArray new];
            id status = responseObject[@"status"];
            if([status isKindOfClass:[NSNumber class]] && [status integerValue] == 200) {
            
                // 成功
                
                id result = responseObject[@"result"];
                if([result isKindOfClass:[NSDictionary class]]){
                
                    id totalPageCount = result[@"totalPageCount"];
                    id currentPage = result[@"totalPageCount"];
                    
                    if([totalPageCount isKindOfClass:[NSNumber class]]) {
                    
                        weakSelf.attentionTotalPage = [totalPageCount integerValue];
                    }
                    
                    if([currentPage isKindOfClass:[NSNumber class]]) {
                        
                        weakSelf.attentionCurrentPage = [currentPage integerValue];
                    }
                    
                    id items = result[@"items"];
                    if([items isKindOfClass:[NSArray class]] && [items count] > 0) {
                    
                        for(NSInteger i = 0; i < [items count]; i++) {
                        
                            BXGCommunityUserModel *model = [BXGCommunityUserModel yy_modelWithDictionary:items[i]];
                            if(model) {
                            
                                [modelArray addObject:model];
                            }
                        }
                        [weakSelf.attentionArray addObjectsFromArray:modelArray];

                    }
                    finishedBlock(weakSelf.attentionArray, weakSelf.attentionCurrentPage >= weakSelf.attentionTotalPage);
                    return;
                }
            }
        }
        finishedBlock(nil, false);

    } Failed:^(NSError * _Nonnull error) {
        
        finishedBlock(nil, false);
    }];
    
}
@end
