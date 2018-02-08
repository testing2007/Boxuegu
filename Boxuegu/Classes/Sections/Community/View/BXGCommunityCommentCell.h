//
//  BXGCommunityCommentCell.h
//  Boxuegu
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BXGCommunityCommentDetailModel;
@protocol BXGCommunityOperationDelegate;

@interface BXGCommunityCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *portrainImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UITableView *replyTabelView;

-(void)setupCell:(BXGCommunityCommentDetailModel*)commentDetailModel
andTargetDelegate:(id<BXGCommunityOperationDelegate>)targetDelegate;

@end
