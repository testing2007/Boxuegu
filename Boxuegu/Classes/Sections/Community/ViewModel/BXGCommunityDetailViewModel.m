//
//  BXGCommunityDetailViewModel.m
//  Boxuegu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityDetailViewModel.h"
#import "BXGCommunityDetailModel.h"
#import "BXGCommunityUserModel.h"
#import "BXGUserCenter.h"
#import "BXGCommunityCommentDetailModel.h"



@implementation BXGCommunityDetailViewModel

//-(void)requestCommunityDetailInfoWithFinish:(void (^)(BXGCommunityDetailModel*))finishBlock;
-(void)requestCommunityId:(NSNumber *)communityId
           andDetailBlock:(void(^)(BOOL succeed, NSString *errorMessage))finishedBlock
{
    NSNumber *uuid = [BXGUserCenter share].userModel.itcast_uuid;
    NSString *sign = [BXGUserCenter share].userModel.sign;
    
    __weak typeof (self) weakSelf = self;
    [self.networkTool requestCommunityPostDetailWithPostId:communityId
                                                   andUUID:uuid
                                                   andSign:sign
                                               andFinished:^(id  _Nullable responseObject) {
                                                   if(responseObject){
                                                       id statusValue = responseObject[@"status"];
                                                       if([statusValue isKindOfClass:[NSNumber class]] &&
                                                          ((NSNumber*)statusValue).integerValue==200){
                                                           id resultObjectValue = responseObject[@"result"];
                                                           if([resultObjectValue isKindOfClass:[NSDictionary class]]){
                                                               
                                                               BXGCommunityDetailModel *model = [BXGCommunityDetailModel yy_modelWithDictionary:resultObjectValue];
                                                               weakSelf.communityDetailModel = model;
                                                               finishedBlock(true,@"加载成功");
                                                               return;
                                                           }else {
                                                               // todo not success
                                                               weakSelf.communityDetailModel = nil;
                                                               finishedBlock(false,@"未知错误 -3");
                                                               return;
                                                           }
                                                       }else {
                                                           // todo not success
                                                           weakSelf.communityDetailModel = nil;
                                                           finishedBlock(false,@"未知错误 -2");
                                                           return;
                                                       }
                                                   }else {
                                                       // todo error
                                                       weakSelf.communityDetailModel = nil;
                                                       finishedBlock(false,@"未知错误 -1");
                                                       return;
                                                   }
                                               } Failed:^(NSError * _Nonnull error) {
                                                   weakSelf.communityDetailModel = nil;
                                                   finishedBlock(false,kBXGToastNoNetworkError);
                                               }];
}

-(void)requestCommunityCommentPostId:(NSNumber *)postId
                       andDetailBlock:(void(^)(BOOL succeed, NSString *errorMessage))finishedBlock
{
    NSNumber *uuid = [BXGUserCenter share].userModel.itcast_uuid;
    NSString *sign = [BXGUserCenter share].userModel.sign;
    
    __weak typeof (self) weakSelf = self;
    [self.networkTool requestCommunityPostCommentWithPostId:postId
                                                    andUUID:uuid
                                                    andSign:sign
                                                andFinished:^(id  _Nullable responseObject) {
                                                   if(responseObject){
                                                       id statusValue = responseObject[@"status"];
                                                       if([statusValue isKindOfClass:[NSNumber class]] &&
                                                          ((NSNumber*)statusValue).integerValue==200){
                                                           id arrResultObjectValue = responseObject[@"result"];
                                                           if([arrResultObjectValue isKindOfClass:[NSArray class]]){
                                                               NSMutableArray *arrCommentityCommentDetailModel = [NSMutableArray new];
                                                               for (id resultObjectValue in arrResultObjectValue) {
                                                                   BXGCommunityCommentDetailModel *model = [BXGCommunityCommentDetailModel yy_modelWithDictionary:resultObjectValue];
                                                                   [arrCommentityCommentDetailModel addObject:model];
                                                               }
                                                               weakSelf.arrCommentityCommentDetailModel = [NSMutableArray arrayWithArray: arrCommentityCommentDetailModel];
                                                               finishedBlock(true,@"加载成功");
                                                           }else {
                                                               // todo not success
                                                               weakSelf.communityDetailModel = nil;
                                                               finishedBlock(false,@"未知错误 -3");
                                                           }
                                                       }else {
                                                           // todo not success
                                                           weakSelf.communityDetailModel = nil;
                                                           finishedBlock(false,@"未知错误 -2");
                                                       }
                                                   }else {
                                                       // todo error
                                                       weakSelf.communityDetailModel = nil;
                                                       finishedBlock(false,@"未知错误 -1");
                                                   }
                                               } Failed:^(NSError * _Nonnull error) {
                                                   weakSelf.communityDetailModel = nil;
                                                   finishedBlock(false,kBXGToastNoNetworkError);
                                               }];
}


- (void)thumbCommentWithCommentId:(NSNumber *)commentId
                        andPostId:(NSNumber *)postId
                    andPostUserId:(NSNumber *)postUserId
                       andOperate:(NSNumber *)isThumb
                      andFinished:(void(^ _Nullable)(BOOL succeed))finishedBlock {

    NSNumber *uuid = [BXGUserCenter share].userModel.itcast_uuid;
    NSString *sign = [BXGUserCenter share].userModel.sign;
    
    [self.networkTool requestCommunityUpdateCommentPraiseStatusWithCommentId:commentId
                                                                  andUUID:uuid
                                                                andPostId:postId
                                                         andPraisedUserId:postUserId
                                                               andOperate:isThumb
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

static void extracted(BXGCommunityDetailViewModel *object, void (^ _Nullable finishedBlock)(BOOL), NSNumber * _Nullable isThumb, NSNumber * _Nullable postId, NSNumber * _Nullable postUserId, NSString *sign, NSNumber *uuid) {
    [object.networkTool requestCommunityUpdatePraiseStatusWithPosetId:postId
                                                              andUUID:uuid
                                                           andOperate:isThumb
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

- (void)thumbPostWithPostId:(NSNumber *)postId
                 andOperate:(NSNumber *)isThumb
              andPostUserId:(NSNumber *)postUserId
                andFinished:(void(^ _Nullable)(BOOL succeed))finishedBlock {
    
    NSNumber *uuid = [BXGUserCenter share].userModel.itcast_uuid;
    NSString *sign = [BXGUserCenter share].userModel.sign;
    
    extracted(self, finishedBlock, isThumb, postId, postUserId, sign, uuid);
}

//
////根据评论ID更新评论赞的状态, 参数: commentId, userId
//-(void)requestCommunityUpdateCommentPraiseStatusWithCommentId:(NSNumber* _Nullable)commentId
//                                                   andUUID:(NSNumber* _Nullable)uuid
//                                                   andSign:(NSString * _Nullable)sign
//                                               andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
//                                                    Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
//
//
////根据帖子ID更新帖子赞的状态, 参数: postId, userId
//-(void)requestCommunityUpdatePraiseStatusWithPosetId:(NSNumber* _Nullable)postId
//                                          andUUID:(NSNumber* _Nullable)uuid
//                                          andSign:(NSString * _Nullable)sign
//                                      andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
//                                           Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
//
////根据回复ID更新回复赞的状态, 参数replyId, userId
//-(void)requestCommunityUpdateUpdateReplyPraiseStatusWithReplyId:(NSNumber* _Nullable)replyId
//                                                     andUUID:(NSNumber* _Nullable)uuid
//                                                     andSign:(NSString * _Nullable)sign
//                                                 andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
//                                                      Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
//@end


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
