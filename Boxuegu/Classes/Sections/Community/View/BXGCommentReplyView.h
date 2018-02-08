//
//  BXGCommentReplyView.h
//  Boxuegu
//
//  Created by RenyingWu on 2017/9/6.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGCommunityCommentReplyModel.h"

typedef void(^TapViewBlockType)(BXGCommunityCommentReplyModel *model);

@interface BXGCommentReplyView : UIView

@property (nonatomic, strong) BXGCommunityCommentReplyModel *model;
@property (nonatomic, copy) TapViewBlockType tapViewBlock;
@end
