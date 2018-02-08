//
//  BXGPraisePersonListViewModel.m
//  Boxuegu
//
//  Created by apple on 2017/9/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGPraisePersonListViewModel.h"
#import "BXGNetworkParser.h"
#import "BXGPraisePersonDetailModel.h"

#define kPageSize 10

@implementation BXGPraisePersonListViewModel

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _currentPage = 0;
        _bHaveMoreData = YES;
    }
    return self;
}

- (void)requestPraisePersonListInfoWithRefresh:(BOOL)bRefresh
                                  andPostId:(NSNumber*)postId
                          andFinishBlock:(void(^)(BOOL succeed, NSString *errorMessage))finishedBlock
{
    __weak typeof (self) weakSelf = self;
    
    if(bRefresh)
    {
        _currentPage = 0;
        _bHaveMoreData = YES;
        _arrPraisePersoner = [NSArray new];
    }
    if(!_bHaveMoreData)
    {
        return  finishedBlock(false, @"have no more data");
    }
    _currentPage = self.arrPraisePersoner!=nil ? (self.arrPraisePersoner.count/kPageSize)+1 : 0;
    
    NSNumber *uuid = [BXGUserCenter share].userModel.itcast_uuid;
    NSString *sign = [BXGUserCenter share].userModel.sign;
    
    [[BXGNetWorkTool sharedTool] requestCommunityPraisePersonListWithPostId:postId
                                                                    andUUID:uuid
                                                                  andPageNo:[NSNumber numberWithInteger:_currentPage]
                                                                andPageSize:@kPageSize
                                                                    andSign:sign
                                                                andFinished:^(id  _Nullable responseObject)
     {
         [BXGNetworkParser communityNetworkParser:responseObject andFinished:^(NSInteger status, NSString *message, id result) {
             if(status == 200) {
                 if([result isKindOfClass:[NSDictionary class]]) {
                     
                     BXGPraisePersonDetailModel *model = [BXGPraisePersonDetailModel yy_modelWithDictionary:result];
                     NSMutableArray *array = [[NSMutableArray alloc] initWithArray:weakSelf.arrPraisePersoner];
                     if(model) {
                         [array addObjectsFromArray:model.items];
                         weakSelf.arrPraisePersoner = [NSArray arrayWithArray:array];
                         //[weakSelf.arrPraisePersoner arrayByAddingObjectsFromArray:model.items];
//                         weakSelf.arrPraisePersoner = [NSArray arrayWithArray:model.items];
                         NSInteger recordCount = (NSInteger)weakSelf.arrPraisePersoner.count;
                         if(recordCount>= 0 && recordCount<kPageSize)
                         {
                             _bHaveMoreData = NO;
                         }
                     }
                 }
                 finishedBlock(YES, nil);
                 return;
             }
             else
             {
                 finishedBlock(NO, nil);
             }
         }];
     } Failed:^(NSError * _Nonnull error) {
         finishedBlock(NO, nil);
     }];
    
}

-(void)updatePraiseStatusByFollowUUID:(NSNumber*)followUUID
                         andAttention:(NSNumber*)attention
                   andFinishBlock:(void (^)(BOOL bSuccess, NSError *errorMessage))finishBlock
{
    NSNumber *uuid = [BXGUserCenter share].userModel.itcast_uuid;
    NSString *sign = [BXGUserCenter share].userModel.sign;
    [[BXGNetWorkTool sharedTool] requestCommunityUpdateAttentionStatusWithConcernUUID:uuid
                                                                      andFollowerUUID:followUUID
                                                                           andOperate:attention
                                                                              andSign:sign
                                                                          andFinished:^(id  _Nullable responseObject)
     {
         [BXGNetworkParser communityNetworkParser:responseObject andFinished:^(NSInteger status, NSString *message, id result) {
             if(status == 200){
                 NSLog(@"success to update praise status");
                 finishBlock(YES, nil);
             }
             else {
                 NSLog(@"fail to update praise status");
                 finishBlock(NO, nil);
             }
         }];
         
     } Failed:^(NSError * _Nonnull error) {
         finishBlock(NO, error);
         NSLog(@"fail to update praise status");
     }];
}




@end
