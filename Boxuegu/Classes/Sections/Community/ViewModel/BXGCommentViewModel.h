//
//  BXGCommentViewModel.h
//  Boxuegu
//
//  Created by apple on 2017/9/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseViewModel.h"

@interface BXGCommentViewModel : BXGBaseViewModel

-(void)postSaveCommentByPostId:(NSNumber*)postId
                       // andUUID:(NSNumber*)uuid
                  andCommentId:(NSNumber*)commentId
                andReplyedUUID:(NSNumber*)replyedUUID
                    andContent:(NSString*)content
                andFinishBlock:(void (^)(BOOL bSuccess, NSError *error))finishBlock;
-(void)postSaveReplyedCommentByPostId:(NSNumber*)postId
                              // andUUID:(NSNumber*)uuid
                           andContent:(NSString*)content
                         andCommentId:(NSNumber*)commentId
                     andReplyedUserId:(NSNumber*)replyedUserId
                       andFinishBlock:(void (^)(BOOL bSuccess, NSError *error))finishBlock;


-(void)postSaveReplyedReplyByPostId:(NSNumber*)postId
//                       andUUID:(NSNumber*)uuid
                         andContent:(NSString*)content
                       andCommentId:(NSNumber*)commentId
                         andReplyId:(NSNumber*)replyid
                       andReplyedId:(NSNumber*)replyeduuid
                     andFinishBlock:(void (^)(BOOL bSuccess, NSError *error))finishBlock;
@end
