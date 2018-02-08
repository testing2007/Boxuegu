//
//  BXGCommunityDetailBottomView.h
//  Boxuegu
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BXGCommunityOperationDelegate;

@interface BXGCommunityDetailBottomView : UIView

@property(nonatomic, weak) id<BXGCommunityOperationDelegate> delegate;

@end
