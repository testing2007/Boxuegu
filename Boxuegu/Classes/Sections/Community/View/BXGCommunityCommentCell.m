//
//  BXGCommunityCommentCell.m
//  Boxuegu
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "BXGCommunityCommentCell.h"
#import "BXGCommunityOperationDelegate.h"
#import "BXGCommunityCommentDetailModel.h"

@interface BXGCommunityCommentCell()

@property(nonatomic, weak) id<BXGCommunityOperationDelegate> delegate;

@end

@implementation BXGCommunityCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupCell:(BXGCommunityCommentDetailModel*)commentDetailModel
andTargetDelegate:(id<BXGCommunityOperationDelegate>)targetDelegate
{
    [self.portrainImageView sd_setImageWithURL:[NSURL URLWithString:commentDetailModel.smallHeadPhoto]
                              placeholderImage:[UIImage imageNamed:@"默认头像"]];
    self.contentLable.text = commentDetailModel.content;
    
}

@end
