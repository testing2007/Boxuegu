//
//  BXGCommentVC.h
//  Boxuegu
//
//  Created by apple on 2017/9/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGBaseRootVC.h"
#import "BXGCommunityCommentDetailModel.h"
#import "BXGCommunityCommentReplyModel.h"
#import "BXGCommunityDetailModel.h"
#import "BXGCommunityPostModel.h"



typedef void(^CommentFinishedBlockType)(BOOL succeed);
@interface BXGCommentVC : BXGBaseRootVC

//-(instancetype)initCommentType:(CommentType)commentType
//andCommunityCommentDetailModel:(BXGCommunityCommentDetailModel*)commentModel
//andCommunityCommentReplyModel:(BXGCommunityCommentReplyModel*)replyModel;

- (instancetype)initForPostCommentWithPostModel:(BXGCommunityDetailModel *)postModel;
- (instancetype)initForPostCommentWithAttentionPostModel:(BXGCommunityPostModel *)postModel;
- (instancetype)initForPostCommentReplyCommentWithCommentModel:(BXGCommunityCommentDetailModel *)commentModel;
- (instancetype)initForPostCommentReplyReplyWithReplyModel:(BXGCommunityCommentReplyModel *)replyModel;
@property (nonatomic, copy) CommentFinishedBlockType commentFinishedBlock;
@end
