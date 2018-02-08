//
//  BXGCommunityDetailViewModel.h
//  Boxuegu
//
//  Created by apple on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"

@class BXGCommunityUserModel;
@class BXGCommunityDetailModel;
@class BXGCommunityCommentDetailModel;

@interface BXGCommunityDetailViewModel : BXGBaseViewModel

@property(nonatomic, strong) BXGCommunityDetailModel * _Nullable communityDetailModel;
@property(nonatomic, strong) NSArray<BXGCommunityCommentDetailModel*> * _Nullable arrCommentityCommentDetailModel;

-(void)requestCommunityId:(NSNumber *_Nullable)communityId
           andDetailBlock:(void(^_Nullable)(BOOL succeed, NSString * _Nullable errorMessage))finishedBlock;

-(void)requestCommunityCommentPostId:(NSNumber *_Nullable)postId
                      andDetailBlock:(void(^_Nullable)(BOOL succeed, NSString * _Nullable errorMessage))finishedBlock;


- (void)thumbCommentWithCommentId:(NSNumber *_Nullable)commentId
                        andPostId:(NSNumber *_Nullable)postId
                    andPostUserId:(NSNumber * _Nullable)postUserId
                       andOperate:(NSNumber *_Nullable)isThumb
                      andFinished:(void(^ _Nullable)(BOOL succeed))finishedBlock;

- (void)thumbPostWithPostId:(NSNumber * _Nullable)postId
                 andOperate:(NSNumber *_Nullable)isThumb
              andPostUserId:(NSNumber * _Nullable)postUserId
                andFinished:(void(^ _Nullable)(BOOL succeed))finishedBlock;

-(void)updatePraiseStatusByFollowUUID:(NSNumber* _Nullable)followUUID
                         andAttention:(NSNumber* _Nullable)attention
                       andFinishBlock:(void (^ _Nullable)(BOOL bSuccess, NSError * _Nullable errorMessage))finishBlock;
@end
