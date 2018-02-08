//
//  BXGNetWorkTool+Community.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGNetWorkTool.h"

/**
 学习圈 接口
 */
@interface BXGNetWorkTool (Community)
//-(void)requestCommunityServerWithType:(RequestType)type
//                            UrlString:(NSString* _Nullable) urlString
//                            Parameter:(id _Nullable)para
//                             Finished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
//                             Progress:(void(^ _Nullable)(NSProgress * _Nullable progress))progressBlock
//                               Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

-(void)requestCheckinAllWithFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                              Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
-(void)requestPostTopicListWithFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                 Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
// 话题列表 (发帖)
-(void)requestTopicListWithFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                            andSign:(NSString* _Nullable)sign
                             Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
// 我的粉丝列表
-(void)requestMyFanListWithUUID:(NSNumber *_Nullable)uuid
                      andPageNo:(NSNumber *_Nullable)pageNo
                    andPageSize:(NSNumber *_Nullable)pageSize
                        andSign:(NSString *_Nullable)sign
                    andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                         Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
-(void)requestUploadImgWithImageData:(NSData * _Nullable)imageData
                             andSign:(NSString * _Nullable)sign
                         andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                              Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

-(void)requestSavePostWithUUID:(NSNumber * _Nullable)uuid
                    andTopicId:(NSNumber * _Nullable)topicId
                    andContent:(NSString * _Nullable)content
              andImagePathList:(NSString * _Nullable)imagePathList
                   andLocation:(NSString * _Nullable)location
                   andUUIDList:(NSNumber * _Nullable)uuidList
                       andSign:(NSString * _Nullable)sign
                   andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                        Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

-(void)requestAttentionListWithUUID:(NSNumber * _Nullable)uuid
                          andPageNo:(NSNumber * _Nullable)pageNo
                        andPageSize:(NSNumber * _Nullable)pageSize
                            andSign:(NSString * _Nullable)sign
                        andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                             Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;


///帖子详情列表 根据帖子ID查询帖子评论, 参数postId, userId
-(void)requestCommunityPostCommentWithPostId:(NSNumber* _Nullable)postId
                                     andUUID:(NSNumber* _Nullable)uuid
                                     andSign:(NSString * _Nullable)sign
                                 andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                      Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

///根据帖子ID查询帖子详细信息, 参数postId, userId
-(void)requestCommunityPostDetailWithPostId:(NSNumber* _Nullable)postId
                                    andUUID:(NSNumber* _Nullable)uuid
                                    andSign:(NSString * _Nullable)sign
                                andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                     Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

///根据帖子ID查询点赞用户的列表, 参数postId, userId, pageNo, pageSize=15
-(void)requestCommunityPraisePersonListWithPostId:(NSNumber* _Nullable)postId
                                          andUUID:(NSNumber* _Nullable)uuid
                                        andPageNo:(NSNumber * _Nullable)pageNo
                                      andPageSize:(NSNumber * _Nullable)pageSize
                                          andSign:(NSString * _Nullable)sign
                                      andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                           Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

///根据帖子ID保存评论, 参数postId, userId, content
-(void)requestCommunitySaveCommentWithPostId:(NSNumber* _Nullable)postId
                                     andUUID:(NSNumber* _Nullable)uuid
                                andCommentId:(NSNumber* _Nullable)commentId
                              andReplyedUUID:(NSNumber* _Nullable)replyedUUID
                                     content:(NSString* _Nullable)content
                                     andSign:(NSString * _Nullable)sign
                                 andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                      Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

///根据帖子ID和用户ID和评论ID回复评论,参数postId, userId, commentId, replyedUserId, content
-(void)requestCommunitySaveReplyedCommentWithPostId:(NSNumber* _Nullable)postId
                                            andUUID:(NSNumber* _Nullable)uuid
                                       andCommentId:(NSNumber* _Nullable)commentId
                                        replyedUUID:(NSString* _Nullable)replyedUUID
                                            content:(NSString* _Nullable)content
                                            andSign:(NSString * _Nullable)sign
                                        andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                             Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

///评论回复的回复 根据帖子ID和用户ID和评论ID回复评论, 参数postId, userId, commentId, replyedUserId, content
-(void)requestCommunitySaveReplyedReplyWithPostId:(NSNumber* _Nullable)postId
                                          andUUID:(NSNumber* _Nullable)uuid
                                        commentId:(NSNumber* _Nullable)commentId
                                          replyId:(NSNumber* _Nullable)replyId
                                      replyedUUID:(NSNumber* _Nullable)replyedUUID
                                          content:(NSString* _Nullable)content
                                          andSign:(NSString * _Nullable)sign
                                      andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                           Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

///根据关注用户ID和被关注者用户ID进行关注(取消关注)操作, 参数: 关注者userId-自己, 被关注者followerId
-(void)requestCommunityUpdateAttentionStatusWithConcernUUID:(NSNumber* _Nullable)concernUUID
                                            andFollowerUUID:(NSNumber* _Nullable)followerUUID
                                                 andOperate:(NSNumber* _Nullable)operate
                                                    andSign:(NSString * _Nullable)sign
                                                andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                                     Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

///根据帖子Id收藏帖子, 参数: postId, userId
-(void)requestCommunityUpdateCollectionWithPostId:(NSNumber* _Nullable)postId
                                          andUUID:(NSNumber* _Nullable)uuid
                                          andSign:(NSString * _Nullable)sign
                                      andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                           Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;


///根据评论ID更新评论赞的状态, 参数: commentId, userId
-(void)requestCommunityUpdateCommentPraiseStatusWithCommentId:(NSNumber* _Nullable)commentId
                                                      andUUID:(NSNumber* _Nullable)uuid
                                                    andPostId:(NSNumber* _Nullable)postId
                                             andPraisedUserId:(NSNumber* _Nullable)praisedUserId
                                                   andOperate:(NSNumber * _Nullable)operate
                                                      andSign:(NSString * _Nullable)sign
                                                  andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                                       Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;


///根据帖子ID更新帖子赞的状态, 参数: postId, userId
-(void)requestCommunityUpdatePraiseStatusWithPosetId:(NSNumber* _Nullable)postId
                                             andUUID:(NSNumber* _Nullable)uuid
                                          andOperate:(NSNumber * _Nullable)operate
                                    andPraisedUserId:(NSNumber* _Nullable)praisedUserId
                                             andSign:(NSString * _Nullable)sign
                                         andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                              Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

/// 帖子列表
-(void)requestPostListWithTopicId:(NSNumber * _Nullable)topicId
                        andPageNo:(NSNumber * _Nullable)pageNo
                      andPageSize:(NSNumber * _Nullable)pageSize
                      andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                           Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

-(void)requestAttentionPersonListWithUUID:(NSNumber *_Nullable)uuid
                                andPageNo:(NSNumber *_Nullable)pageNo
                              andPageSize:(NSNumber *_Nullable)pageSize
                                  andSign:(NSString *_Nullable)sign
                              andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                   Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

-(void)requestUserHomePostListWithSign:(NSString *_Nullable)sign andHomeUserId:(NSNumber * _Nullable)homeUserId
                             andUserId:(NSNumber *_Nullable)userId
                           andPageSize:(NSNumber *_Nullable)pageSize
                             andPageNo:(NSNumber *_Nullable)pageNo
                           andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
-(void)requestReportTypeListWithSign:(NSString * _Nullable)sign andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                              Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

-(void)requestSaveReportWithUUID:(NSNumber * _Nullable)uuid
                         andType:(NSString * _Nullable)type
                 andReportTypeId:(NSNumber * _Nullable)reportTypeId
                      andContent:(NSString * _Nullable)content
                 andReportUserId:(NSNumber * _Nullable)reportUserId
                       andPostId:(NSNumber * _Nullable)postId
                    andCommentId:(NSNumber * _Nullable)commentId
                      andReplyId:(NSNumber * _Nullable)replyId
                         andSign:(NSString * _Nullable)sign
                     andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                          Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

-(void)requestIsBannedWithFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                        Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;
///首页：获取Banner列表 bbs/banner/getBannerList
- (void)requestBannerFinished:BXGNetworkFinishedBlockType finished andFailed:BXGNetworkFailedBlockType failed;

///根据回复ID更新回复赞的状态, 参数replyId, userId
-(void)requestCommunityUpdateReplyPraiseStatusWithReplyId:(NSNumber* _Nullable)replyId
                                                        andUUID:(NSNumber* _Nullable)uuid
                                                      andPostId:(NSNumber* _Nullable)postId
                                                     andOperate:(NSNumber* _Nullable)operate
                                               andPraisedUserId:(NSNumber* _Nullable)praisedUserId
                                                        andSign:(NSString* _Nullable)sign
                                                    andFinished:(void(^ _Nullable)(id _Nullable responseObject))finishedBlock
                                                         Failed:(void(^ _Nullable)(NSError * _Nonnull error))failedBlock;

///根据回复ID更新回复赞的状态, 参数replyId, userId
-(void)requestCommunityUpdateReplyPraiseStatusWithReplyId:(NSNumber* _Nullable)replyId
                                                      andPostId:(NSNumber* _Nullable)postId
                                                     andOperate:(NSNumber* _Nullable)operate
                                               andPraisedUserId:(NSNumber* _Nullable)praisedUserId
                                                    andFinished:(BXGNetworkCallbackBlockType _Nullable) finished;

@end
