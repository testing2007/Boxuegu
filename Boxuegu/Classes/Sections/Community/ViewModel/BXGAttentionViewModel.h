//
//  BXGAttentionViewModel.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"
#import "BXGCommunityPostModel.h"

@interface BXGAttentionViewModel : BXGBaseViewModel
- (void)loadPostListWithIsReflesh:(BOOL)isReflesh andFinished:(void(^_Nullable)(NSArray<BXGCommunityPostModel *> * _Nullable modelArray, BOOL isNoMore))finishedBlock;

- (void)loadHomePostListWithIsReflesh:(BOOL)isReflesh andFinished:(void(^_Nullable)(NSArray<BXGCommunityPostModel *> * _Nullable modelArray, BOOL isReflesh))finishedBlock;

-(void)requestCommunityId:(NSNumber *_Nullable)communityId
           andDetailBlock:(void(^_Nullable)(BOOL succeed, NSString * _Nullable errorMessage))finishedBlock;

-(void)requestCommunityCommentPostId:(NSNumber *_Nullable)postId
                      andDetailBlock:(void(^_Nullable)(BOOL succeed, NSString * _Nullable errorMessage))finishedBlock;

- (void)thumbCommentWithCommentId:(NSNumber *_Nullable)commentId
                       andOperate:(BOOL)isThumb
                      andFinished:(void(^ _Nullable)(BOOL succeed))finishedBlock ;

- (void)thumbPostWithPostId:(NSNumber *_Nullable)postId
                 andOperate:(BOOL)isThumb
              andPostUserId:(NSNumber *_Nullable)postUserId
                andFinished:(void(^ _Nullable)(BOOL succeed))finishedBlock;


@end
