//
//  BXGCommentViewModel.m
//  Boxuegu
//
//  Created by apple on 2017/9/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommentViewModel.h"
#import "BXGUserCenter.h"
#import "BXGNetworkParser.h"

@implementation BXGCommentViewModel

-(void)postSaveCommentByPostId:(NSNumber*)postId
                       // andUUID:(NSNumber*)uuid
                  andCommentId:(NSNumber*)commentId
                andReplyedUUID:(NSNumber*)replyedUUID
                    andContent:(NSString*)content
                andFinishBlock:(void (^)(BOOL bSuccess, NSError *error))finishBlock
{
    BXGUserCenter* center = [BXGUserCenter share];
    NSNumber *uuid = center.userModel.itcast_uuid;
    NSString *sign = center.userModel.sign;
    
    [[BXGNetWorkTool sharedTool] requestCommunitySaveCommentWithPostId:postId
                                                               andUUID:uuid
                                                          andCommentId:commentId
                                                        andReplyedUUID:replyedUUID
                                                               content:content
                                                               andSign:sign
                                                           andFinished:^(id  _Nullable responseObject)
    {
        [BXGNetworkParser communityNetworkParser:responseObject andFinished:^(NSInteger status, NSString *message, id result) {
            if(200==status) {
                finishBlock(YES, nil);
            }
            else {
                finishBlock(NO, nil);
            }
        }];
    } Failed:^(NSError * _Nonnull error) {
        finishBlock(NO, error);
    }];
}

// /postDetail/saveReplyedComment
-(void)postSaveReplyedCommentByPostId:(NSNumber*)postId
                       // andUUID:(NSNumber*)uuid
                    andContent:(NSString*)content
                         andCommentId:(NSNumber*)commentId
                     andReplyedUserId:(NSNumber*)replyedUserId
                       andFinishBlock:(void (^)(BOOL bSuccess, NSError *error))finishBlock
{
    BXGUserCenter* center = [BXGUserCenter share];
    NSNumber *uuid = center.userModel.itcast_uuid;
    NSString *sign = center.userModel.sign;
    
    [self.networkTool requestCommunitySaveReplyedCommentWithPostId:postId
                                                           andUUID:uuid
                                                      andCommentId:commentId
                                                       replyedUUID:replyedUserId
                                                           content:content
                                                           andSign:sign
                                                       andFinished:^(id  _Nullable responseObject) {
        [BXGNetworkParser communityNetworkParser:responseObject andFinished:^(NSInteger status, NSString *message, id result) {
            if(200==status) {
                finishBlock(YES, nil);
            }
            else {
                finishBlock(NO, nil);
            }
        }];
    } Failed:^(NSError * _Nonnull error) {
        finishBlock(NO, error);
    }];
}


-(void)postSaveReplyedReplyByPostId:(NSNumber*)postId
//                       andUUID:(NSNumber*)uuid
                    andContent:(NSString*)content
                    andCommentId:(NSNumber*)commentId
                       andReplyId:(NSNumber*)replyid
                       andReplyedId:(NSNumber*)replyeduuid
                andFinishBlock:(void (^)(BOOL bSuccess, NSError *error))finishBlock
{
    BXGUserCenter* center = [BXGUserCenter share];
    NSNumber *uuid = center.userModel.itcast_uuid;
    NSString *sign = center.userModel.sign;
    
    
    [[BXGNetWorkTool sharedTool] requestCommunitySaveReplyedReplyWithPostId:postId
                                                                    andUUID:uuid
                                                                  commentId:commentId
                                                                    replyId:replyid
                                                                replyedUUID:replyeduuid
                                                                    content:content
                                                                    andSign:sign
                                                                andFinished:^(id  _Nullable responseObject) {
                                                                    
        [BXGNetworkParser communityNetworkParser:responseObject andFinished:^(NSInteger status, NSString *message, id result) {
            if(200==status) {
                finishBlock(YES, nil);
            }
            else {
                finishBlock(NO, nil);
            }
        }];
    } Failed:^(NSError * _Nonnull error) {
        finishBlock(NO, error);
    }];;
}

@end
