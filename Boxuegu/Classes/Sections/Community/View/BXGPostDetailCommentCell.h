//
//  BXGPostDetailCommentCell.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGCommunityCommentDetailModel.h"
#import "BXGCommunityCommentReplyModel.h"
@class BXGPostDetailCommentCell;
typedef void(^TapViewBlockType)(BXGCommunityCommentReplyModel *model);

typedef void(^ClickReportCommentBtnBlockType)(BXGCommunityCommentDetailModel *commentModel);
typedef void(^ClickMsgBtnBlockType)(BXGCommunityCommentDetailModel *commentModel);
typedef void(^ClickPraiseThumbBtnBlockType)(BXGCommunityCommentDetailModel *commentModel);

@interface BXGPostDetailCommentCell : UITableViewCell
@property (nonatomic, strong) BXGCommunityCommentDetailModel *model;
@property (nonatomic, copy) ClickReportCommentBtnBlockType clickReportCommentBtnBlock;
@property (nonatomic, copy) ClickMsgBtnBlockType clickMsgBtnBlock;
@property (nonatomic, copy) ClickPraiseThumbBtnBlockType clickPraiseThumbBtnBlock;
@property (nonatomic, copy) TapViewBlockType tapReplyViewBlock;

@end
