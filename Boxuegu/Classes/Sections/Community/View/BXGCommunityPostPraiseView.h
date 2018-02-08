//
//  BXGCommunityPostPraiseView.h
//  Boxuegu
//
//  Created by apple on 2017/9/5.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BXGCommunityPostPraiseViewDelegate;
@class BXGCommunityDetailModel;

@interface BXGCommunityPostPraiseView : UIView

-(void)installUIDelgate:(id<BXGCommunityPostPraiseViewDelegate>)delegate
 addCommunityDetailModel:(BXGCommunityDetailModel*)detailModel;

@property(nonatomic, weak) id<BXGCommunityPostPraiseViewDelegate> delegate;

@end
