//
//  BXGCommunityCommentInputView.h
//  Boxuegu
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BXGCommunityCommentInputViewDelegate.h"

@interface BXGCommunityCommentInputView : UIView
@property(nonatomic, weak) id<BXGCommunityCommentInputViewDelegate> delegate;
@end
